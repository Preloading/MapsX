#import <Foundation/Foundation.h>

@interface GEOAltitudeManifest : NSObject
+ (id)sharedManager;
- (unsigned)versionForRegion:(unsigned)region;
@end

void GEOTileKeyMake(uint32_t *key, unsigned x, unsigned y, unsigned z, unsigned type, unsigned pixelSize, unsigned textScale, unsigned provider, BOOL expires);
static NSURL *(*signURL)(NSURL *url, NSString *token); // cause changing parameters breaks the signature, so re-sign it here

%group AltitudePatches
%hookf(void, GEOTileKeyMake, uint32_t *key, unsigned x, unsigned y, unsigned z, unsigned type, unsigned pixelSize, unsigned textScale, unsigned provider, BOOL expires) {
    %orig;
    if (type >= 14 && type <= 16) {
        key[3] = pixelSize;
        if (type == 14) key[1] = (key[1] & 4227858432u) | ((pixelSize >> 8) & 67108863u);
    }
}

%hook GEOVoltaireSimple3DTileRequester

- (unsigned)tileEditionForKey:(uint32_t *)key {
    unsigned type = key[1] >> 26;
    if (type >= 14 && type <= 16 && key[3] > 255) return [[GEOAltitudeManifest sharedManager] versionForRegion:key[3]];
    return %orig;
}

- (id)urlForTileKey:(uint32_t *)key {
    NSURL *url = %orig;
    unsigned type = key[1] >> 26;
    if (type < 14 || type > 16 || key[3] <= 255 || ![url isKindOfClass:[NSURL class]]) return url;
    NSString *urlString = [url absoluteString];
    NSRange signature = [urlString rangeOfString:@"sid="];
    if (signature.location != NSNotFound && signature.location > 0) urlString = [urlString substringToIndex:signature.location - 1];
    NSString *region = [NSString stringWithFormat:@"%u", key[3]];
    NSString *version = [NSString stringWithFormat:@"%u", [[GEOAltitudeManifest sharedManager] versionForRegion:key[3]]];
    NSRegularExpression *regionRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=[?&]region=)\\d+" options:0 error:nil];
    NSRegularExpression *versionRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=[?&]v=)\\d+" options:0 error:nil];
    urlString = [regionRegex stringByReplacingMatchesInString:urlString options:0 range:NSMakeRange(0, [urlString length]) withTemplate:region];
    urlString = [versionRegex stringByReplacingMatchesInString:urlString options:0 range:NSMakeRange(0, [urlString length]) withTemplate:version];
    return signURL([NSURL URLWithString:urlString], nil);
}

%end
%end

%group FlyoverRegions
%hook GEOResourceManager

- (NSData *)dataForResourceWithName:(NSString *)name fallbackBundle:(NSBundle *)bundle {
    if ([name isEqualToString:@"altitude.xml"]) {
        NSData *data = [NSData dataWithContentsOfFile:@"/private/var/mobile/Library/Caches/GeoServices/altitude-mapsx.xml"];
        if (data) return data;
    }
    return %orig;
}

%end

%hook GEOResourceManifestServer

- (id)init {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://repo.podpod123.com/tweakfiles/mapsx/altitude.xml"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:7.0] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *body, NSError *error) {
        if (body && [(NSHTTPURLResponse *)response statusCode] == 200 && [body length] > 0) [body writeToFile:@"/private/var/mobile/Library/Caches/GeoServices/altitude-mapsx.xml" atomically:YES];
    }];
    return %orig;
}

- (void)serverProxyDidChangeActiveTileGroup:(id)group finishedCallback:(id)callback {
    id callbackCopy = [callback copy]; // to work around a segmentation fault on geod. because it's async, it was calling orig after the memory was reclaimed. copy to heap first.
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://repo.podpod123.com/tweakfiles/mapsx/altitude.xml"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:7.0] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *body, NSError *error) {
        if (body && [(NSHTTPURLResponse *)response statusCode] == 200 && [body length] > 0) [body writeToFile:@"/private/var/mobile/Library/Caches/GeoServices/altitude-mapsx.xml" atomically:YES];
        %orig(group, callbackCopy);
    }];
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