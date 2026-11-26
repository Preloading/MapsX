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
- (MNLocation *)lastTrackedLocation;
- (id)uiDelegate;
@end

@interface MNNavViewController : NSObject
- (MNGuidanceSignsDisplay *)guidanceDisplay;
- (MNNavigator *)navigator;
- (id)mapView;
@end

@interface NSObject (MapsX)
- (void)resetUserLocation;
- (id)worldView;
- (int)userTrackingMode;
- (void)setUserTrackingMode:(int)mode;
- (void)forceSceneLoad;
- (void)_resetTracking:(BOOL)stopLocationUpdate;
@end

@interface SteppingMode : NSObject
- (id)delegate;
@end

static id worldView = nil; // cached worldView from the last MNNavViewController transition
static CLLocationCoordinate2D lastResetCoord; // last spot where a tile refresh was forced, so we can track distance rather than re-drawing on every new gps update
static BOOL hasLastResetCoord = NO;

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

- (void)becomeCurrentContainerWithViews:(id)arg1 animated:(BOOL)arg2 { // this is called when navigation is started and when the Resume button is tapped in route overview. hooking this to basically simulate a resume press.
    %orig;
    id wv = [arg1 worldView];
    worldView = wv;
    int mode = [wv userTrackingMode];
    [wv setUserTrackingMode:0];
    [wv resetUserLocation];
    [wv setUserTrackingMode:mode];
    MNLocation *loc = [[self navigator] lastTrackedLocation];
    if (loc) {
        lastResetCoord = loc.coordinate;
        hasLastResetCoord = YES;
    } else hasLastResetCoord = NO;
}

%end

%hook MNNavigator

- (void)locationManagerUpdatedLocation:(id)arg1 { // called on every gps update during navigation, useful
    %orig;
    MNLocation *loc = [self lastTrackedLocation];
    if (!loc) return;
    if (hasLastResetCoord) {
        CLLocation *last = [[CLLocation alloc] initWithLatitude:lastResetCoord.latitude longitude:lastResetCoord.longitude];
        if ([loc distanceFromLocation:last] < 300) return; // only do it on every approximately 300m, so it doesn't stutter and lag the ui constantly
    }
    lastResetCoord = loc.coordinate;
    hasLastResetCoord = YES;
    NSLog(@"[MapsX] MNNavigator locationManagerUpdatedLocation, forcing refresh");
    id navVC = [self uiDelegate];
    id mapView = [navVC mapView];
    [mapView forceSceneLoad]; // vkmapview's tile reload function, this is called to remake the tiles when there's a blank grid
}

%end

%hook SteppingMode

- (void)becomeCurrentContainerWithViews:(id)arg1 animated:(BOOL)arg2 { // originally removed cause i thought it was dead code. but i realized both this and the MNNavigator stuff is needed for it to work.
    %orig;
    id mapVC = [self delegate];
    id wv = [mapVC worldView];
    int mode = [wv userTrackingMode];
    [mapVC _resetTracking:NO];
    [wv setUserTrackingMode:mode];
}

%end
%end

%ctor {
    if (kCFCoreFoundationVersionNumber < 847.20) { // apply only to ios 6 cause it's half-assed on ios 7
        %init(DrivingViewPatches);
    }
    // %init(DrivingViewPatches);
}