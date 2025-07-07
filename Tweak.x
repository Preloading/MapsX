#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "TokenManager.h"

@interface PBDataWriter : NSObject
- (void)writeInt32:(int)value forTag:(int)tag;
@end

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

    // Check if the URL host is "gspe21-ssl.ls.apple.com" and change the scheme to "http"
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
    NSLog(@"[MapsX] GEODirectionsRequest.writeTo called!");
    if ([writer isKindOfClass:[PBDataWriter class]]) {
        [writer writeInt32:64 forTag:1];
    } else {
        // panik
        return %orig
    }
    return;
}

%end