#import <Foundation/Foundation.h>

@interface TokenManager : NSObject

+ (instancetype)sharedManager;
- (NSString *)currentAccessKey;
- (NSString *)currentAccessToken;

@end