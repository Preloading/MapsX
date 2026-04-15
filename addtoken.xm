#include <Foundation/Foundation.h>
#import "GEOTokenManager.h"
#import "GEOQueryToLatLng.h"
#import <execinfo.h>
#import <objc/message.h>

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


%hookf(NSURL *, GEOURLAuthenticationGenerateURL, NSURL *url, NSString *tk) {
    NSLog(@"tk -> %@, url -> %@", tk, url);
    //         void *callstack[128];
	// int frames = backtrace(callstack, 128);
	// char **symbols = backtrace_symbols(callstack, frames);
	// NSMutableString *callstackString = [NSMutableString stringWithFormat:@"[MapsX] Callstack for auth gen url"];
	// for (int i = 0; i < frames; i++) {
	// 	[callstackString appendFormat:@"%s\n", symbols[i]];
	// }
	// NSLog(@"%@", callstackString);
	
	// free(symbols);

    // technically we don't *need* to do the original result, but it makes the logic *slightly* simpler
    NSURL *originalResult = %orig(url, tk);

    NSString *token = [[GEOTokenManager sharedManager] currentAccessKey];
    NSString *urlString = [originalResult absoluteString];
    if (token == nil) {
        return originalResult;
    }

    // unless original result fails, this should always already have a query param.
    urlString = [NSString stringWithFormat:@"%@&accessKey=%@", originalResult, customURLEncode(token)];
    // NSLog(@"url string -> %@", urlString);
    return [NSURL URLWithString:urlString];
}

%ctor {
  %init(GEOURLAuthenticationGenerateURL=MSFindSymbol(NULL, "_GEOURLAuthenticationGenerateURL"));
}