#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "TokenManager.h"
#import <execinfo.h>
#import "Protobufs.h"
#import "GeoHeaders.h"
#import "QueryToLatLng.h"

void logGEOPlaceSearchRequestDetails(GEOPlaceSearchRequest *request) {
    if (!request) {
        NSLog(@"[MapsX] GEOPlaceSearchRequest is nil");
        return;
    }
    
    NSLog(@"[MapsX] ----- GEOPlaceSearchRequest Details -----");
    
    // Log primitive values
    NSLog(@"[MapsX] geoId: %lld", [request valueForKey:@"_geoId"] ? [[request valueForKey:@"_geoId"] longLongValue] : 0);
    NSLog(@"[MapsX] intersectingGeoId: %llu", [request valueForKey:@"_intersectingGeoId"] ? [[request valueForKey:@"_intersectingGeoId"] unsignedLongLongValue] : 0);
    NSLog(@"[MapsX] timestamp: %f", [request valueForKey:@"_timestamp"] ? [[request valueForKey:@"_timestamp"] doubleValue] : 0.0);
    NSLog(@"[MapsX] businessSortOrder: %d", [request valueForKey:@"_businessSortOrder"] ? [[request valueForKey:@"_businessSortOrder"] intValue] : 0);
    NSLog(@"[MapsX] localSearchProviderID: %d", [request valueForKey:@"_localSearchProviderID"] ? [[request valueForKey:@"_localSearchProviderID"] intValue] : 0);
    NSLog(@"[MapsX] maxBusinessReviews: %d", [request valueForKey:@"_maxBusinessReviews"] ? [[request valueForKey:@"_maxBusinessReviews"] intValue] : 0);
    NSLog(@"[MapsX] maxResults: %d", [request valueForKey:@"_maxResults"] ? [[request valueForKey:@"_maxResults"] intValue] : 0);
    NSLog(@"[MapsX] resultOffset: %d", [request valueForKey:@"_resultOffset"] ? [[request valueForKey:@"_resultOffset"] intValue] : 0);
    NSLog(@"[MapsX] sequenceNumber: %d", [request valueForKey:@"_sequenceNumber"] ? [[request valueForKey:@"_sequenceNumber"] intValue] : 0);
    NSLog(@"[MapsX] sessionID: %d", [request valueForKey:@"_sessionID"] ? [[request valueForKey:@"_sessionID"] intValue] : 0);
    
    // Log BOOL values
    NSLog(@"[MapsX] allowABTestResponse: %d", [request valueForKey:@"_allowABTestResponse"] ? [[request valueForKey:@"_allowABTestResponse"] boolValue] : NO);
    NSLog(@"[MapsX] excludeAddressInResults: %d", [request valueForKey:@"_excludeAddressInResults"] ? [[request valueForKey:@"_excludeAddressInResults"] boolValue] : NO);
    NSLog(@"[MapsX] includeBusinessCategories: %d", [request valueForKey:@"_includeBusinessCategories"] ? [[request valueForKey:@"_includeBusinessCategories"] boolValue] : NO);
    NSLog(@"[MapsX] includeBusinessRating: %d", [request valueForKey:@"_includeBusinessRating"] ? [[request valueForKey:@"_includeBusinessRating"] boolValue] : NO);
    NSLog(@"[MapsX] includeEntryPoints: %d", [request valueForKey:@"_includeEntryPoints"] ? [[request valueForKey:@"_includeEntryPoints"] boolValue] : NO);
    NSLog(@"[MapsX] includeFeatureSets: %d", [request valueForKey:@"_includeFeatureSets"] ? [[request valueForKey:@"_includeFeatureSets"] boolValue] : NO);
    NSLog(@"[MapsX] includeGeoId: %d", [request valueForKey:@"_includeGeoId"] ? [[request valueForKey:@"_includeGeoId"] boolValue] : NO);
    NSLog(@"[MapsX] includePhonetics: %d", [request valueForKey:@"_includePhonetics"] ? [[request valueForKey:@"_includePhonetics"] boolValue] : NO);
    NSLog(@"[MapsX] includeQuads: %d", [request valueForKey:@"_includeQuads"] ? [[request valueForKey:@"_includeQuads"] boolValue] : NO);
    NSLog(@"[MapsX] includeStatusCodeInfo: %d", [request valueForKey:@"_includeStatusCodeInfo"] ? [[request valueForKey:@"_includeStatusCodeInfo"] boolValue] : NO);
    NSLog(@"[MapsX] includeSuggestionsOnly: %d", [request valueForKey:@"_includeSuggestionsOnly"] ? [[request valueForKey:@"_includeSuggestionsOnly"] boolValue] : NO);
    NSLog(@"[MapsX] includeUnmatchedStrings: %d", [request valueForKey:@"_includeUnmatchedStrings"] ? [[request valueForKey:@"_includeUnmatchedStrings"] boolValue] : NO);
    NSLog(@"[MapsX] isStrictMapRegion: %d", [request valueForKey:@"_isStrictMapRegion"] ? [[request valueForKey:@"_isStrictMapRegion"] boolValue] : NO);
    NSLog(@"[MapsX] structuredSearch: %d", [request valueForKey:@"_structuredSearch"] ? [[request valueForKey:@"_structuredSearch"] boolValue] : NO);
    
    // Log string values
    NSLog(@"[MapsX] deviceCountryCode: %@", [request valueForKey:@"_deviceCountryCode"]);
    NSLog(@"[MapsX] inputLanguage: %@", [request valueForKey:@"_inputLanguage"]);
    NSLog(@"[MapsX] phoneticLocaleIdentifier: %@", [request valueForKey:@"_phoneticLocaleIdentifier"]);
    NSLog(@"[MapsX] search: %@", [request valueForKey:@"_search"]);
    NSLog(@"[MapsX] searchContext: %@", [request valueForKey:@"_searchContext"]);
    NSLog(@"[MapsX] suggestionsPrefix: %@", [request valueForKey:@"_suggestionsPrefix"]);
    
    // Log complex objects
    GEOAddress *address = [request valueForKey:@"_address"];
    if (address) {
        NSLog(@"[MapsX] address: %@", [address description]);
        
        NSArray *formattedAddressLines = [address valueForKey:@"_formattedAddressLines"];
        if (formattedAddressLines && [formattedAddressLines count] > 0) {
            NSLog(@"[MapsX] address formattedAddressLines: %@", formattedAddressLines);
        }
        
        GEOStructuredAddress *structuredAddress = [address valueForKey:@"_structuredAddress"];
        if (structuredAddress) {
            NSLog(@"[MapsX] structuredAddress: %@", structuredAddress);
            NSLog(@"[MapsX] country: %@", [structuredAddress valueForKey:@"_country"]);
            NSLog(@"[MapsX] countryCode: %@", [structuredAddress valueForKey:@"_countryCode"]);
            NSLog(@"[MapsX] administrativeArea: %@", [structuredAddress valueForKey:@"_administrativeArea"]);
            NSLog(@"[MapsX] locality: %@", [structuredAddress valueForKey:@"_locality"]);
            NSLog(@"[MapsX] thoroughfare: %@", [structuredAddress valueForKey:@"_thoroughfare"]);
            NSLog(@"[MapsX] subThoroughfare: %@", [structuredAddress valueForKey:@"_subThoroughfare"]);
            NSLog(@"[MapsX] postCode: %@", [structuredAddress valueForKey:@"_postCode"]);
        }
    }
    
    GEOLatLng *deviceLocation = [request valueForKey:@"_deviceLocation"];
    if (deviceLocation) {
        NSNumber *lat = [deviceLocation valueForKey:@"_lat"];
        NSNumber *lng = [deviceLocation valueForKey:@"_lng"];
        NSLog(@"[MapsX] deviceLocation: lat=%@, lng=%@", lat, lng);
    }
    
    GEOLocation *location = [request valueForKey:@"_location"];
    if (location) {
        NSLog(@"[MapsX] location: %@", [location description]);
        
        GEOLatLng *locLatLng = [location valueForKey:@"_latLng"];
        if (locLatLng) {
            NSNumber *lat = [locLatLng valueForKey:@"_lat"];
            NSNumber *lng = [locLatLng valueForKey:@"_lng"];
            NSLog(@"[MapsX] location latLng: lat=%@, lng=%@", lat, lng);
        }
        
        NSLog(@"[MapsX] location timestamp: %f", [[location valueForKey:@"_timestamp"] doubleValue]);
        NSLog(@"[MapsX] location horizontalAccuracy: %f", [[location valueForKey:@"_horizontalAccuracy"] doubleValue]);
        NSLog(@"[MapsX] location verticalAccuracy: %f", [[location valueForKey:@"_verticalAccuracy"] doubleValue]);
        NSLog(@"[MapsX] location altitude: %d", [[location valueForKey:@"_altitude"] intValue]);
        NSLog(@"[MapsX] location course: %f", [[location valueForKey:@"_course"] doubleValue]);
        NSLog(@"[MapsX] location heading: %f", [[location valueForKey:@"_heading"] doubleValue]);
        NSLog(@"[MapsX] location speed: %f", [[location valueForKey:@"_speed"] doubleValue]);
    }
    
    // Log arrays
    NSArray *filterByBusinessCategorys = [request valueForKey:@"_filterByBusinessCategorys"];
    if (filterByBusinessCategorys) {
        NSLog(@"[MapsX] filterByBusinessCategorys: %@", filterByBusinessCategorys);
    }
    
    NSArray *searchSubstrings = [request valueForKey:@"_searchSubstrings"];
    if (searchSubstrings) {
        NSLog(@"[MapsX] searchSubstrings: %@", searchSubstrings);
    }
    
    NSArray *serviceTags = [request valueForKey:@"_serviceTags"];
    if (serviceTags) {
        NSLog(@"[MapsX] serviceTags: %@", serviceTags);
    }
    
    // Log data objects
    NSData *zilchPoints = [request valueForKey:@"_zilchPoints"];
    if (zilchPoints) {
        NSLog(@"[MapsX] zilchPoints length: %lu", (unsigned long)[zilchPoints length]);
    }
    
    // Try to log struct flags
    NSValue *hasValue = [request valueForKey:@"_has"];
    if (hasValue) {
        unsigned int hasFlags = 0;
        if ([hasValue isKindOfClass:[NSNumber class]]) {
            hasFlags = [(NSNumber *)hasValue unsignedIntValue];
        } else {
            [hasValue getValue:&hasFlags];
        }
        NSLog(@"[MapsX] has flags: %u", hasFlags);
    }
    
    NSLog(@"[MapsX] ----- End GEOPlaceSearchRequest Details -----");
}

