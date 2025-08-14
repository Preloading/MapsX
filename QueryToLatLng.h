#import <Foundation/Foundation.h>
#import "GeoHeaders.h"

// iOS 11, the ones with COMPONENT_ are in mapsResult, place, component
@interface GEOWaypointID : PBCodable <NSCopying> {
    int  _addressGeocodeAccuracyHint; // dont think exists in mapkit
    GEOStructuredAddress * _addressHint; // In mapkit: COMPONENT_TYPE_ADDRESS_OBJECT, addressObject, address, structuredAddress
    NSMutableArray * _formattedAddressLineHints; // In mapkit: COMPONENT_TYPE_ADDRESS_OBJECT, addressObject, formattedAddressLines
    struct { 
        unsigned int muid : 1; 
        unsigned int resultProviderId : 1; 
        unsigned int addressGeocodeAccuracyHint : 1; 
        unsigned int placeTypeHint : 1; 
    }  _has;
    GEOLatLng * _locationHint; // COMPONENT_TYPE_PLACE_INFO, placeInfo, center
    unsigned long long  _muid; // mapsResult, place, muid
    NSString * _placeNameHint; // COMPONENT_TYPE_ENTITY, entity, name, stringValue
    int  _placeTypeHint; // idk how to get the int for this
    unsigned long long  _resultProviderId; // mapsResult, place, resultProviderId
}
@property (nonatomic) int addressGeocodeAccuracyHint;
@property (nonatomic, retain) GEOStructuredAddress *addressHint;
@property (nonatomic, retain) NSMutableArray *formattedAddressLineHints;
@property (nonatomic) bool hasAddressGeocodeAccuracyHint;
@property (nonatomic, readonly) bool hasAddressHint;
@property (nonatomic, readonly) bool hasLocationHint;
@property (nonatomic) bool hasMuid;
@property (nonatomic, readonly) bool hasPlaceNameHint;
@property (nonatomic) bool hasPlaceTypeHint;
@property (nonatomic) bool hasResultProviderId;
@property (nonatomic, retain) GEOLatLng *locationHint;
@property (nonatomic) unsigned long long muid;
@property (nonatomic, retain) NSString *placeNameHint;
@property (nonatomic) int placeTypeHint;
@property (nonatomic) unsigned long long resultProviderId;
@end

@interface QueryToLatLng : NSObject

+(NSError*)getQueryToLatLng:(NSString*)query region:(GEOMapRegion*)currentMapRegion out:(GEOWaypointID*)output;

@end