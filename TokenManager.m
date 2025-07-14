#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "TokenManager.h"

@interface TokenManager ()
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) NSTimeInterval expiresAt;
@property (nonatomic, strong) NSOperationQueue *tokenOperationQueue;
@end

@implementation TokenManager

+ (instancetype)sharedManager {
    static TokenManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.tokenOperationQueue = [[NSOperationQueue alloc] init];
        sharedManager.tokenOperationQueue.maxConcurrentOperationCount = 1;
        NSLog(@"[MapsX] TokenManager singleton initialized: %p", sharedManager);
    });
    return sharedManager;
}

- (NSString *)currentToken {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    if (_token && now + 300 < _expiresAt) {
        // Token is valid and not about to expire
        // Start async refresh if token will expire soon (within 15 minutes)
        if (now + 900 >= _expiresAt) {
            [self refreshTokenInBackground];
        }
        return _token;
    } else {
        // Token is nil or expired or about to expire - need synchronous refresh
        NSInteger expiresIn = 0;
        _token = [self requestNewMapToken:&expiresIn];
        
        if (_token) {
            _expiresAt = now + expiresIn;
        }
        return _token;
    }
}

- (void)getTokenWithCompletion:(void (^)(NSString *token))completion {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    if (_token && now + 300 < _expiresAt) {
        // Token is valid, return immediately
        completion(_token);
        
        // Refresh in background if needed
        if (now + 900 >= _expiresAt) {
            [self refreshTokenInBackground];
        }
    } else {
        // Need to get a new token
        [self.tokenOperationQueue addOperationWithBlock:^{
            NSInteger expiresIn = 0;
            NSString *newToken = [self requestNewMapToken:&expiresIn];
            
            if (newToken) {
                self.token = newToken;
                self.expiresAt = [[NSDate date] timeIntervalSince1970] + expiresIn;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(newToken);
            });
        }];
    }
}

- (void)refreshTokenInBackground {
    [self.tokenOperationQueue addOperationWithBlock:^{
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        // Only refresh if we still need to (another operation might have refreshed already)
        if (!self.token || now + 300 >= self.expiresAt) {
            NSInteger expiresIn = 0;
            NSString *newToken = [self requestNewMapToken:&expiresIn];
            
            if (newToken) {
                self.token = newToken;
                self.expiresAt = [[NSDate date] timeIntervalSince1970] + expiresIn;
                NSLog(@"Token refreshed in background");
            }
        }
    }];
}

- (NSString *)requestNewMapToken:(NSInteger *)outExpiresIn {
    // pods code ported to objc
    NSString *duckDuckGoTokenURL = @"https://duckduckgo.com/local.js?get_mk_token=1";
    NSURL *url = [NSURL URLWithString:duckDuckGoTokenURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url 
                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                      timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request 
                                                returningResponse:&response 
                                                            error:&error];
    
    if (error) {
        NSLog(@"Connection failed: %@", [error localizedDescription]);
        return nil;
    }

    NSString *duckduckgotoken = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    // Now get the actual token we need from apple
    NSString *appleTokenURL = @"https://cdn.apple-mapkit.com/ma/bootstrap?apiVersion=2&mkjsVersion=5.79.95&poi=1";
    url = [NSURL URLWithString:appleTokenURL];
    request = [NSMutableURLRequest requestWithURL:url 
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                 timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", duckduckgotoken] forHTTPHeaderField:@"Authorization"];
    
    response = nil;
    error = nil;
    responseData = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response 
                                                     error:&error];
    
    if (error) {
        NSLog(@"Connection failed: %@", [error localizedDescription]);
        return nil;
    }
    
    error = nil;
    id object = [NSJSONSerialization
                      JSONObjectWithData:responseData
                      options:0
                      error:&error];

    if(error) { 
        NSLog(@"Failed to decode Apple Mapkit json: %@", [error localizedDescription]);
        return nil; 
    }

    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
        if (outExpiresIn) {
            *outExpiresIn = [results[@"expiresInSeconds"] integerValue];
        }
        return results[@"accessKey"];
    }
    else
    {
        NSLog(@"Failed to decode Apple Mapkit json: Decode was not a dictionary.");
        return nil;
    }
    
}

@end