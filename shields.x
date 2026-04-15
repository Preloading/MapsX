#import <Foundation/Foundation.h>
#import <malloc/malloc.h>
#import <substrate.h>

// Define a function pointer type
typedef malloc_zone_t *(*vk_malloc_zone_t)(void);
static vk_malloc_zone_t _vk_malloc_zone;

// extern malloc_zone_t *__vk_malloc_zone(void);

typedef struct PointsStruct {
	unsigned x;
	unsigned y;
} PointsStruct;

%hook VKShieldManager
- (id)artworkForShieldType:(int)shieldType // WHY IS THIS NOT FOUND?????
               textLength:(unsigned int)textLength 
             contentScale:(float)contentScale 
            resourceNames:(NSArray *)resourceNames 
                    style:(id)style 
                     mode:(int)mode {
    
    for (NSString *resourceName in resourceNames) {
        NSLog(@"resource name -> %@", resourceName);
    }
    return %orig;
}
%end

%hook VKRealisticTile
-(float)waterZ
{
    NSLog(@"waterZ -> %f", %orig);
    return %orig;
}

%end

%hook VKRealisticPolygonMaker
-(void)generateIndexedTrianglesWithHandler:(id)a3 {
    NSLog(@"silly");
}
%end


@interface VKTriangulator : NSObject {
@public
	void* _opaque_triangulator;
	unsigned long _segments_capacity;
	void* _opaque_segments;
	unsigned long _mesh_capacity;
	unsigned* _mesh;
	NSMutableData* _scratch;
}
-(id)init;
-(void)dealloc;
-(id)triangulateIndicesForPoints:(PointsStruct*)points pointCount:(int)count ;
-(char)_triangulateIndicesInto:(id)arg1 ;
@end

// %hook VKTriangulator

// - (id)triangulateIndicesForPoints:(PointsStruct *)points pointCount:(int)pointCount {
//     NSLog(@"1");
//     if (pointCount < 1) {
//         return nil;
//     }
//     NSLog(@"2");

//     // 1. Ensure the internal buffer (segments) is large enough
//     if (self->_segments_capacity < pointCount) {
//         unsigned int newCapacity = self->_segments_capacity;
//         NSLog(@"3");
        
//         // Geometric growth: double the capacity until it fits the pointCount
//         while (newCapacity < pointCount) {
//             NSLog(@"4");
//             if (newCapacity == 0) {
//                 NSLog(@"5");
//                 newCapacity = pointCount; // Initial allocation
//             } else {
//                 NSLog(@"6");
//                 newCapacity *= 2; 
//             }
//         }
//         NSLog(@"7");
//         self->_segments_capacity = newCapacity;
//                 NSLog(@"8");

//         // Free old buffer if it exists
//         if (self->_opaque_segments) {
//                 NSLog(@"9");

//             malloc_zone_t *zone = _vk_malloc_zone();
//                 NSLog(@"10");

//             malloc_zone_free(zone, self->_opaque_segments);
//         }

//                 NSLog(@"11");

//         // Allocate new buffer (12 bytes per segment/point)
//         malloc_zone_t *zone = _vk_malloc_zone();
//                 NSLog(@"12");
//         self->_opaque_segments = malloc_zone_malloc(zone, 12 * self->_segments_capacity);
//                 NSLog(@"13");
        
//         if (!self->_opaque_segments) {
//                 NSLog(@"14");
//             self->_segments_capacity = 0;
//             return nil;
//         }
//     }

//                 NSLog(@"15");


//     // 2. Copy input points into the internal opaque_segments buffer
//     // Each segment entry is 12 bytes: [int x, int y, int z/flag]
//     for (int i = 0; i < pointCount; i++) {
//         NSLog(@"16");
//         struct { int x; int y; int extra; } *segment = (void *)((char *)self->_opaque_segments + (i * 12));
//                 NSLog(@"17");
//         segment->x = points[i].x;
//                 NSLog(@"18");

//         segment->y = points[i].y;
//                 NSLog(@"19");

//         segment->extra = 0; // The disassembly shows v13[1] = 0
//                 NSLog(@"20");

//     }
//                 NSLog(@"21");


//     // 3. Call the internal C++ triangulator engine
//     // This calls a function pointer at offset +8 in the vtable of _opaque_triangulator
//     // Define the function signature: Returns void, takes (void* engine, void* segments, int count)
//     typedef void (*TriangulatorFunc)(void *, void *, int);

//                 NSLog(@"21");


//     // Get the vtable pointer (the first word of the C++ object)
//     uintptr_t *vtable = *(uintptr_t **)self->_opaque_triangulator;
//                 NSLog(@"22");

    
//     // Get the function at offset +8 (which is index 2 in a pointer array: 0, 4, 8...)
//     // Note: If '8' is a byte offset, it's index 1 on 64-bit or index 2 on 32-bit. 
//     // Assuming the disassembly showed [vtable + 8]:
//     TriangulatorFunc triangulatorFunc = (TriangulatorFunc)vtable[8 / sizeof(uintptr_t)];
//                 NSLog(@"23");


//     triangulatorFunc(self->_opaque_triangulator, self->_opaque_segments, pointCount);
//                 NSLog(@"24");


//     // 4. Reset scratch data and perform the final triangulation pass
//     [self->_scratch setLength:0];
//                 NSLog(@"25");

//     if ([self _triangulateIndicesInto:self->_scratch]) {
//                 NSLog(@"26");

//         return self->_scratch;
//     }
//                 NSLog(@"27");

//     return nil;
// }

// %end


// In an %ctor or somewhere early:
%ctor {
    _vk_malloc_zone = (vk_malloc_zone_t)MSFindSymbol(MSGetImageByName("/System/Library/PrivateFrameworks/VectorKit.framework/VectorKit"), "__vk_malloc_zone");
}