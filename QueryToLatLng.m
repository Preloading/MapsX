#import <Foundation/Foundation.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSError.h>
#include <Foundation/NSData.h>
#include <Foundation/NSDictionary.h>
#include <Foundation/NSString.h>
#import <CoreFoundation/CoreFoundation.h>
#import "QueryToLatLng.h"
#import "GeoHeaders.h"
#include <sys/sysctl.h>

// sillys for the apple engineers and my pride.
NSString *GetProductCode(void) {
    size_t size = 0;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *buffer = malloc(size);
    if (!buffer) return nil;
    sysctlbyname("hw.machine", buffer, &size, NULL, 0);
    NSString *result = [NSString stringWithUTF8String:buffer];
    free(buffer);
    return result;
}

NSString *GetOSVersion(void) {
    size_t size = 0;
    sysctlbyname("kern.osrelease", NULL, &size, NULL, 0);
    char *buffer = malloc(size);
    if (!buffer) return nil;
    sysctlbyname("kern.osrelease", buffer, &size, NULL, 0);
    NSString *result = [NSString stringWithUTF8String:buffer];
    free(buffer);
    return result;
}

@interface QueryToLatLng ()
@end

@implementation QueryToLatLng

+(NSError*)getQueryToLatLng:(NSString*)query region:(GEOMapRegion*)currentMapRegion out:(GEOWaypointID*)output{
    NSString *queryURL = @"https://maps.apple.com/data/search-autocomplete";

    /// create the request body
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
        query, @"q", 
        @"", @"dcc", // this was US in the actual real request, but im just too lazy to get that info.
    nil];

    // where we are looking at on the map, i think
    [requestBody setObject:@{
        @"lat":[NSNumber numberWithDouble:[currentMapRegion centerLat]],
        @"lng":[NSNumber numberWithDouble:[currentMapRegion centerLng]]
    } forKey:@"latlong"];

    [requestBody setObject:@{
        @"latitudeDelta":[NSNumber numberWithDouble:[currentMapRegion spanLat]],
        @"longitudeDelta":[NSNumber numberWithDouble:[currentMapRegion spanLng]]
    } forKey:@"span"];

    // "analytics"
    [requestBody setObject:@{
        @"serviceTag": @{
            @"tag":@"" // required
        },
        @"sessionId": @{
            @"high":@0, // required
            @"low":@0 // required
        },
        @"relativeTimestamp":@0, // required
        @"sequenceNumber":@0, // required
        @"hewo":@"owo", // this stays, -Preloading

        // the rest is optional, just fun for the apple engineers, and my pride :D
        // @"appIdentifier":[[NSBundle mainBundle] bundleIdentifier], // gives 400 bad request when uncommented
        // @"appMinorVersion": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], // im too lazy to seperate into minor & major
        @"hardwareModel": GetProductCode(),
        @"osVersion": GetOSVersion()

    } forKey:@"analyticMetadata"];
    
    // make it json
    NSData *requestBodyJson = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:nil];

    // make request
    NSURL *url = [NSURL URLWithString:queryURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url 
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                 timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBodyJson];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request // praying to god this isnt in a blocking thread
                                         returningResponse:&response 
                                                     error:&error];
    
    if (error) {
        NSLog(@"[MapsX] Request failed to get more info on directions query: %@", [error localizedDescription]);
        return error;
    }
    
    error = nil;
    id object = [NSJSONSerialization
                      JSONObjectWithData:responseData
                      options:0
                      error:&error];

    if(error) { 
        NSLog(@"[MapsX] Failed to decode location query JSON: %@", [error localizedDescription]);
        return error; 
    }

    if([object isKindOfClass:[NSDictionary class]])
    {  
        NSDictionary *data = object;

        if ([data[@"mapsResult"] isKindOfClass:[NSArray class]] && ([data[@"mapsResult"] count] > 0) && [data[@"mapsResult"][0] isKindOfClass:[NSDictionary class]]) { // I hope i understand how the param checking works, and that it checks it in a row.
            NSDictionary *mapsResult = data[@"mapsResult"][0]; // we only care about the first value.
            if ([mapsResult[@"place"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *mapPlace = mapsResult[@"place"];
                // at this point i pray that the data is intact and what i expect
                
                output.muid = [mapPlace[@"muid"] longLongValue];
                output.resultProviderId = [mapPlace[@"resultProviderId"] longValue];

                NSArray *components = mapPlace[@"component"];
                for (int i = 0; components.count > i; i++) { // for loops scare me
                    NSDictionary *component = components[i];
                    NSString *componentType = component[@"type"];
                    NSArray *componentValues = component[@"value"];

                    if (!([componentValues count] > 0)) {
                        continue;
                    }

                    // location hint, latlong
                    if ([componentType isEqualToString:@"COMPONENT_TYPE_PLACE_INFO"]) {
                        if ([componentValues[0][@"placeInfo"] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *placeInfo = componentValues[0][@"placeInfo"];
                            if ([placeInfo[@"center"] isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *locationCenter = placeInfo[@"center"];
                                GEOLatLng *locationHint = [GEOLatLng alloc];
                                [locationHint setValue:locationCenter[@"lat"] forKey:@"_lat"];
                                [locationHint setValue:locationCenter[@"lng"] forKey:@"_lng"];
                                output.locationHint = locationHint;
                            }
                        }
                        
                    } else if ([componentType isEqualToString:@"COMPONENT_TYPE_ADDRESS_OBJECT"]) {
                        if ([componentValues[0][@"addressObject"] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *addressObject = componentValues[0][@"addressObject"];

                            // formatted lines
                            if ([addressObject[@"formattedAddressLines"] isKindOfClass:[NSArray class]]) {
                                output.formattedAddressLineHints = addressObject[@"formattedAddressLines"];
                            }

                            // structured address
                            if ([addressObject[@"address"] isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *addressData = addressObject[@"address"];
                                if ([addressData[@"structuredAddress"] isKindOfClass:[NSDictionary class]]) {
                                    NSDictionary *structedAddressDict = addressData[@"structuredAddress"];
                                    output.addressHint = [GEOStructuredAddress alloc];
                                    output.addressHint.country = structedAddressDict[@"country"];
                                    output.addressHint.countryCode = structedAddressDict[@"countryCode"];
                                    output.addressHint.administrativeArea = structedAddressDict[@"administrativeArea"];
                                    output.addressHint.administrativeAreaCode = structedAddressDict[@"administrativeAreaCode"];
                                    output.addressHint.subAdministrativeArea = structedAddressDict[@"subAdministrativeArea"];
                                    output.addressHint.locality = structedAddressDict[@"locality"];
                                    output.addressHint.postCode = structedAddressDict[@"postCode"];
                                    output.addressHint.thoroughfare = structedAddressDict[@"thoroughfare"];
                                    output.addressHint.subThoroughfare = structedAddressDict[@"subThoroughfare"];
                                    output.addressHint.fullThoroughfare = structedAddressDict[@"fullThoroughfare"];
                                    // output.addressHint.areaOfInterests = structedAddressDict[@"areaOfInterest"];
                                    // output.addressHint.dependentLocalitys = structedAddressDict[@"dependentLocality"];
                                    // output.addressHint.subPremises = structedAddressDict[@"subPremise"];
                                    // geoid seems like more effort than its worth.
                                }
                            }
                        }
                    
                    } else if ([componentType isEqualToString:@"COMPONENT_TYPE_ENTITY"]) {
                        if ([componentValues[0][@"entity"] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *entity = componentValues[0][@"entity"];

                            // place name
                            if ([entity[@"name"] isKindOfClass:[NSArray class]]) {
                                NSArray *names = entity[@"name"];
                                if ([names count] != 0) {
                                    output.placeNameHint = names[0][@"stringValue"];
                                }
                            }
                        }
                    
                    }
                }
                return nil;
            } else {
                return [NSError errorWithDomain:@"maps place no exist :(" code:1 userInfo:nil];
            }
        } else {
            return [NSError errorWithDomain:@"maps result either does not exist, or is blank" code:1 userInfo:nil];
        }
    }
    else
    {
        return [NSError errorWithDomain:@"decoded json was not a dictionary" code:1 userInfo:nil];
    }
}
@end