// Hell. You may be wondering why is this nessiary?
// well stringByAddingPercentEscapesUsingEncoding doesn't encode = for the query params :)
NSString *customURLEncode(NSString *string) {
    if (!string) return nil;
    
    // Characters that don't need encoding in URLs
    NSString *reservedChars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~";
    
    NSMutableString *result = [NSMutableString string];
    NSUInteger length = [string length];
    
    for (NSUInteger i = 0; i < length; i++) {
        unichar c = [string characterAtIndex:i];
        if ([reservedChars rangeOfString:[NSString stringWithFormat:@"%C", c]].location != NSNotFound) {
            // Character doesn't need encoding
            [result appendFormat:@"%C", c];
        } else {
            // Character needs encoding
            [result appendFormat:@"%%%02X", c];
        }
    }
    
    return result;
}

// Custom URL decoding function
NSString *customURLDecode(NSString *string) {
    if (!string) return nil;
    
    NSMutableString *result = [NSMutableString string];
    NSUInteger length = [string length];
    NSUInteger i = 0;
    
    while (i < length) {
        unichar c = [string characterAtIndex:i];
        if (c == '%' && i + 2 < length) {
            // Try to parse the hex value
            NSString *hexStr = [string substringWithRange:NSMakeRange(i + 1, 2)];
            NSScanner *scanner = [NSScanner scannerWithString:hexStr];
            unsigned int hexValue;
            
            if ([scanner scanHexInt:&hexValue]) {
                [result appendFormat:@"%C", (unichar)hexValue];
                i += 3; // Skip the '%' and the two hex digits
            } else {
                // If it's not a valid hex sequence, just add the '%'
                [result appendString:@"%"];
                i++;
            }
        } else if (c == '+') {
            // '+' is decoded as space
            [result appendString:@" "];
            i++;
        } else {
            // Not encoded, add as is
            [result appendFormat:@"%C", c];
            i++;
        }
    }
    
    return result;
}


