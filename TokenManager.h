#import <Foundation/Foundation.h>

@interface TokenManager : NSObject

+ (instancetype)sharedManager;
- (NSString *)currentToken;

@end