#include <Foundation/Foundation.h>
#import "GEOTokenManager.h"
#import "GEOQueryToLatLng.h"
#import <execinfo.h>
#import <objc/message.h>
#import <CommonCrypto/CommonCrypto.h>

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

typedef struct SessionID {
	unsigned long long var0;
	unsigned long long var1;
} SessionID;


@interface GEOResourceManifestManager : NSObject

+(GEOResourceManifestManager*)sharedManager;
-(NSString*)authToken;

@end

@interface GEOUserSession : NSObject

+(GEOUserSession*)sharedInstance;
-(SessionID)sessionID;

@end

@interface NSMutableData (MapsX)
-(NSString*)base64Encoding;
@end

static NSString *generateTokenP3() {
    NSString *chars = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [NSMutableString stringWithCapacity:16];
    for (int i = 0; i < 16; i++) {
        [result appendFormat:@"%c", [chars characterAtIndex:arc4random_uniform((uint32_t)chars.length)]];
    }
    return result;
}


%hookf(NSURL *, GEOURLAuthenticationGenerateURL, NSURL *url, NSString *tk) {
    NSString *p3 = generateTokenP3();
    NSString *authToken = [[%c(GEOResourceManifestManager) sharedManager] authToken];
    if ( authToken )
    {
        NSString *sid = @"6942069420694206942069420694206942067676";

        NSString *token = [NSString stringWithFormat:@"4cjLaD4jGRwlQ9U%@%@", authToken, p3];
        long long timestamp = (long long)[[NSDate date] timeIntervalSince1970] + 4200;

        NSString *originalURL = [url absoluteString];

        NSString *seperator = @"?";
        if ([originalURL rangeOfString:@"?"].location != NSNotFound) {
            seperator = @"&";
        }

        NSData *hashData = [token dataUsingEncoding:NSUTF8StringEncoding];
        unsigned char digest[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256(hashData.bytes, (CC_LONG)hashData.length, digest);        
        NSData *key = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];

        NSString *query = [url query] ?: @"";
        NSString *plaintext = [NSString stringWithFormat:@"%@?%@%@sid=%@%lld%@", [url path], query, query.length > 0 ? @"&" : @"", sid, timestamp, p3];

        NSData *plaintextData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];

        NSUInteger blockSize = 16;
        NSUInteger padding = blockSize - (plaintextData.length % blockSize);
        NSMutableData *padded = [plaintextData mutableCopy];
        for (NSUInteger i = 0; i < padding; i++) {
            uint8_t byte = (uint8_t)padding;
            [padded appendBytes:&byte length:1];
        }

        NSMutableData *ciphertext = [NSMutableData dataWithLength:padded.length];
        uint8_t iv[16] = {0};
        size_t bytesEncrypted = 0;
        CCCryptorStatus status = CCCrypt(
            kCCEncrypt,
            kCCAlgorithmAES,
            0,
            key.bytes, key.length,
            iv,
            padded.bytes, padded.length,
            ciphertext.mutableBytes, ciphertext.length,
            &bytesEncrypted);

        if (status != kCCSuccess) {
            NSLog(@"[MapsX] CCCrypt failed: %d", status);
            return url;
        }
        ciphertext.length = bytesEncrypted;

        NSString *b64 = [ciphertext base64Encoding];

        NSString *encoded = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
            NULL,
            (CFStringRef)b64,
            NULL,
            CFSTR("!*'();:@&=+$,/?#[]"),
            kCFStringEncodingUTF8));

        NSString *accessKey = [NSString stringWithFormat:@"%lld_%@_%@", timestamp, p3, encoded];
        NSString *newURLString = [NSString stringWithFormat:@"%@%@sid=%@&accessKey=%@", originalURL, seperator, sid, accessKey];
        return [NSURL URLWithString:newURLString];
    }
    return url;
}

%ctor {
  %init(GEOURLAuthenticationGenerateURL=MSFindSymbol(NULL, "_GEOURLAuthenticationGenerateURL"));
}