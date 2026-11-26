#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MNGuidanceSignsDisplay : NSObject
- (void)setCurrentRoadDescription:(NSString *)description;
- (void)setCurrentRoadDescriptionIsUnreliable:(BOOL)unreliable;
@end

@interface GEONameInfo : NSObject
- (NSString *)name;
@end

@interface GEONameInfoList : NSObject
- (NSArray *)nameInfos;
@end

@interface GEOStep : NSObject
- (NSArray *)signposts;
- (NSArray *)maneuverNames;
@end

@interface GEORoute : NSObject
- (NSArray *)steps;
@end

@interface VKAttributedRoute : NSObject
- (GEORoute *)geoRoute;
@end

@interface VKAttributedRouteMatch : NSObject
- (unsigned int)stepIndex;
- (VKAttributedRoute *)route;
@end

@interface MNLocation : CLLocation
- (VKAttributedRouteMatch *)routeMatch;
- (BOOL)locationUnreliable;
- (NSString *)roadName;
@end

@interface MNNavigator : NSObject
- (MNLocation *)lastMatchedLocation;
@end

@interface MNNavViewController : NSObject
- (MNGuidanceSignsDisplay *)guidanceDisplay;
- (MNNavigator *)navigator;
@end

@interface NSObject (MapsX)
- (id)createSourceForLayer:(unsigned int)layer tileSet:(id)tileSet mode:(int)mode;
@end

@interface VKTileProvider : NSObject
- (void)setTileSource:(id)source forMapLayer:(unsigned int)layer optional:(BOOL)optional;
@end

static id mapModel = nil;
static id polygonTileSet = nil;
static id roadTileSet = nil;
static id navProvider = nil;
static id navSource = nil;

// the tile data doesn't usually carry a road name, so get it from the current route step instead
static NSString *roadNameFromRouteStep(MNNavigator *navigator) {
    VKAttributedRouteMatch *match = [[navigator lastMatchedLocation] routeMatch];
    if (!match) return nil;
    unsigned int stepIndex = [match stepIndex];
    if (stepIndex == 0) return nil;
    GEORoute *geoRoute = [[match route] geoRoute];
    NSArray *steps = [geoRoute steps];
    if (!steps || stepIndex-1 >= steps.count) return nil;
    GEOStep *step = steps[stepIndex-1];
    GEONameInfo *signpost = [step signposts].firstObject;
    if (signpost.name.length) return signpost.name;
    GEONameInfoList *nameList = [step maneuverNames].firstObject;
    GEONameInfo *nameInfo = nameList.nameInfos.firstObject;
    if (nameInfo.name.length) return nameInfo.name;
    return nil;
}

%group DrivingViewPatches
%hook VKMapModel

- (int)tileStyleForMapLayer:(unsigned int)layer {
    int s = %orig;
    if (s == 18) return 20; // style 18 is no longer available on the server. this is for the road name balloons. style 20 works fine for this.
    return s;
}

- (void)configureTileSources { // disabling the realistic tiles, so it just displays the regular tiles. this stops it from transitioning to the dead tiles, rather than actually patching it.
    Ivar iv = class_getInstanceVariable(object_getClass(self), "_activeMapLayers");
    if (iv) {
        char *layers = (char *)(__bridge void *)self + ivar_getOffset(iv);
        for (int row = 0; row < 3; row++) {
            char *r = layers + row * 26;
            if (r[10]) {
                r[2] = 1;
                r[6] = 1;
                r[8] = 1;
                r[9] = 1;
            }
        }
    }
    %orig;
}

- (id)createSourceForLayer:(unsigned int)layer tileSet:(id)tileSet mode:(int)mode {
    mapModel = self;
    if (mode == 0 && tileSet) {
        if (layer == 512) polygonTileSet = tileSet;
        if (layer == 1024) roadTileSet = tileSet;
    }
    return %orig;
}

%end

%hook VKTileProvider

- (void)setTileSource:(id)source forMapLayer:(unsigned int)layer optional:(BOOL)optional {
    %orig;
    if (layer == 2048 && !source && self == navProvider) navSource = nil;
    if (layer != 2048 || !source || !mapModel) return;
    navProvider = self;
    navSource = source;
    id polygonSource = polygonTileSet ? [mapModel createSourceForLayer:512 tileSet:polygonTileSet mode:0] : nil;
    id roadSource = roadTileSet ? [mapModel createSourceForLayer:1024 tileSet:roadTileSet mode:0] : nil;
    if (polygonSource) [self setTileSource:polygonSource forMapLayer:512 optional:NO];
    if (roadSource) [self setTileSource:roadSource forMapLayer:1024 optional:NO];
}

%end

%hook MNNavViewController

- (void)_updateGuidanceRoadDescription:(NSString *)description locationIsUnreliable:(BOOL)unreliable { // current street name fails to display because the alpha is 0, making the banner invisible. did some tracing and found that this function dictates that.
    %orig;
    // fall back to the route step name since the tiles don't usually have one
    NSString *roadName = description;
    if (!roadName.length && !unreliable) {
        roadName = roadNameFromRouteStep([self navigator]);
    }
    MNGuidanceSignsDisplay *display = [self guidanceDisplay];
    [display setCurrentRoadDescription:roadName ?: @""];
    [display setCurrentRoadDescriptionIsUnreliable:unreliable];
}

%end
%end

%ctor {
    if (kCFCoreFoundationVersionNumber < 847.20) { // apply only to ios 6 cause it's half-assed on ios 7
        %init(DrivingViewPatches);
    }
    // %init(DrivingViewPatches);
}