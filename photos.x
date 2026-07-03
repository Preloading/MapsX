#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

static NSData *pbVarint(uint64_t v) {
    uint8_t tmp[10]; int i = 0;
    do { uint8_t b = v & 0x7F; v >>= 7; if (v) b |= 0x80; tmp[i++] = b; } while (v);
    return [NSData dataWithBytes:tmp length:i];
}

static BOOL pbReadVarint(const uint8_t *b, NSUInteger *p, NSUInteger end, uint64_t *out) {
    uint64_t r = 0; int shift = 0;
    while (*p < end) {
        uint8_t x = b[(*p)++];
        r |= (uint64_t)(x & 0x7F) << shift;
        if (!(x & 0x80)) { *out = r; return YES; }
        shift += 7; if (shift > 63) return NO;
    }
    return NO;
}

static BOOL pbField(NSData *msg, uint64_t want, NSUInteger *vStart, NSUInteger *vLen, NSUInteger *hStart, uint64_t *varOut) {
    const uint8_t *b = msg.bytes; NSUInteger n = msg.length, p = 0;
    while (p < n) {
        NSUInteger tag = p;
        uint64_t key; if (!pbReadVarint(b, &p, n, &key)) return NO;
        uint64_t field = key >> 3, wire = key & 7;
        if (wire == 2) {
            uint64_t len; if (!pbReadVarint(b, &p, n, &len)) return NO;
            if (p + len > n) return NO;
            if (field == want && vStart) { *vStart = p; *vLen = (NSUInteger)len; if (hStart) *hStart = tag; return YES; }
            p += len;
        } else if (wire == 0) {
            uint64_t v; if (!pbReadVarint(b, &p, n, &v)) return NO;
            if (field == want && varOut) { *varOut = v; return YES; }
        } else if (wire == 1) p += 8;
        else if (wire == 5) p += 4;
        else return NO;
    }
    return NO;
}

static NSData *pbSub(NSData *m, uint64_t f, NSUInteger *hStart, NSUInteger *end) {
    NSUInteger s, l, h;
    if (!pbField(m, f, &s, &l, &h, NULL)) return nil;
    if (hStart) *hStart = h;
    if (end) *end = s + l;
    return [m subdataWithRange:NSMakeRange(s, l)];
}

static NSArray *pbAllFields(NSData *msg, uint64_t want) {
    const uint8_t *b = msg.bytes; NSUInteger n = msg.length, p = 0;
    NSMutableArray *spans = [NSMutableArray array];
    while (p < n) {
        NSUInteger tag = p;
        uint64_t key; if (!pbReadVarint(b, &p, n, &key)) break;
        uint64_t field = key >> 3, wire = key & 7;
        if (wire == 2) {
            uint64_t len; if (!pbReadVarint(b, &p, n, &len)) break;
            if (p + len > n) break;
            if (field == want) [spans addObject:@[@(tag), @(p), @(len)]];
            p += len;
        } else if (wire == 0) { uint64_t v; if (!pbReadVarint(b, &p, n, &v)) break; }
        else if (wire == 1) p += 8;
        else if (wire == 5) p += 4;
        else break;
    }
    return spans;
}

static NSString *podkeyFor(NSString *hostAndPath) {
    const char *c1 = [[hostAndPath stringByAppendingString:@"podpod123"] UTF8String];
    unsigned char md5d[CC_MD5_DIGEST_LENGTH];
    CC_MD5(c1, (CC_LONG)strlen(c1), md5d);
    NSMutableString *stage1 = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) [stage1 appendFormat:@"%02x", md5d[i]];
    
    const char *c2 = [[stage1 stringByAppendingString:@"dopdop321"] UTF8String];
    unsigned char sha1d[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(c2, (CC_LONG)strlen(c2), sha1d);
    NSMutableString *out = [NSMutableString string];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) [out appendFormat:@"%02x", sha1d[i]];
    return out;
}

static NSString *proxiedImageURLString(NSString *original) {
    NSURL *u = [NSURL URLWithString:original];
    if (!u.host) return original;
    NSString *hostAndPath = [NSString stringWithFormat:@"%@%@", u.host, u.path ?: @""];
    return [NSString stringWithFormat:@"http://mpfproxy.podpod123.com/%@?podkey=%@", hostAndPath, podkeyFor(hostAndPath)];
}