NSURL *addAccessKeyToURL(NSURL *originalURL) {
    if (!originalURL) return originalURL;
    
    NSString *urlString = [originalURL absoluteString];
    NSString *token = [[TokenManager sharedManager] currentToken];
    
    // Parse URL parts
    NSString *baseURLString;
    NSString *queryString;
    
    // Split URL into base and query components
    NSRange queryRange = [urlString rangeOfString:@"?"];
    if (queryRange.location == NSNotFound) {
        baseURLString = urlString;
        queryString = @"";
    } else {
        baseURLString = [urlString substringToIndex:queryRange.location];
        queryString = [urlString substringFromIndex:queryRange.location + 1];
    }
    
    // Parse query parameters
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
    NSArray *queryPairs = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *pair in queryPairs) {
        if ([pair length] == 0) continue;
        
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        if ([keyValue count] < 2) continue;
        
        NSString *key = customURLDecode(keyValue[0]);
        NSString *value = customURLDecode(keyValue[1]);
        
        queryParams[key] = value;
    }
    
    // Add accessKey parameter
    queryParams[@"accessKey"] = token;
    
    // Rebuild query string
    NSMutableArray *newQueryPairs = [NSMutableArray array];
    for (NSString *key in queryParams) {
        NSString *value = queryParams[key];
        
        NSString *escapedKey = customURLEncode(key);
        NSString *escapedValue = customURLEncode(value);
        
        [newQueryPairs addObject:[NSString stringWithFormat:@"%@=%@", escapedKey, escapedValue]];
    }
    
    NSString *newQueryString = [newQueryPairs componentsJoinedByString:@"&"];
    NSString *newURLString = baseURLString;
    if ([newQueryString length] > 0) {
        newURLString = [baseURLString stringByAppendingFormat:@"?%@", newQueryString];
    }
    
    return [NSURL URLWithString:newURLString];
}

