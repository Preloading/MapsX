#import <Foundation/Foundation.h>
#import <fcntl.h>

%hookf(int, open, const char *path, int flags, int mode) {
    if (path && !(flags & (O_WRONLY | O_RDWR | O_CREAT)) && strstr(path, "GeoServices/Resources/altitude-") && strstr(path, ".xml")) {
        NSMutableDictionary *threadInfo = [[NSThread currentThread] threadDictionary];
        if (!threadInfo[@"MapsXReading"]) {
            threadInfo[@"MapsXReading"] = @YES;
            NSString *xml = [NSString stringWithContentsOfFile:[NSString stringWithUTF8String:path] encoding:NSUTF8StringEncoding error:nil];
            [threadInfo removeObjectForKey:@"MapsXReading"];
            if (xml) {
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<trigger region=\"(25[6-9]|2[6-9][0-9]|[3-9][0-9]{2}|[0-9]{4,})\"[^>]*></trigger>" options:0 error:nil];
                NSString *patched = [xml stringByReplacingOccurrencesOfString:@"key=\"USE_APPLE_DG\" value=\"dtm\"" withString:@"key=\"USE_APPLE_DG\" value=\"true\""];
                NSLog(@"[MapsX] altitude USE_APPLE_DG set to true: %d", ![patched isEqualToString:xml]);
                patched = [regex stringByReplacingMatchesInString:patched options:0 range:NSMakeRange(0, [patched length]) withTemplate:@""];
                NSLog(@"[MapsX] altitude triggers trimmed: %lu", (unsigned long)[regex numberOfMatchesInString:xml options:0 range:NSMakeRange(0, [xml length])]);
                NSString *temporaryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSString stringWithUTF8String:path] lastPathComponent]];
                if ([patched writeToFile:temporaryPath atomically:YES encoding:NSUTF8StringEncoding error:nil]) return %orig([temporaryPath fileSystemRepresentation], flags, mode);
            }
        }
    }
    return %orig(path, flags, mode);
}