static NSData *buildPhoto(NSString *large, NSString *med, NSString *thumb, NSString *hash) {
    NSMutableData *body = [NSMutableData data];
    uint8_t f1[] = {0x08, 0x01}; [body appendBytes:f1 length:2];
    NSString *urls[3] = { large, med, thumb }; uint64_t en[3] = { 8, 4, 1 };
    for (int i = 0; i < 3; i++) {
        if (!urls[i]) continue;
        NSData *u = [urls[i] dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *v = [NSMutableData data];
        uint8_t e = 0x08; [v appendBytes:&e length:1]; [v appendData:pbVarint(en[i])];
        uint8_t tu = 0x12; [v appendBytes:&tu length:1]; [v appendData:pbVarint(u.length)]; [v appendData:u];
        uint8_t f2 = 0x12; [body appendBytes:&f2 length:1]; [body appendData:pbVarint(v.length)]; [body appendData:v];
    }
    NSData *h = [hash dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t f3 = 0x1A; [body appendBytes:&f3 length:1]; [body appendData:pbVarint(h.length)]; [body appendData:h];
    NSMutableData *out = [NSMutableData data];
    uint8_t t = 0x72; [out appendBytes:&t length:1]; [out appendData:pbVarint(body.length)]; [out appendData:body];
    return out;
}

static uint64_t muidFromResult(NSData *result) {
    NSData *f1 = pbSub(result, 1, NULL, NULL); if (!f1) return 0;
    NSData *f10 = pbSub(f1, 10, NULL, NULL); if (!f10) return 0;
    uint64_t muid = 0;
    return pbField(f10, 1, NULL, NULL, NULL, &muid) ? muid : 0;
}

static NSData *spliceField14IntoResult(NSData *result, NSData *photos) {
    NSUInteger f1h, f1e; NSData *f1 = pbSub(result, 1, &f1h, &f1e); if (!f1) return nil;
    NSUInteger f10h, f10e; NSData *f10 = pbSub(f1, 10, &f10h, &f10e); if (!f10) return nil;
    
    NSMutableData *newF10 = [NSMutableData dataWithData:f10];
    [newF10 appendData:photos];
    
    NSMutableData *newF1 = [NSMutableData data];
    [newF1 appendData:[f1 subdataWithRange:NSMakeRange(0, f10h)]];
    uint8_t t10 = 0x52; [newF1 appendBytes:&t10 length:1];
    [newF1 appendData:pbVarint(newF10.length)]; [newF1 appendData:newF10];
    [newF1 appendData:[f1 subdataWithRange:NSMakeRange(f10e, f1.length - f10e)]];
    
    NSMutableData *out = [NSMutableData data];
    [out appendData:[result subdataWithRange:NSMakeRange(0, f1h)]];
    uint8_t t1 = 0x0A; [out appendBytes:&t1 length:1];
    [out appendData:pbVarint(newF1.length)]; [out appendData:newF1];
    [out appendData:[result subdataWithRange:NSMakeRange(f1e, result.length - f1e)]];
    return out;
}

static NSData *spliceAllResults(NSData *pb, NSDictionary *photosByMuid) {
    NSArray *results = pbAllFields(pb, 2);
    if (!results.count) return pb;
    
    NSMutableData *out = [NSMutableData data];
    NSUInteger cursor = 0;
    
    for (NSArray *span in results) {
        NSUInteger hdr = [span[0] unsignedIntegerValue];
        NSUInteger vs  = [span[1] unsignedIntegerValue];
        NSUInteger vl  = [span[2] unsignedIntegerValue];
        
        [out appendData:[pb subdataWithRange:NSMakeRange(cursor, hdr - cursor)]];
        
        NSData *val = [pb subdataWithRange:NSMakeRange(vs, vl)];
        uint64_t muid = muidFromResult(val);
        NSData *blob = muid ? photosByMuid[[NSString stringWithFormat:@"%llu", muid]] : nil;
        if (blob.length) {
            NSData *spliced = spliceField14IntoResult(val, blob);
            if (spliced) val = spliced;
        }
        
        uint8_t t2 = 0x12; [out appendBytes:&t2 length:1];
        [out appendData:pbVarint(val.length)]; [out appendData:val];
        cursor = vs + vl;
    }
    
    [out appendData:[pb subdataWithRange:NSMakeRange(cursor, pb.length - cursor)]];
    return out;
}

static NSData *photoBlobFromComponents(NSArray *comps) {
    NSDictionary *cat = nil;
    for (id c in comps)
        if (([c isKindOfClass:[NSDictionary class]] ? c : nil)[@"type"] &&
            [c[@"type"] isEqual:@"COMPONENT_TYPE_CATEGORIZED_PHOTOS"]) { cat = c; break; }
    if (!cat) return nil;
    NSArray *value = [cat[@"value"] isKindOfClass:[NSArray class]] ? cat[@"value"] : nil;
    if (!value.count) return nil;
    NSDictionary *first = [value[0] isKindOfClass:[NSDictionary class]] ? value[0] : nil;
    NSArray *photos = [first[@"categorizedPhotos"][@"photo"] isKindOfClass:[NSArray class]]
    ? first[@"categorizedPhotos"][@"photo"] : nil;
    if (!photos.count) return nil;
    
    NSMutableData *blob = [NSMutableData data]; NSUInteger count = 0;
    for (id entry in photos) {
        if (count >= 10) break;
        NSDictionary *e = [entry isKindOfClass:[NSDictionary class]] ? entry : nil; if (!e) continue;
        NSDictionary *photo = [e[@"photo"] isKindOfClass:[NSDictionary class]] ? e[@"photo"] : nil; if (!photo) continue;
        NSString *pid = [photo[@"photoId"] isKindOfClass:[NSString class]] ? photo[@"photoId"] : @"";
        NSArray *versions = [photo[@"photoVersion"] isKindOfClass:[NSArray class]] ? photo[@"photoVersion"] : nil;
        if (!versions) continue;
        
        NSString *tmpl = nil, *reg = nil;
        for (id vv in versions) {
            NSDictionary *v = [vv isKindOfClass:[NSDictionary class]] ? vv : nil; if (!v) continue;
            NSString *u = v[@"url"]; if (![u isKindOfClass:[NSString class]]) continue;
            if ([v[@"urlType"] isEqual:@"URL_TYPE_AMP_TEMPLATE"]) tmpl = u;
            else if ([v[@"urlType"] isEqual:@"URL_TYPE_REGULAR"]) reg = u;
        }
        
        NSString *large, *med, *thumb;
        if (tmpl) {
            NSString *(^fill)(NSString *) = ^(NSString *dim) {
                return proxiedImageURLString([[tmpl stringByReplacingOccurrencesOfString:@"{w}x{h}" withString:dim]
                                              stringByReplacingOccurrencesOfString:@"{f}" withString:@"jpg"]);
            };
            large = fill(@"600x400"); med = fill(@"100x100"); thumb = fill(@"30x30");
        } else if (reg) { large = med = thumb = proxiedImageURLString(reg); }
        else continue;
        
        [blob appendData:buildPhoto(large, med, thumb, [NSString stringWithFormat:@"%@|600|400", pid])];
        count++;
    }
    return blob.length ? blob : nil;
}

static NSDictionary *parsePhotos(NSData *json) {
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
    if (![root isKindOfClass:[NSDictionary class]]) return nil;
    NSArray *places = [root[@"places"] isKindOfClass:[NSArray class]] ? root[@"places"] : nil;
    if (!places.count) return nil;
    
    NSMutableDictionary *byMuid = [NSMutableDictionary dictionary];
    for (id pl in places) {
        NSDictionary *place = [pl isKindOfClass:[NSDictionary class]] ? pl : nil; if (!place) continue;
        NSString *muid = [place[@"muid"] isKindOfClass:[NSString class]] ? place[@"muid"] : nil;
        if (!muid) continue;
        NSArray *comps = [place[@"component"] isKindOfClass:[NSArray class]] ? place[@"component"] : nil;
        if (!comps) continue;
        NSData *blob = photoBlobFromComponents(comps);
        if (blob) byMuid[muid] = blob;
    }
    return byMuid.count ? byMuid : nil;
}

@interface MapsPhotosFixProtocol : NSURLProtocol
@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableData *buf;
@property (nonatomic, assign) BOOL delivered;
@end

@implementation MapsPhotosFixProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)r {
    if ([NSURLProtocol propertyForKey:@"MapsPhotosFixHandled" inRequest:r]) return NO;
    return ([(r.URL.absoluteString ?: @"") rangeOfString:@"search.arpc"].location != NSNotFound);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)r { return r; }
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b { return NO; }

- (void)startLoading {
    self.buf = [NSMutableData data];
    NSMutableURLRequest *fwd = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"MapsPhotosFixHandled" inRequest:fwd];
    [fwd setValue:@"identity" forHTTPHeaderField:@"Accept-Encoding"];
    self.conn = [[NSURLConnection alloc] initWithRequest:fwd delegate:self startImmediately:NO];
    [self.conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.conn start];
}

