#import <Foundation/Foundation.h>
#import "GeoHeaders.h"
#import "GEONewerClasses.h"

NSString *customURLEncode(NSString *string);
NSString *customURLDecode(NSString *string);
@interface QueryToLatLng : NSObject

+(NSError*)getQueryToLatLng:(NSString*)query region:(GEOMapRegion*)currentMapRegion out:(GEOWaypointID*)output;

@end