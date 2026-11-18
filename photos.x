#import <Foundation/Foundation.h>
#import "GeoHeaders.h"

static NSMutableArray *muids = nil;

%hook GEOBusiness

- (unsigned long long)uID {
    unsigned long long orig = %orig;
    // NSLog(@"[MapsX] muid: %llu", orig);
    if (orig) [muids addObject:[NSString stringWithFormat:@"%llu", orig]];
    return orig;
}

%end

%hook GEOPlaceSearchResponse

// do readFrom cause it's where the stuff is all parsed, but nothing is used in it yet. this allows us to gather all the different business muids in the response and do whatever.
- (BOOL)readFrom:(id)arg1 {
    BOOL orig = %orig;
    muids = [NSMutableArray array];
    for (GEOPlaceResult *placeResult in [self placeResults]) {
        for (GEOBusiness *business in [[placeResult place] business]) [business uID];
    }
    if (!muids.count) return orig;
    NSMutableArray *requestPlaces = [NSMutableArray array];
    for (NSString *muid in muids) [requestPlaces addObject:@{@"muid": muid}];
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:@{@"places": requestPlaces} options:0 error:nil];
    // NSLog(@"[MapsX] photos request body: %@", [[NSString alloc] initWithData:requestBody encoding:NSUTF8StringEncoding]);
    muids = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://maps.apple.com/data/place"]]; // requires tls 1.3 so user needs http proxy or tlsfix or some other way to connect
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = requestBody;
    request.timeoutInterval = 4;
    __block NSData *responseData = nil;
    __block BOOL done = NO;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) responseData = data;
        done = YES;
    }];
    NSDate *deadline = [NSDate dateWithTimeIntervalSinceNow:5];
    while (!done && [deadline timeIntervalSinceNow] > 0) {
        if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]]) [NSThread sleepForTimeInterval:0.01];
    }
    if (!responseData) return orig;
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    if (![responseJSON isKindOfClass:[NSDictionary class]]) return orig;
    NSMutableDictionary *placesByMuid = [NSMutableDictionary dictionary];
    for (NSDictionary *place in responseJSON[@"places"]) placesByMuid[place[@"muid"]] = place;
    // size is an enum, rather than a pixel size. confusing. 8 is large, 4 is medium.
    NSArray *photoSizes = @[@8, @4];
    NSArray *photoDimensions = @[@"600x400", @"100x100"];
    for (GEOPlaceResult *placeResult in [self placeResults]) {
        for (GEOBusiness *business in [[placeResult place] business]) {
            NSString *muid = [NSString stringWithFormat:@"%llu", [business uID]];
            NSMutableArray *GEOPhotos = [NSMutableArray array];
            NSMutableSet *seenPhotoIDs = [NSMutableSet set];
            // the json is a mess. it's so ridiculously long and it lags textedit. unfortunately no other json endpoint provides photo urls. it's either this or dispatcher.arpc. yuck.
            for (NSDictionary *component in placesByMuid[muid][@"component"]) {
                if (![component[@"type"] isEqual:@"COMPONENT_TYPE_CATEGORIZED_PHOTOS"]) continue; // using isEqual not isEqualToString just in case the value isn't a string. it will crash if you try to do isEqualToString on something that isn't a string. shouldn't ever be the case, but you never know.
                for (NSDictionary *categoryValue in component[@"value"]) {
                    for (NSDictionary *photoItem in categoryValue[@"categorizedPhotos"][@"photo"]) {
                        NSDictionary *photo = photoItem[@"photo"];
                        if ([seenPhotoIDs containsObject:photo[@"photoId"]]) continue;
                        [seenPhotoIDs addObject:photo[@"photoId"]];
                        NSString *templateURL = nil;
                        NSString *regularURL = nil;
                        for (NSDictionary *photoVersion in photo[@"photoVersion"]) {
                            if ([photoVersion[@"urlType"] isEqual:@"URL_TYPE_AMP_TEMPLATE"]) templateURL = photoVersion[@"url"];
                            else regularURL = photoVersion[@"url"];
                        }
                        NSMutableArray *GEOPhotoInfos = [NSMutableArray array];
                        for (int index = 0; index < 2; index++) {
                            NSString *photoURL = regularURL;
                            if (templateURL) {
                                photoURL = [templateURL stringByReplacingOccurrencesOfString:@"{w}x{h}" withString:photoDimensions[index]];
                                photoURL = [photoURL stringByReplacingOccurrencesOfString:@"{f}" withString:@"jpg"];
                            }
                            if (!photoURL) continue;
                            GEOPhotoInfo *GEOPhotoInfo = [[NSClassFromString(@"GEOPhotoInfo") alloc] init];
                            [GEOPhotoInfo setUrl:photoURL];
                            [GEOPhotoInfo setSize:[photoSizes[index] intValue]];
                            [GEOPhotoInfos addObject:GEOPhotoInfo];
                        }
                        if (!GEOPhotoInfos.count) continue;
                        GEOPhoto *GEOPhoto = [[NSClassFromString(@"GEOPhoto") alloc] init];
                        [GEOPhoto setUid:photo[@"photoId"]];
                        [GEOPhoto setPhotoInfos:GEOPhotoInfos];
                        [GEOPhotos addObject:GEOPhoto];
                    }
                }
            }
            if (GEOPhotos.count) {
                [business setPhotos:GEOPhotos];
                [business setTotalNumberOfPhotos:(unsigned int)GEOPhotos.count];
            }
        }
    }
    return orig;
}

%end