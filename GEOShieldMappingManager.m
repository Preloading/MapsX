// This handles the conversion between the old shield ids, and the new ones given by the map. 
// Since we don't know all the new ones, and they might change, this is pulled from my server
// - Preloading, May 13th

#import <Foundation/Foundation.h>
#include <Foundation/NSString.h>
#import <CoreFoundation/CoreFoundation.h>
#import "GEOShieldMappingManager.h"
#import "Protobufs.h" // I use protobuf since it's small
#import "shieldmap-protobuf/GEOXShieldMap.h"

@implementation GEOShieldMappingManager

+ (instancetype)sharedManager {
    static GEOShieldMappingManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        NSLog(@"[MapsX] Initalized Shield Manager: %p", sharedManager);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [sharedManager loadShieldsFile];
            [sharedManager loadShieldsOnline];
        });
    });
    return sharedManager;
}

// loads the shield data from a cache file. this should probably be used for the geo resource stuff, but thats quite annoying.
-(NSError *)loadShieldsFile {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:@"/private/var/mobile/Library/Caches/GeoServices/Resources/shield_maps.dat" options:0 error:&error];
    if (error) return error;

    if (![self hasFetchedFromOnline]) {
        return [self loadMappingsFromData:data];
    }
    return nil;
}

-(void)loadShieldsOnline {
    NSLog(@"[MapsX] downloading latest shield info...");
    NSURL *url = [NSURL URLWithString:@"http://preloading.dev/tweaks/mapsx/shield_maps.dat"]; // no point in having this be HTTPS.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];

    self->_connection =
        [[NSURLConnection alloc] initWithRequest:request
                                        delegate:self
                                startImmediately:NO];
    [self->_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self->_connection start];
}

// online thingies
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[MapsX] got new shield data!");
    self->_hasFetchedFromOnline = YES;
    [self loadMappingsFromData:data];
    [data writeToFile:@"/private/var/mobile/Library/Caches/GeoServices/Resources/shield_maps.dat" atomically:YES];
}

-(NSError*)loadMappingsFromData:(NSData*)data {
    PBDataReader *reader = [[NSClassFromString(@"PBDataReader") alloc] initWithData:data];
    PackMessage *pack = [[PackMessage alloc] init];
    BOOL success = [pack readFrom:reader];
    
    if (success && ![reader hasError]) {
        NSMutableDictionary *shieldMaps = [[NSMutableDictionary alloc] initWithCapacity:pack.shields.count];
        for (MapMessage *message in pack.shields) {
            shieldMaps[@(message.currentId)] = @(message.oldId);
        }
        self->_shieldMappings = [shieldMaps copy];
        self->_dataVersion = pack.version;
    } else {
        NSLog(@"[MapsX] Failed to parse shield maps!!!");
    }

    return nil;
}

-(int)translateMap:(int)map {
    return [self->_shieldMappings[@(map)] integerValue];
}

@end