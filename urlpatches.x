#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Protobufs.h"
#import <substrate.h>

%group EnableURLPatches
%hook GEOResourceManifestServerLocalProxy

- (id)_manifestURL {
    id originalURL = %orig;
    NSLog(@"[MapsX] Original Manifest URL: %@", originalURL);

    NSString *newURLString;
    if (kCFCoreFoundationVersionNumber >= 847.20 && kCFCoreFoundationVersionNumber <= 847.27) { // iOS 7
        newURLString = [originalURL stringByReplacingOccurrencesOfString:@"https://gspa35-ssl.ls.apple.com" withString:@"https://gspe35-ssl.ls.apple.com"];
    }
    else if (kCFCoreFoundationVersionNumber < 847.20) { // iOS 6
        newURLString = ([originalURL rangeOfString:@"hidpi"].location != NSNotFound) ? @"http://gspe21-ssl.ls.apple.com/config/prod-resources-hidpi-20" : @"http://gspe21-ssl.ls.apple.com/config/prod-resources-lodpi-20";
    }

    // Return the new URL
    return (newURLString) ? newURLString : originalURL;
}

%end


// %hook GEOActiveTileGroup
// baseURLStringForTileKey:

// %end
// -[GEOActiveTileGroup ]

NSString *URLPatches(NSString *baseURL) {
    if ([@"http://gspa19.ls.apple.com/tile.vf" isEqualToString:baseURL]) { // reqular
        return @"http://gspe19.ls.apple.com/tile.vf";
    } else if ([@"http://gspa19.ls.apple.com/tile.vf?flags=4" isEqualToString:baseURL]) { // reqular with flag 4 (driving)
        return @"http://gspe19.ls.apple.com/tile.vf?flags=4";
    } else if ([@"http://gspa12.ls.apple.com/traffic" isEqualToString:baseURL]) { // traffic
        return @"http://gspe12.ls.apple.com/traffic";
    } else if ([@"http://gspa11.ls.apple.com/tile" isEqualToString:baseURL]) { // sat
        return @"http://gspe11.ls.apple.com/tile";
    }
    return baseURL;
}

%hook GEOActiveTileSet
-(NSString*)baseURL {
    NSString *baseURL = %orig;
    return URLPatches(baseURL);
}

-(NSString*)localizationURL {
    NSString *baseURL = %orig;
    return URLPatches(baseURL);
}

// cool feature, seems to be borked
// -(NSString*)multiTileURL {
//     NSLog(@"multitile -> %@", %orig);
//     // return %orig;
//     return @"http://gspe19-ssl.ls.apple.com/tile.vf";
// }

%end

%hook GEOResources

-(id)resourcesURL {
    // NSLog(@"resourcesURL -> %@", %orig); // originally https://gspe21-ssl.ls.apple.com/
    return @"http://gspe21-ssl.ls.apple.com/";
}


%end
%end

%hook GEOCountryConfiguration

- (id)defaultForKey:(NSString *)key defaultValue:(id)defaultValue {
    Class GEOResourcesClass = objc_getClass("GEOResources");
    if ([key isEqualToString:@"GEOVoltaireSearchAttributionManifestURL"]) {
        NSString *value = objc_getAssociatedObject(GEOResourcesClass, (void *)(uintptr_t)33);
        if (value) {
            NSRange HTTPSRange = [value rangeOfString:@"https://"];
            if (HTTPSRange.location != NSNotFound) value = [value stringByReplacingCharactersInRange:HTTPSRange withString:@"http://"];
            return value;
        }
    }
    else if ([key isEqualToString:@"GEOLocalizedCategoriesURL"]) {
        NSString *value = objc_getAssociatedObject(GEOResourcesClass, (void *)(uintptr_t)55);
        if (value) {
            NSRange HTTPSRange = [value rangeOfString:@"https://"];
            if (HTTPSRange.location != NSNotFound) value = [value stringByReplacingCharactersInRange:HTTPSRange withString:@"http://"];
            return value;
        }
    }
    return %orig;
}

%end

%hookf(char, _GEOResourcesReadFrom, id self, PBDataReader *reader) {
    unsigned startPos = [reader position];
    Class GEOResourcesClass = objc_getClass("GEOResources");
    while ([reader hasMoreData] && ![reader hasError]) {
        unsigned short tag = 0;
        char type = 0;
        [reader readTag:&tag andType:&type];
        if (tag == 33 || tag == 55) {
            NSString *value = [reader readString];
            if (value) objc_setAssociatedObject(GEOResourcesClass, (void *)(uintptr_t)tag, value, OBJC_ASSOCIATION_RETAIN);
        }
        else {
            [reader skipValueWithTag:tag andType:type];
        }
    }
    [reader setPosition:startPos];
    return %orig(self, reader);
}

%ctor {
    void *sym = MSFindSymbol(NULL, "_GEOResourcesReadFrom");
    %init(_GEOResourcesReadFrom=sym);
	if (kCFCoreFoundationVersionNumber <= 847.27) { // ios 8 and later don't need these
		%init(EnableURLPatches);
	}
}