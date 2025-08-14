#import "GEONewerClasses.h"
#import "Protobufs.h"

@implementation GEOWaypointID
@synthesize addressGeocodeAccuracyHint = _addressGeocodeAccuracyHint;
@synthesize addressHint = _addressHint;
@synthesize formattedAddressLineHints = _formattedAddressLineHints;
@synthesize locationHint = _locationHint;
@synthesize muid = _muid;
@synthesize placeNameHint = _placeNameHint;
@synthesize placeTypeHint = _placeTypeHint;
@synthesize resultProviderId = _resultProviderId;

- (id)init {
    if (self = [super init]) {
        _formattedAddressLineHints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    // [_addressHint release];
    // [_formattedAddressLineHints release];
    // [_locationHint release];
    // [_placeNameHint release];
    // [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    GEOWaypointID *copy = [[[self class] allocWithZone:zone] init];
    copy.addressGeocodeAccuracyHint = self.addressGeocodeAccuracyHint;
    // copy.addressHint = [self.addressHint copyWithZone:zone];
    copy.formattedAddressLineHints = [[NSMutableArray alloc] initWithArray:self.formattedAddressLineHints copyItems:YES];
    // copy.locationHint = [self.locationHint copyWithZone:zone]; // i pretend not to see. Anyways, i'm not likely to use this.
    copy.muid = self.muid;
    copy.placeNameHint = [self.placeNameHint copyWithZone:zone];
    copy.placeTypeHint = self.placeTypeHint;
    copy.resultProviderId = self.resultProviderId;
    
    copy->_has = self->_has;
    
    return copy;
}

- (void)writeTo:(id)writer {
    if ([writer isKindOfClass:[PBDataWriter class]]) {      
        if (_muid) {
            [writer writeUint64:_muid forTag:1];
        }
        if (_resultProviderId) {
            [writer writeInt32:_resultProviderId forTag:2];
        }
        if (_locationHint != nil) {
            PBDataWriter *dataWriter = [[PBDataWriter alloc] init];
            [_locationHint writeTo:dataWriter];
            [writer writeData:[dataWriter data] forTag:3];
        }
        
        if (_addressHint != nil) {
            PBDataWriter *dataWriter = [[PBDataWriter alloc] init];
            [_addressHint writeTo:dataWriter];
            [writer writeData:[dataWriter data] forTag:4];
        }
        
        if (_placeNameHint != nil) {
            [writer writeString:_placeNameHint forTag:5];
        }

        if (_formattedAddressLineHints.count > 0) {
            for (NSString *addressLine in _formattedAddressLineHints) {
                [writer writeString:addressLine forTag:6];
            }
        }

        if (_placeTypeHint) {
            [writer writeInt32:_placeTypeHint forTag:7];
        }

        if (_addressGeocodeAccuracyHint) {
            [writer writeInt32:_addressGeocodeAccuracyHint forTag:8];
        }
    }
}

- (bool)hasAddressGeocodeAccuracyHint {
    return _has.addressGeocodeAccuracyHint;
}

- (void)setHasAddressGeocodeAccuracyHint:(bool)value {
    _has.addressGeocodeAccuracyHint = value;
}

- (bool)hasAddressHint {
    return _addressHint != nil;
}

- (bool)hasLocationHint {
    return _locationHint != nil;
}

- (bool)hasMuid {
    return _has.muid;
}

- (void)setHasMuid:(bool)value {
    _has.muid = value;
}

- (bool)hasPlaceNameHint {
    return _placeNameHint != nil;
}

- (bool)hasPlaceTypeHint {
    return _has.placeTypeHint;
}

- (void)setHasPlaceTypeHint:(bool)value {
    _has.placeTypeHint = value;
}

- (bool)hasResultProviderId {
    return _has.resultProviderId;
}

- (void)setHasResultProviderId:(bool)value {
    _has.resultProviderId = value;
}

@end