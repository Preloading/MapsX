#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "Protobufs.h"

@interface GEOMapRegion : PBCodable
{
    double _eastLng;
    double _northLat;
    double _southLat;
    double _westLng;
    NSMutableArray *_vertexs;
    struct {
        unsigned int eastLng:1;
        unsigned int northLat:1;
        unsigned int southLat:1;
        unsigned int westLng:1;
    } _has;
}

@property(retain, nonatomic) NSMutableArray *vertexs; // @synthesize vertexs=_vertexs;
@property(nonatomic) double eastLng; // @synthesize eastLng=_eastLng;
@property(nonatomic) double northLat; // @synthesize northLat=_northLat;
@property(nonatomic) double westLng; // @synthesize westLng=_westLng;
@property(nonatomic) double southLat; // @synthesize southLat=_southLat;
- (unsigned int)hash;
- (BOOL)isEqual:(id)arg1;
- (void)copyTo:(id)arg1;
- (void)writeTo:(id)arg1;
- (BOOL)readFrom:(id)arg1;
- (id)dictionaryRepresentation;
- (id)description;
- (id)vertexAtIndex:(unsigned int)arg1;
- (unsigned int)vertexsCount;
- (void)addVertex:(id)arg1;
- (void)clearVertexs;
@property(nonatomic) BOOL hasEastLng;
@property(nonatomic) BOOL hasNorthLat;
@property(nonatomic) BOOL hasWestLng;
@property(nonatomic) BOOL hasSouthLat;
- (void)dealloc;
@property(readonly, nonatomic) double spanLng;
@property(readonly, nonatomic) double spanLat;
@property(readonly, nonatomic) double centerLng;
@property(readonly, nonatomic) double centerLat;
- (id)initWithLatitude:(double)arg1 longitude:(double)arg2;
@end

@interface GEOLatLng : PBCodable
{
    double _lat;
    double _lng;
}
@end


@interface GEOLocation : PBCodable
{
    double _course;
    double _heading;
    double _horizontalAccuracy;
    double _speed;
    double _timestamp;
    double _verticalAccuracy;
    int _altitude;
    GEOLatLng *_latLng;
    int _type;
    struct {
        unsigned int course:1;
        unsigned int heading:1;
        unsigned int horizontalAccuracy:1;
        unsigned int speed:1;
        unsigned int timestamp:1;
        unsigned int verticalAccuracy:1;
        unsigned int altitude:1;
        unsigned int type:1;
    } _has;
}
@end

@interface GEOStructuredAddress : PBCodable
{
    // CDStruct_815f15fd _geoIds;
    NSString *_administrativeArea;
    NSString *_administrativeAreaCode;
    NSMutableArray *_areaOfInterests;
    NSString *_country;
    NSString *_countryCode;
    NSMutableArray *_dependentLocalitys;
    NSString *_fullThoroughfare;
    NSString *_inlandWater;
    NSString *_locality;
    NSString *_ocean;
    NSString *_postCode;
    NSString *_postCodeExtension;
    NSString *_premise;
    NSString *_premises;
    NSString *_subAdministrativeArea;
    NSString *_subLocality;
    NSMutableArray *_subPremises;
    NSString *_subThoroughfare;
    NSString *_thoroughfare;
}


@property(retain, nonatomic) NSMutableArray *subPremises; // @synthesize subPremises=_subPremises;
@property(retain, nonatomic) NSString *premise; // @synthesize premise=_premise;
@property(retain, nonatomic) NSMutableArray *dependentLocalitys; // @synthesize dependentLocalitys=_dependentLocalitys;
@property(retain, nonatomic) NSString *ocean; // @synthesize ocean=_ocean;
@property(retain, nonatomic) NSString *inlandWater; // @synthesize inlandWater=_inlandWater;
@property(retain, nonatomic) NSMutableArray *areaOfInterests; // @synthesize areaOfInterests=_areaOfInterests;
@property(retain, nonatomic) NSString *postCodeExtension; // @synthesize postCodeExtension=_postCodeExtension;
@property(retain, nonatomic) NSString *fullThoroughfare; // @synthesize fullThoroughfare=_fullThoroughfare;
@property(retain, nonatomic) NSString *subThoroughfare; // @synthesize subThoroughfare=_subThoroughfare;
@property(retain, nonatomic) NSString *thoroughfare; // @synthesize thoroughfare=_thoroughfare;
@property(retain, nonatomic) NSString *premises; // @synthesize premises=_premises;
@property(retain, nonatomic) NSString *subLocality; // @synthesize subLocality=_subLocality;
@property(retain, nonatomic) NSString *postCode; // @synthesize postCode=_postCode;
@property(retain, nonatomic) NSString *locality; // @synthesize locality=_locality;
@property(retain, nonatomic) NSString *subAdministrativeArea; // @synthesize subAdministrativeArea=_subAdministrativeArea;
@property(retain, nonatomic) NSString *administrativeAreaCode; // @synthesize administrativeAreaCode=_administrativeAreaCode;
@property(retain, nonatomic) NSString *administrativeArea; // @synthesize administrativeArea=_administrativeArea;
@property(retain, nonatomic) NSString *countryCode; // @synthesize countryCode=_countryCode;
@property(retain, nonatomic) NSString *country; // @synthesize country=_country;

