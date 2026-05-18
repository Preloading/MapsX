#import <Foundation/Foundation.h>
#import <malloc/malloc.h>
#import <substrate.h>
#import "GEOShieldMappingManager.h"

typedef struct PointsStruct {
	unsigned x;
	unsigned y;
} PointsStruct;


typedef struct {
	int list;
	unsigned count;
	unsigned size;
} SCD_Struct_VK106;



@interface VKPShieldIndex : NSObject
-(id)entries;
@end

@interface VKShieldAtlas : NSObject
@end

%hook VKPShieldIndex

-(NSString*)artworkIdentifierForShieldType:(int)shieldType
{
    // return %orig(8420);
    id orig = %orig;
    if (!orig) {
        NSLog(@"sdid(%i)", shieldType);
    }
    return orig;
}
%end

%ctor {
    [GEOShieldMappingManager sharedManager];
}

%hook VKShieldManager
-(id)artworkForShieldType:(int)shieldType textLength:(unsigned)textLen contentScale:(float)contentScale resourceNames:(id)resourceNames style:(id)style mode:(int)mode numberOfLines:(unsigned)numOfLines {
    int newShieldID = [[GEOShieldMappingManager sharedManager] translateMap:shieldType];
    if (newShieldID == 0) return %orig();

    return %orig(newShieldID, textLen, contentScale, resourceNames, style, mode, numOfLines);
}

-(id)artworkForShieldType:(int)shieldType textLength:(unsigned)textLen contentScale:(float)contentScale resourceNames:(id)resourceNames style:(id)style mode:(int)mode {
    int newShieldID = [[GEOShieldMappingManager sharedManager] translateMap:shieldType];
    if (newShieldID == 0) return %orig();

    return %orig(newShieldID, textLen, contentScale, resourceNames, style, mode);
}
%end