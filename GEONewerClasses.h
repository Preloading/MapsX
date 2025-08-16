#import "GeoHeaders.h"

// iOS 11, the ones with COMPONENT_ are in mapsResult, place, component
@interface GEOWaypointID : PBCodable <NSCopying> {
    int  _addressGeocodeAccuracyHint; // dont think exists in mapkit
    GEOStructuredAddress * _addressHint;
    NSMutableArray * _formattedAddressLineHints;
    struct { 
        unsigned int muid : 1; 
        unsigned int resultProviderId : 1; 
        unsigned int addressGeocodeAccuracyHint : 1; 
        unsigned int placeTypeHint : 1; 
    }  _has;
    GEOLatLng * _locationHint;
    unsigned long long  _muid;
    NSString * _placeNameHint;
    int  _placeTypeHint;
    unsigned long long  _resultProviderId;
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