#import <Foundation/Foundation.h>

typedef uint32_t GEOTileKey;

@interface GEOAltitudeManifest : NSObject
+ (id)sharedManager;
- (unsigned)versionForRegion:(unsigned)region;
@end

@interface _GEOResourceInfo : NSObject
- (NSString *)name;
@end

@interface GEOResourceInfo : NSObject
- (NSString *)name;
@end

@interface GEOVoltaireSimple3DTileRequester : NSObject
- (NSString *)_baseURLStringForTileKey:(GEOTileKey *)key;
@end

void GEOTileKeyMake(GEOTileKey *key, unsigned x, unsigned y, unsigned z, unsigned type, unsigned pixelSize, unsigned textScale, unsigned provider, BOOL expires);
static NSURL *(*signURL)(NSURL *url, NSString *token); // cause changing parameters breaks the signature, so re-sign it here

%group AltitudePatches
%hookf(void, GEOTileKeyMake, GEOTileKey *key, unsigned x, unsigned y, unsigned z, unsigned type, unsigned pixelSize, unsigned textScale, unsigned provider, BOOL expires) {
    %orig;
    if (type >= 14 && type <= 16) {
        key[3] = pixelSize;
        if (type == 14) key[1] = (key[1] & 4227858432u) | ((pixelSize >> 8) & 67108863u);
    }
}

%hook GEOVoltaireSimple3DTileRequester

- (unsigned)tileEditionForKey:(GEOTileKey *)key {
    unsigned type = key[1] >> 26;
    if (type >= 14 && type <= 16 && key[3] > 255) return [[GEOAltitudeManifest sharedManager] versionForRegion:key[3]];
    return %orig;
}

- (id)urlForTileKey:(GEOTileKey *)key {
    unsigned type = key[1] >> 26;
    if (type < 14 || type > 16 || key[3] <= 255) return %orig;
    unsigned version = [[GEOAltitudeManifest sharedManager] versionForRegion:key[3]];
    NSString *query;
    if (type == 14) query = [NSString stringWithFormat:@"style=14&v=%u&part=%u&region=%u", version, key[0] >> 6, key[3]];
    else if (type == 15) query = [NSString stringWithFormat:@"style=15&v=%u&region=%u&x=%u&y=%u&z=%u&h=%u", version, key[3], key[0] >> 6, key[1] & 67108863u, key[0] & 63, (key[2] >> 8) & 255];
    else if (type == 16) query = [NSString stringWithFormat:@"style=16&v=%u&region=%u&x=%u&y=%u&z=%u", version, key[3], key[0] >> 6, key[1] & 67108863u, key[0] & 63];
    NSString *base = [self _baseURLStringForTileKey:key];
    if (!base) return nil;
    NSString *separator = [base rangeOfString:@"?"].location != NSNotFound ? @"&" : @"?";
    return signURL([NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", base, separator, query]], nil);
}

%end
%end

%group FlyoverRegions
// iOS 6
%hook _GEOResourceInfo

- (NSURL *)url {
    if ([[self name] hasPrefix:@"altitude"] && [[self name] hasSuffix:@".xml"]) return [NSURL URLWithString:@"http://repo.podpod123.com/tweakfiles/mapsx/altitude.xml"];
    return %orig; 
}

%end

// iOS 7+
%hook GEOResourceInfo

- (NSURL *)url {
    if ([[self name] hasPrefix:@"altitude"] && [[self name] hasSuffix:@".xml"]) return [NSURL URLWithString:@"http://repo.podpod123.com/tweakfiles/mapsx/altitude.xml"];
    return %orig;
}

- (id)checksum {
    if ([[self name] hasPrefix:@"altitude"] && [[self name] hasSuffix:@".xml"]) return nil;
    return %orig;
}

%end
%end

%ctor {
    if (kCFCoreFoundationVersionNumber < 847.20) { // only for ios 6 since it works fine on ios 7 and later
        signURL = (NSURL *(*)(NSURL *, NSString *))MSFindSymbol(NULL, "_GEOURLAuthenticationGenerateURL");
        %init(AltitudePatches);
    }
    %init(FlyoverRegions);
}