#include <OpenGLES/EAGL.h>

@interface VGLTexture : NSObject {

	CGRect _contentRect;
	CGSize _textureSize;
	char _dirty;
	char _isLoaded;
	char _hasMipmap;
	unsigned _token;
	int _target;
	int _wrapBehaviorX;
	int _wrapBehaviorY;
	int _minFilter;
	int _magFilter;
	EAGLContext* _context;
}
@property (nonatomic,readonly) CGRect contentRect;                 //@synthesize contentRect=_contentRect - In the implementation block
@property (nonatomic,readonly) CGSize textureSize;                 //@synthesize textureSize=_textureSize - In the implementation block
@property (nonatomic,readonly) char isLoaded;                      //@synthesize isLoaded=_isLoaded - In the implementation block
@property (nonatomic,readonly) char dirty;                         //@synthesize dirty=_dirty - In the implementation block
@property (assign,nonatomic) char hasMipmap;                       //@synthesize hasMipmap=_hasMipmap - In the implementation block
@property (assign,nonatomic) unsigned token;                       //@synthesize token=_token - In the implementation block
@property (assign,nonatomic) int target;                           //@synthesize target=_target - In the implementation block
@property (assign,nonatomic) int wrapBehavior; 
@property (assign,nonatomic) int wrapBehaviorX;                    //@synthesize wrapBehaviorX=_wrapBehaviorX - In the implementation block
@property (assign,nonatomic) int wrapBehaviorY;                    //@synthesize wrapBehaviorY=_wrapBehaviorY - In the implementation block
@property (assign,nonatomic) int minificationFilter;               //@synthesize minFilter=_minFilter - In the implementation block
@property (assign,nonatomic) int magnificationFilter;              //@synthesize magFilter=_magFilter - In the implementation block
+(void)purge;
+(id)textureWithName:(id)arg1 forScale:(float)arg2 ;
+(id)textureWithName:(id)arg1 ;
-(id)initWithName:(id)arg1 ;
-(id)initWithData:(id)arg1 ;
-(void)setMagnificationFilter:(int)arg1 ;
-(id)initWithSize:(CGSize)arg1 ;
-(CGRect)contentRect;
-(void)setMinificationFilter:(int)arg1 ;
-(char)isLoaded;
-(char)dirty;
-(unsigned)token;
-(id)init;
-(void)dealloc;
-(id)description;
-(int)target;
-(void)setTarget:(int)arg1 ;
-(char)decodeTexture;
-(void)setWrapBehavior:(int)arg1 ;
-(char)loadTexture;
-(void)setWrapBehaviorX:(int)arg1 ;
-(void)setWrapBehaviorY:(int)arg1 ;
-(id)initWithData:(id)arg1 loadImmediately:(char)arg2 ;
-(void)useTextureWithContext:(id)arg1 ;
-(int)wrapBehavior;
-(CGSize)textureSize;
-(char)hasMipmap;
-(void)setHasMipmap:(char)arg1 ;
-(void)setToken:(unsigned)arg1 ;
-(int)wrapBehaviorX;
-(int)wrapBehaviorY;
-(int)minificationFilter;
-(int)magnificationFilter;
@end