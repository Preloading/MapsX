#import <Foundation/Foundation.h>

@interface GEOShieldMappingManager : NSObject
@property (atomic, strong) NSDictionary *shieldMappings;
@property (atomic, assign) int dataVersion;
@property (atomic, assign) BOOL hasFetchedFromOnline;
@property (nonatomic, strong) NSURLConnection *connection;

+ (instancetype)sharedManager;
-(NSError *)loadShieldsFile;
-(NSError*)loadMappingsFromData:(NSData*)data;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(int)translateMap:(int)map;
@end