%hook GEOResourceManifestServerLocalProxy

- (id)_manifestURL {
    id originalURL = %orig;
    NSLog(@"Original Manifest URL: %@", originalURL);

    NSString *newURLString = @"https://gspe21-ssl.ls.apple.com/config/prod-resources-hidpi-20";

    // Return the new URL
    return newURLString;
}

%end

%hook NSURLRequest

- (instancetype)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval {
    //  URL Rewrites
    NSString *newURLString = [[URL absoluteString] stringByReplacingOccurrencesOfString:@"gspa35-ssl.ls.apple.com" withString:@"gspe35-ssl.ls.apple.com"];
    newURLString = [newURLString stringByReplacingOccurrencesOfString:@"gspa11.ls.apple.com" withString:@"gspe11-ssl.ls.apple.com"];
    newURLString = [newURLString stringByReplacingOccurrencesOfString:@"gspa12.ls.apple.com" withString:@"gspe12.ls.apple.com"];
    newURLString = [newURLString stringByReplacingOccurrencesOfString:@"gspa19.ls.apple.com" withString:@"gspe19.ls.apple.com"];
    // newURLString = [newURLString stringByReplacingOccurrencesOfString:@"gspe19-ssl.ls.apple.com" withString:@"gspe19.ls.apple.com"];
    newURLString = [newURLString stringByReplacingOccurrencesOfString:@"gspa21.ls.apple.com" withString:@"gspa21.ls.apple.com"];
    newURLString = [newURLString stringByReplacingOccurrencesOfString:@"gsp1.apple.com" withString:@"gspe1-ssl.ls.apple.com"];
    newURLString = [newURLString stringByReplacingOccurrencesOfString:@"gsp10-ssl.ls.apple.com/use" withString:@"gsp64-ssl.ls.apple.com/a/v2/use"];
    NSURL *newURL = [NSURL URLWithString:newURLString];

    // if ([newURLString containsString:@"invalid.server"]) {
    //     void *callstack[128];
	// 	int frames = backtrace(callstack, 128);
	// 	char **symbols = backtrace_symbols(cdispatcherallstack, frames);
	// 	// NSString *imlazy = @"a";
	// 	NSMutableString *callstackString = [NSMutableString stringWithFormat:@"[MapsX] Callstack for modifying:\n"];;
	// 	for (int i = 0; i < frames; i++) {
	// 		[callstackString appendFormat:@"%s\n", symbols[i]];
	// 	}
	// 	NSLog(@"%@", callstackString);
		
	// 	free(symbols);
    // }

    // Check if the URL host is "gspe21-ssl.ls.apple.com" and change the scheme to "http"AIM
    // if ([[URL host] isEqualToString:@"gspe21-ssl.ls.apple.com"]) {
    //     NSString *newURLString = [[URL absoluteString] stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
    //     NSURL *newURL = [NSURL URLWithString:newURLString];
    //     return %orig(newURL, cachePolicy, timeoutInterval);
    // }
    return %orig(newURL, cachePolicy, timeoutInterval);
}

