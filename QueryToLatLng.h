#import <Foundation/Foundation.h>
#import "GeoHeaders.h"
#import "GEONewerClasses.h"

@interface QueryToLatLng : NSObject

+(NSError*)getQueryToLatLng:(NSString*)query region:(GEOMapRegion*)currentMapRegion out:(GEOWaypointID*)output;

@end