- (void)stopLoading { [self.conn cancel]; self.conn = nil; }

- (void)connection:(NSURLConnection *)c didReceiveResponse:(NSURLResponse *)resp {
    [self.client URLProtocol:self didReceiveResponse:resp cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}
- (void)connection:(NSURLConnection *)c didReceiveData:(NSData *)d { [self.buf appendData:d]; }
- (void)connection:(NSURLConnection *)c didFailWithError:(NSError *)e {
    [self.client URLProtocol:self didFailWithError:e];
}

- (void)deliver:(NSData *)bytes {
    if (self.delivered) return;
    self.delivered = YES;
    [self.client URLProtocol:self didLoadData:bytes];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)c {
    NSData *frame = [self.buf copy];
    if (frame.length < 13) { [self deliver:frame]; return; }
    NSData *pb = [frame subdataWithRange:NSMakeRange(12, frame.length - 12)];
    
    NSMutableArray *muids = [NSMutableArray array];
    for (NSArray *span in pbAllFields(pb, 2)) {
        NSUInteger vs = [span[1] unsignedIntegerValue], vl = [span[2] unsignedIntegerValue];
        uint64_t muid = muidFromResult([pb subdataWithRange:NSMakeRange(vs, vl)]);
        if (muid) [muids addObject:[NSString stringWithFormat:@"%llu", muid]];
    }
    if (!muids.count) { [self deliver:frame]; return; }
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *m in muids) [items addObject:[NSString stringWithFormat:@"{\"muid\":\"%@\"}", m]];
    NSString *bodyStr = [NSString stringWithFormat:@"{\"places\":[%@]}", [items componentsJoinedByString:@","]];
    
    NSString *hostAndPath = @"maps.apple.com/data/place";
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:
                                [NSURL URLWithString:[@"http://mpfproxy.podpod123.com/" stringByAppendingString:hostAndPath]]
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:4.0];
    req.HTTPMethod = @"POST";
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:podkeyFor(hostAndPath) forHTTPHeaderField:@"podkey"];
    req.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{ if (!self.delivered) [self deliver:frame]; });
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *r, NSData *data, NSError *e) {
                               if (self.delivered) return;
                               NSDictionary *photosByMuid = data ? parsePhotos(data) : nil;
                               if (!photosByMuid.count) { [self deliver:frame]; return; }
                               
                               NSData *newPb = spliceAllResults(pb, photosByMuid);
                               if (!newPb) { [self deliver:frame]; return; }
                               
                               NSMutableData *out = [NSMutableData dataWithData:[frame subdataWithRange:NSMakeRange(0, 12)]];
                               [out appendData:newPb];
                               uint32_t len = (uint32_t)(out.length - 10);
                               uint8_t *bb = out.mutableBytes;
                               bb[6]=(len>>24)&0xFF; bb[7]=(len>>16)&0xFF; bb[8]=(len>>8)&0xFF; bb[9]=len&0xFF;
                               [self deliver:out];
                           }];
}

@end

%ctor {
    [NSURLProtocol registerClass:[MapsPhotosFixProtocol class]];
}