%end

%hook NSURLConnection

- (instancetype)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    NSURL *originalURL = [request URL];
    if (!(
         ([[originalURL host] isEqualToString:@"gspe11-ssl.ls.apple.com"]) || 
         ([[originalURL host] isEqualToString:@"gspe11.ls.apple.com"]) || 
         ([[originalURL host] isEqualToString:@"gspe19.ls.apple.com"]) || 
         ([[originalURL host] isEqualToString:@"gspe12.ls.apple.com"]))) {
        return %orig(request, delegate, startImmediately);
    }

    NSString *urlString = [originalURL absoluteString];
    
    NSLog(@"Original URL (initWithRequest:delegate:startImmediately:): %@", urlString);
    
    // Use the helper function to add the accessKey parameter
    NSURL *newURL = addAccessKeyToURL(originalURL);
    
    // Create a mutable copy of the request and set the new URL
    NSMutableURLRequest *modifiedRequest = [request mutableCopy];
    [modifiedRequest setURL:newURL];
    
    NSLog(@"Modified URL (initWithRequest:delegate:startImmediately:): %@", [newURL absoluteString]);
    
    return %orig(modifiedRequest, delegate, startImmediately);
}

%end

%hook GEODirectionsRequest

-(void)writeTo:(id)writer {
    // void *callstack[128];
    // int frames = backtrace(callstack, 128);
    // char **symbols = backtrace_symbols(callstack, frames);
    // NSString *imlazy = @"a";
    // NSMutableString *callstackString = [NSMutableString stringWithFormat:@"[MapsX] Callstack for modifying %@:\n", imlazy];
    // for (int i = 0; i < frames; i++) {
    //     [callstackString appendFormat:@"%s\n", symbols[i]];
    // }
    // NSLog(@"%@", callstackString);
    
    // free(symbols);
    NSLog(@"[MapsX] GEODirectionsRequest.writeTo called!");
    if ([writer isKindOfClass:[PBDataWriter class]]) {      
        NSValue *hasValue = [self valueForKey:@"_has"];
        unsigned int hasFlags = 0;
        
        // i have no clue if this works
        if ([hasValue isKindOfClass:[NSNumber class]]) {
            hasFlags = [(NSNumber *)hasValue unsignedIntValue];
        } else {
            [hasValue getValue:&hasFlags];
        }
        
        NSLog(@"[MapsX] Has flags: %u", hasFlags);

        // route attributes  
        PBCodable *routeAttributes = [self valueForKey:@"_routeAttributes"];
        if (routeAttributes != nil) {
            PBDataWriter *dataWriter = [[PBDataWriter alloc] init];
            [routeAttributes writeTo:dataWriter];
            [writer writeData:[dataWriter data] forTag:1];
        }

        if (hasFlags & 0x2) {  // maxRouteCount flag
            NSNumber *maxRouteCount = [self valueForKey:@"_maxRouteCount"];
            if (maxRouteCount != nil) {
                [writer writeUint32:[maxRouteCount unsignedIntValue] forTag:3]; // mainTransportTypeMaxRouteCount on iOS 11
            }
        }
        
        PBCodable *currentUserLocation = [self valueForKey:@"_currentUserLocation"];
        if (currentUserLocation != nil) {
            PBDataWriter *dataWriter = [[PBDataWriter alloc] init];
            [currentUserLocation writeTo:dataWriter];
            [writer writeData:[dataWriter data] forTag:4];
        }

        GEOMapRegion *currentMapRegion = [self valueForKey:@"_currentMapRegion"];
        if (currentMapRegion != nil) {
            PBDataWriter *dataWriter = [[PBDataWriter alloc] init];
            [currentMapRegion writeTo:dataWriter];
            [writer writeData:[dataWriter data] forTag:5];
        }
        

        NSData* (^writeWaypointAsTyped)(GEOWaypoint *) = ^NSData* (GEOWaypoint *waypoint) {
            PBDataWriter *waypointWriter = [[PBDataWriter alloc] init];
            // I'm not sure of all the types but,
            // 2 = place search result?
            // 4 = Latlong/gps loc?

            // In actual source it's
            // 2 = Waypoint ID
            // 3 = Waypoint Place
            // 4 = Waypoint Location
            GEOPlaceSearchRequest *placeRequest = [waypoint valueForKey:@"_placeSearchRequest"];
            GEOPlaceSearchRequest *location = [waypoint valueForKey:@"_location"];
            if (placeRequest) { // type 2, GEOWaypointID, https://github.com/nst/iOS-Runtime-Headers/blob/f53e3d01aceb4aab6ec2c37338d2df992d917536/PrivateFrameworks/GeoServices.framework/GEOWaypointID.h
                logGEOPlaceSearchRequestDetails(placeRequest);
                [waypointWriter writeInt32:2 forTag:1];
                PBDataWriter *waypointId = [[PBDataWriter alloc] init];
                // [waypointId writeUint64:11026153924627430591LLU forTag:1]; // I think this is some sort of ID for the location? i dunno.
                // [waypointId writeUint64:7618 forTag:2]; // ResultProviderId
                NSString *search = [placeRequest valueForKey:@"_search"]; // I am not happy about this being the only data for some requests.
                GEOLocation *placeLocation = [placeRequest valueForKey:@"_location"];
                if (placeLocation) {
                    GEOLatLng *latLng = [placeLocation valueForKey:@"_latLng"];
                    if (latLng) {
                        NSNumber *lat = [latLng valueForKey:@"_lat"];
                        NSNumber *lng = [latLng valueForKey:@"_lng"];
                        if (lat && lng) {
                            NSLog(@"[MapsX] writing lat/long");
                            NSLog(@"Lat Long: %@, %@", lat, lng);
                            PBDataWriter *latlong = [[PBDataWriter alloc] init];
                            [latlong writeDouble:[lat doubleValue] forTag:1];
                            [latlong writeDouble:[lng doubleValue] forTag:2];
                            [waypointId writeData:[latlong data] forTag:3];
                        }
                    }
                    GEOAddress *address = [placeRequest valueForKey:@"_address"]; // if it has it.
                    if (address) {
                        GEOStructuredAddress *stAddress = [placeRequest valueForKey:@"_structuredAddress"];
                        if (stAddress) {
                            PBDataWriter *stAddressP = [[PBDataWriter alloc] init];
                            [stAddress writeTo:stAddressP];
                            [waypointId writeData:[stAddressP data] forTag:4];
                        }
                    }
                } else {
                    GEOAddress *address = [placeRequest valueForKey:@"_address"];
                    if (address) {
                        NSLog(@"[MapsX] has address");
                        GEOStructuredAddress *stAddress = [placeRequest valueForKey:@"_structuredAddress"];
                        if (stAddress) {
                            NSLog(@"[MapsX] writing structured address data ");
                            PBDataWriter *stAddressP = [[PBDataWriter alloc] init];
                            [stAddress writeTo:stAddressP];
                            [waypointId writeData:[stAddressP data] forTag:4];
                        }
                    } else {
                        // welcome to nightmare mode. from here, we do not have enough information to complete the request successfully. We need extra data. Which means a web request! 2G users must be screaming rn.
                        if (search) {
                            NSLog(@"[MapsX] search request %@", search);
                            if (currentMapRegion) { 
                                GEOWaypointID *waypointID = [GEOWaypointID alloc];
                                NSError *error = [QueryToLatLng getQueryToLatLng:search region:currentMapRegion out:waypointID];
                                NSLog(@"[MapsX] Query outputted: %@", error);
                            }
                            

                            [waypointId writeString:search forTag:5]; 
                            // [waypointId writeString:search forTag:6]; // mapRegion, or smth like that
                        } else {
                            NSLog(@"[MapsX] no search request, uhhhh what? bruh.");
                        }
                    }
                }
                

                // [waypointId writeString:@"Los Angeles" forTag:5]; // placeName
                
                
                [waypointId writeInt32:16 forTag:7]; // placeTypeHint
                [waypointWriter writeData:[waypointId data] forTag:2];
            } else if (location) {
                [waypointWriter writeInt32:4 forTag:1];// types
        
                // // Create a properly nested message for tag4 inside tag22
                PBDataWriter *locationP = [[PBDataWriter alloc] init];
                [location writeTo:locationP];

                PBDataWriter *tag22_4 = [[PBDataWriter alloc] init];
                [tag22_4 writeData:[locationP data] forTag:1];
                
                [waypointWriter writeData:[tag22_4 data] forTag:4];
                [waypointWriter writeInt32:1 forTag:5];
            }
            return [waypointWriter data];
        };
        
        NSArray *waypoints = [self valueForKey:@"_waypoints"];
        NSFastEnumerationState state = {0};
        __unsafe_unretained id objects[16];
        NSUInteger count = [waypoints countByEnumeratingWithState:&state objects:objects count:16];
        if (count != 0) {
            do {
                for (NSUInteger i = 0; i < count; i++) {
                    id waypoint = state.itemsPtr[i];
                    NSData *waypointData = writeWaypointAsTyped(waypoint);
                    [writer writeData:waypointData forTag:22]; // waypointTyped
                }
                count = [waypoints countByEnumeratingWithState:&state objects:objects count:16];
            } while (count != 0);
        } 


        NSArray *serviceTags = [self valueForKey:@"_serviceTags"];
        NSFastEnumerationState serviceState = {0};
        __unsafe_unretained id serviceObjects[16];
        count = [serviceTags countByEnumeratingWithState:&serviceState objects:serviceObjects count:16];
        if (count != 0) {
            do {
                for (NSUInteger i = 0; i < count; i++) {
                    id serviceTag = serviceState.itemsPtr[i];
                    PBDataWriter *serviceWriter = [[PBDataWriter alloc] init];
                    [serviceTag writeTo:serviceWriter];
                    [writer writeData:[serviceWriter data] forTag:100];
                }
                count = [serviceTags countByEnumeratingWithState:&serviceState objects:serviceObjects count:16];
            } while (count != 0);
        }
        
    } else {
        return %orig;
    }
}