@end

@interface GEOAddress : PBCodable
{
    NSMutableArray *_formattedAddressLines;
    int _formattedAddressType;
    GEOStructuredAddress *_structuredAddress;
    struct {
        unsigned int formattedAddressType:1;
    } _has;
}
@end

// ouch
@interface GEOPlaceSearchRequest : PBRequest
{
    // CDStruct_612aec5b _sessionGUID;
    struct {
        unsigned long long *list;
        unsigned int count;
        unsigned int size;
    } _businessIDs;
    // CDStruct_56d48c16 _includeAdditionalPlaceTypes;
    // CDStruct_815f15fd _placeIDs;
    long long _geoId;
    unsigned long long _intersectingGeoId;
    double _timestamp;
    GEOAddress *_address;
    // GEOBusinessOptions *_businessOptions;
    int _businessSortOrder;
    NSString *_deviceCountryCode;
    GEOLatLng *_deviceLocation;
    NSMutableArray *_filterByBusinessCategorys;
    // GEOIndexQueryNode *_indexFilter;
    NSString *_inputLanguage;
    int _localSearchProviderID;
    GEOLocation *_location; // This is  your location.... for some reason.
    // GEOMapRegion *_mapRegion;
    int _maxBusinessReviews;
    int _maxResults;
    NSString *_phoneticLocaleIdentifier;
    GEOAddress *_preserveFields;
    int _resultOffset;
    NSString *_search;
    NSString *_searchContext;
    // GEOSearchSubstring *_searchContextSubstring;
    NSMutableArray *_searchSubstrings;
    int _sequenceNumber;
    NSMutableArray *_serviceTags;
    int _sessionID;
    NSString *_suggestionsPrefix;
    NSData *_zilchPoints;
    BOOL _allowABTestResponse;
    BOOL _excludeAddressInResults;
    BOOL _includeBusinessCategories;
    BOOL _includeBusinessRating;
    BOOL _includeEntryPoints;
    BOOL _includeFeatureSets;
    BOOL _includeGeoId;
    BOOL _includePhonetics;
    BOOL _includeQuads;
    BOOL _includeStatusCodeInfo;
    BOOL _includeSuggestionsOnly;
    BOOL _includeUnmatchedStrings;
    BOOL _isStrictMapRegion;
    BOOL _structuredSearch;
    struct {
        unsigned int sessionGUID:1;
        unsigned int geoId:1;
        unsigned int intersectingGeoId:1;
        unsigned int timestamp:1;
        unsigned int businessSortOrder:1;
        unsigned int localSearchProviderID:1;
        unsigned int maxBusinessReviews:1;
        unsigned int maxResults:1;
        unsigned int resultOffset:1;
        unsigned int sequenceNumber:1;
        unsigned int sessionID:1;
        unsigned int allowABTestResponse:1;
        unsigned int excludeAddressInResults:1;
        unsigned int includeBusinessCategories:1;
        unsigned int includeBusinessRating:1;
        unsigned int includeEntryPoints:1;
        unsigned int includeFeatureSets:1;
        unsigned int includeGeoId:1;
        unsigned int includePhonetics:1;
        unsigned int includeQuads:1;
        unsigned int includeStatusCodeInfo:1;
        unsigned int includeSuggestionsOnly:1;
        unsigned int includeUnmatchedStrings:1;
        unsigned int isStrictMapRegion:1;
        unsigned int structuredSearch:1;
    } _has;
}
@end

@interface GEOWaypoint : PBCodable
{
    NSMutableArray *_entryPoints;
    GEOLocation *_location;
    GEOPlaceSearchRequest *_placeSearchRequest;
}
@end


@interface GEODirectionsRequest : PBRequest
{
    GEOMapRegion *_currentMapRegion;
    GEOLocation *_currentUserLocation;
    int _departureTime;
    unsigned int _maxRouteCount;
    NSData *_originalRouteID;
    NSData *_originalRouteZilchPoints;
    PBCodable *_routeAttributes;
    NSMutableArray *_serviceTags;
    unsigned int _timeSinceLastRerouteRequest;
    NSMutableArray *_waypoints;
    struct {
        unsigned int departureTime:1;
        unsigned int maxRouteCount:1;
        unsigned int timeSinceLastRerouteRequest:1;
    } _has;
}
@end