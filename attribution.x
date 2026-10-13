#import <Foundation/Foundation.h>


@interface GEOAttribution : NSObject {

	NSString* _badge;
	NSString* _logo;
	NSString* _name;
	NSString* _url;
}
@property (nonatomic,readonly) char hasBadge; 
@property (nonatomic,retain) NSString * badge;              //@synthesize badge=_badge - In the implementation block
@property (nonatomic,readonly) char hasLogo; 
@property (nonatomic,retain) NSString * logo;               //@synthesize logo=_logo - In the implementation block
@property (nonatomic,readonly) char hasName; 
@property (nonatomic,retain) NSString * name;               //@synthesize name=_name - In the implementation block
@property (nonatomic,readonly) char hasUrl; 
@property (nonatomic,retain) NSString * url;                //@synthesize url=_url - In the implementation block
-(id)dictionaryRepresentation;
-(NSString *)url;
-(void)setUrl:(NSString *)arg1 ;
-(char)hasBadge;
-(NSString *)badge;
-(char)hasLogo;
-(NSString *)logo;
-(char)hasUrl;
-(void)setBadge:(NSString *)arg1 ;
-(void)setLogo:(NSString *)arg1 ;
-(char)readFrom:(id)arg1 ;
-(void)dealloc;
-(char)isEqual:(id)arg1 ;
-(unsigned)hash;
-(id)description;
-(NSString *)name;
-(void)setName:(NSString *)arg1 ;
-(void)writeTo:(id)arg1 ;
-(void)copyTo:(id)arg1 ;
-(char)hasName;
@end


%hook GEOActiveTileGroup 
-(id)attributionAtIndex:(int)index {
    GEOAttribution *attribution = [[%c(GEOAttribution) alloc] init];
    [attribution setName:@"TomTom"];
    [attribution setLogo:@"tomtom-2@2x.png"];
    [attribution setUrl:@"https://gspe21-ssl.ls.apple.com/html/attribution.html"];// may change but ehhS
    return attribution;
}

-(id)attributions {
    GEOAttribution *attribution = [[%c(GEOAttribution) alloc] init];
    [attribution setName:@"TomTom"];
    [attribution setLogo:@"tomtom-2@2x.png"];
    [attribution setUrl:@"https://gspe21-ssl.ls.apple.com/html/attribution.html"];// may change but ehhS
    return [@[attribution] mutableCopy];
}

%end

%hook GEOResources

-(NSMutableArray*)attributions
{
    GEOAttribution *attribution = [[%c(GEOAttribution) alloc] init];
    [attribution setName:@"TomTom"];
    [attribution setLogo:@"tomtom-2@2x.png"];
    [attribution setUrl:@"https://gspe21-ssl.ls.apple.com/html/attribution.html"];// may change but ehhS
    return [@[attribution] mutableCopy];
}

%end

// extracted from ye ols 
// "2": "tomtom-2@2x.png",
// "3": "TomTom",
// "4": "https://gspe21-ssl.ls.apple.com/html/attribution-98.html"

static BOOL readVarint(const uint8_t *b, NSUInteger len, NSUInteger *pos, uint64_t *out) {
    uint64_t r = 0;
    int shift = 0;
    NSUInteger i = *pos;
    while (i < len) {
        uint8_t byte = b[i++];
        r |= (uint64_t)(byte & 0x7F) << shift;
        if (!(byte & 0x80)) {
            *pos = i;
            *out = r;
            return YES;
        }
        shift += 7;
    }
    return NO;
}

static NSData *pbGetData(NSData *data, uint32_t field) {
    const uint8_t *b = (const uint8_t *)data.bytes;
    NSUInteger len = data.length;
    NSUInteger pos = 0;
    NSData *found = nil;
    
    while (pos < len) {
        uint64_t tag;
        if (!readVarint(b, len, &pos, &tag)) break;
        uint32_t fnum = (uint32_t)(tag >> 3);
        uint32_t wtype = (uint32_t)(tag & 7);
        
        if (wtype == 0) {
            uint64_t v;
            if (!readVarint(b, len, &pos, &v)) break;
        } else if (wtype == 1) {
            pos += 8;
        } else if (wtype == 5) {
            pos += 4;
        } else if (wtype == 2) {
            uint64_t flen;
            if (!readVarint(b, len, &pos, &flen)) break;
            if (flen > len - pos) break;
            if (fnum == field) {
                found = [NSData dataWithBytes:(b + pos) length:(NSUInteger)flen];
            }
            pos += (NSUInteger)flen;
        } else {
            break;
        }
    }
    return found;
}

static NSString *pbGetString(NSData *data, uint32_t field) {
    NSData *d = pbGetData(data, field);
    if (!d) return nil;
    return [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
}

static NSString *resolveURL(uint32_t field) {
    NSURL *url = [NSURL URLWithString:@"https://gspe21-ssl.ls.apple.com/config/prod-resources-hidpi-20"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    req.timeoutInterval = 5.0;
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    
    if (error || !data) return nil;
    return pbGetString(data, field);
}

@interface MapsAttributionFixProtocol : NSURLProtocol
@end

@implementation MapsAttributionFixProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([NSURLProtocol propertyForKey:@"MAFHandled" inRequest:request]) return NO;
    NSString *host = request.URL.host;
    NSString *path = request.URL.path;
    if (![host isEqualToString:@"gspa21.ls.apple.com"]) return NO;
    return [path isEqualToString:@"/config/search-attribution-1"] || [path isEqualToString:@"/config/com.apple.GEO.BusinessLocalizedCategories-1.plist"];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSURL *original = self.request.URL;
    uint32_t field = [original.path isEqualToString:@"/config/search-attribution-1"] ? 33 : 55; // tag 33 is the search attribution url string, 55 is the one for the business categories
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *resolved = resolveURL(field);
        NSURL *targetURL = resolved ? [NSURL URLWithString:resolved] : nil;
        if (!targetURL) targetURL = original;
        
        NSMutableURLRequest *req = [self.request mutableCopy];
        req.URL = targetURL;
        [NSURLProtocol setProperty:@YES forKey:@"MAFHandled" inRequest:req];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        
        if (error) {
            [self.client URLProtocol:self didFailWithError:error];
            return;
        }
        
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    });
}

- (void)stopLoading {}

@end

%ctor {
    [NSURLProtocol registerClass:[MapsAttributionFixProtocol class]];
}