%end
%hook GEOAltitudeManifest
+ (id)sharedManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)parser:(id)arg1 didStartElement:(id)arg2 namespaceURI:(id)arg3 qualifiedName:(id)arg4 attributes:(id)arg5 { %log; %orig; }
- (void)parseManifest:(id)arg1 { %log; %orig; }
- (id)availableRegions { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (unsigned int)versionForRegion:(unsigned int)arg1 { %log; unsigned int r = %orig; NSLog(@" = %u", r); return r; }
- (void)dealloc { %log; %orig; }
- (BOOL)parseXml:(id)arg1 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (void)_activeTileGroupChanged:(id)arg1 { %log; %orig; }
- (id)initWithoutObserver { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end


// %hook AltitudeNetworkRunLoop
// + (void)AltitudeNetworkRun:(id)arg1 { %log; %orig; }
// + (void)_runNetworkThread:(id)arg1 { %log; %orig; }
// %end
%hook AltMapView
// + (Class)layerClass { %log; Class r = %orig; NSLog(@" = %@", r); return r; }
// - (void)setDirectionsDelegate:(NSObject *)directionsDelegate { %log; %orig; }
// - (NSObject *)directionsDelegate { %log; NSObject *r = %orig; NSLog(@" = 0x%llx", (uint64_t)r); return r; }
// - (void)setDownloading:(BOOL)downloading { %log; %orig; }
// - (BOOL)downloading { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// - (void)setDelegate:(id)delegate { %log; %orig; }
// - (id)delegate { %log; id r = %orig; NSLog(@" = 0x%llx", (uint64_t)r); return r; }
// - (void)setRenderer:(__strong id *)renderer { %log; %orig; }
// - (__strong id *)renderer { %log; __strong id *r = %orig; NSLog(@" = %p", r); return r; }
- (void)setManifest:(NSString *)manifest { %log; %orig; }
- (NSString *)manifest { %log; NSString *r = %orig; NSLog(@" = %@", r); return r; }
// - (void)initialize { %log; %orig; }
%end

// %hook AltTileFetcher
// - (BOOL)isDownloading { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// - (void)purgeExpired:(double)arg1 { %log; %orig; }
// - (void)cancelRequests { %log; %orig; }
// - (_Bool)fetchDataForJobs:(id)arg1 count:(unsigned int)arg2 { %log; _Bool r = %orig; NSLog(@" = %d", r); return r; }
// %end
