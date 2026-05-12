// // #import <Foundation/Foundation.h>

// // %hook VKVectorTile

// // // probably?
// // typedef struct GEOPolygon
// // {
// //   uint32_t type;
// //   uint32_t attributeIndex;
// //   uint32_t styleID;
// //   uint32_t flags;
// //   float bounds[4];
// //   uint32_t vertexOffset;
// //   uint32_t vertexCount;
// //   uint32_t ringCount;
// //   uint32_t ringOffsets[4];
// //   uint32_t elevationData;
// //   uint32_t labelPositionIndex;
// //   uint32_t textureInfo;
// //   uint32_t reserved[7];
// //   uint32_t hasValidGeometry;
// //   uint32_t characteristicPointsOffset;
// //   uint32_t lodInfo;
// //   float centroid[2];
// //   float area;
// //   uint32_t neighborInfo[2];
// //   uint32_t timestamp;
// //   uint32_t reserved2[3];
// // } GEOPolygon;


// @interface GEOVectorTile : NSObject 
//     -(unsigned)polygonsCount;
//     -(GEOPolygon*)polygons;
// @end

// // // https://developer.limneos.net/index.php?ios=6.0&framework=VectorKit.framework&header=VKVectorTile.h
// // @interface VKVectorTile : NSObject  { // actually VKTile instead of NSObject

// // 	GEOVectorTile* _modelTile;
// // 	id _trafficTile; // VKTraffic 
// // 	NSMutableArray* _roadGroups;
// // 	NSMutableArray* _polygonGroups;
// // 	NSMutableArray* _coastlineGroups;
// // 	char _shouldBlend;
// // 	float _alpha;
// // 	id _buildingFootprintMaker; // VKBuildingFootprintMaker
// // 	float _maximumStyleZ;
// // 	float _textureScale;
// // 	id _stylesheet; // VKStylesheet
// // 	int _vectorType;
// // 	id _fragments; // VKMapTileList
// // }

// // -(int)vectorType;
// // @end

// // @interface VKPolygon : NSObject
// // - (id)featureId;
// // - (NSUInteger)sectionCount;
// // - (const void *)pointsForSection:(NSUInteger)section pointCount:(NSUInteger *)pointCount;
// // - (id)attributes;
// // @end


// // // https://developer.limneos.net/index.php?ios=6.0&framework=VectorKit.framework&header=VKStyleResolutionSession.h
// // @interface VKStyleResolutionSession : NSObject
// // -(id)initWithStylesheet:(id)arg1 vectorType:(int)arg2 ;
// // -(id)evaluateFeature:(GEOPolygon*)arg1 createNewGroup:(/*^block*/id)arg2 appendToGroup:(/*^block*/id)arg3 ;
// // @end

// // @interface VKTriangulator : NSObject {

// // 	void* _opaque_triangulator;
// // 	unsigned long _segments_capacity;
// // 	void* _opaque_segments;
// // 	unsigned long _mesh_capacity;
// // 	unsigned* _mesh;
// // 	NSMutableData* _scratch;
// // }
// // -(id)init;
// // -(void)dealloc;
// // // -(id)triangulateIndicesForPoints:(SCD_Struct_VK90*)arg1 pointCount:(int)arg2 ;
// // -(char)_triangulateIndicesInto:(id)arg1 ;
// // @end

// // @interface VKPolygonGroup : NSObject
// // - (id)initWithStyle:(id)arg1 tile:(id)arg2 attributes:(id)arg3 ;
// // - (void)freeze;
// // - (id)strokeMesh;
// // @end

// // @interface VKMesh : NSObject
// // - (void)freeze;
// // @end

// // struct GEOMultiSectionFeature
// // {
// //   uint8_t gap0[28];
// //   int64_t int641C;
// //   uint8_t gap24[28];
// //   uint32_t _sectionCount;
// // };

// // @interface VKPolygonDrawStyle : NSObject {

// // 	// VKProfileSparseRamp<signed char> visibility;
// // 	// VKProfileSparseRamp<_VGLColor>* fillColor;
// // 	// VKProfileSparseRamp<float>* strokeWidth;
// // 	// VKProfileSparseRamp<_VGLColor>* strokeColor;
// // 	// VKProfileSparseRamp<float>* outerStrokeWidth;
// // 	// VKProfileSparseRamp<_VGLColor>* outerStrokeColor;
// // 	// VKProfileSparseRamp<int>* zIndices;
// // 	int polygonType;
// // 	NSMutableArray* textures;
// // 	// VKProfileSparseRamp<float>* textureOpacity;
// // 	int textureBlendMode;
// // 	NSMutableArray* secondTextures;
// // 	// VKProfileSparseRamp<float>* secondTextureOpacity;
// // 	int secondTextureBlendMode;
// // 	NSMutableArray* thirdTextures;
// // 	// VKProfileSparseRamp<float>* thirdTextureOpacity;
// // 	int thirdTextureBlendMode;
// // 	// VKProfileSparseRamp<signed char> casingsVisible;
// // 	// VKProfileSparseRamp<signed char> fancyCasingsVisible;
// // 	NSString* descriptionKey;
// // 	unsigned hasFillColor : 1;
// // 	unsigned hasFillTexture : 1;
// // 	unsigned hasStrokeColor : 1;
// // 	NSString* _name;
// // }
// // @property (nonatomic,retain) NSString * name;              //@synthesize name=_name - In the implementation block
// // -(id)init;
// // -(void)dealloc;
// // -(NSString *)name;
// // -(void)setName:(NSString *)arg1 ;
// // -(char)hasFillColor;
// // -(char)hasFillTexture;
// // -(int)polygonType;
// // -(void)takeFromStyleProperties:(id)arg1 atZoom:(unsigned)arg2 ;
// // -(void)takeFromZoomInvariantProperties:(id)arg1 ;
// // -(char)visibleAtZoom:(float)arg1 ;
// // -(char)isNotDrawn;
// // // -(VGLColor)fillColorAtZoom:(float)arg1 ;
// // -(id)textureAtZoom:(float)arg1 ;
// // -(float)textureOpacityAtZoom:(float)arg1 ;
// // -(int)textureBlendMode;
// // -(id)secondTextureAtZoom:(float)arg1 ;
// // -(float)secondTextureOpacityAtZoom:(float)arg1 ;
// // -(int)secondTextureBlendMode;
// // -(id)thirdTextureAtZoom:(float)arg1 ;
// // -(float)thirdTextureOpacityAtZoom:(float)arg1 ;
// // -(int)thirdTextureBlendMode;
// // -(unsigned)zIndexAtZoom:(float)arg1 ;
// // -(float)strokeWidthAtZoom:(float)arg1 ;
// // // -(VGLColor)strokeColorAtZoom:(float)arg1 ;
// // -(float)outerStrokeWidthAtZoom:(float)arg1 ;
// // // -(VGLColor)outerStrokeColorAtZoom:(float)arg1 ;
// // -(char)casingsVisibleAtZoom:(float)arg1 ;
// // -(char)fancyCasingsVisibleAtZoom:(float)arg1 ;
// // -(id)descriptionAtZoom:(float)arg1 ;
// // @end

// // // a2 is probably  , but that doesnt exist in IDA! yay
// // void addPolygonToMesh(VKPolygonGroup *group,
// //         GEOMultiSectionFeature *multiSectionFeature,
// //         VKTileKey *tileKey,
// //         unsigned int polyIndex,
// //         unsigned int polyCount,
// //         char a6,
// //         VKTriangulator *triangulator) {

// //     NSLog(@"a");
// //     // VGLCenterLineMesh *strokeMesh = [group strokeMesh];
// //     // int unkCount = *(_DWORD *)(a2 + 0x40);
// //     // if (unkCount) {

// //     // }
// // }

// // - (void)buildPolygons {
// //     GEOVectorTile *modelTile = [self valueForKey:@"_modelTile"];


// //     unsigned int polygonCount = [modelTile polygonsCount];
// //     if (polygonCount) {
// //         // VKStyleResolutionSession *styleResSession = [[VKStyleResolutionSession alloc] initWithStylesheet:[self valueForKey:@"_stylesheet"] vectorType:[self vectorType]];
// //         Class VKStyleResolutionSessionClass = NSClassFromString(@"VKStyleResolutionSession");
// //         if (!VKStyleResolutionSessionClass) {
// //             // Class missing on this OS/arch; skip gracefully (fuck)
// //             return;
// //         }
// //         id styleResSession = ((id (*)(id, SEL))objc_msgSend)(VKStyleResolutionSessionClass, @selector(alloc));
// //         styleResSession = ((id (*)(id, SEL, id, int))objc_msgSend)(
// //             styleResSession,
// //             @selector(initWithStylesheet:vectorType:),
// //             [self valueForKey:@"_stylesheet"],
// //             [self vectorType]
// //         );

// //         [self setValue:[[NSMutableArray alloc] initWithCapacity:polygonCount] forKey:@"_polygonGroups"];
// //         VKTriangulator *triangulator = [[VKTriangulator alloc] init];
// //         GEOPolygon *geoPolygons = [modelTile polygons];
// //         const size_t kPolygonStride = 124;

// //         for (unsigned int i = 0; i < polygonCount; i++) {
// //             uint32_t *labelIndexPtr = (uint32_t *)((char *)&geoPolygons->labelPositionIndex + i * kPolygonStride);
// //             if (!*labelIndexPtr) continue;

// //             GEOPolygon *poly = (GEOPolygon *)((char *)geoPolygons + i * kPolygonStride);

// //             id (^createNewGroup)(id) = ^id(id group) {
// //                 // not horrible version
// //                 // id (^createNewGroup)(id) = ^id(id group) {
// //                 //     VKPolygonDrawStyle *drawStyle = [(VKStyle *)group polygonStyle];
// //                 //     if ([drawStyle isNotDrawn]) {
// //                 //         return nil;
// //                 //     } else {
// //                 //         VKPolygonGroup *newPoly = [[VKPolygonGroup alloc] initWithStyle:group tile:self];
// //                 //         [[self valueForKey:@"_polygonGroups"] addObject:newPoly];
// //                 //         return newPoly;
// //                 //     }
// //                 // };
// //                 VKPolygonDrawStyle *drawStyle =
// //                     ((VKPolygonDrawStyle* (*)(id, SEL))objc_msgSend)(group, @selector(polygonStyle));
// //                     NSLog(@"reee b");
// //                 if ([drawStyle isNotDrawn]) {
// //                     return nil;
// //                 } else {
// //                     Class VKPolygonGroupClass = NSClassFromString(@"VKPolygonGroup");
// //                     if (!VKPolygonGroupClass ||
// //                         ![VKPolygonGroupClass instancesRespondToSelector:@selector(initWithStyle:tile:)]) {
// //                         return nil;
// //                     }
// //                     id allocObj = ((id (*)(id, SEL))objc_msgSend)(VKPolygonGroupClass, @selector(alloc));
// //                     id newPoly = ((id (*)(id, SEL, id, id))objc_msgSend)(allocObj, @selector(initWithStyle:tile:), group, self);
// //                     [[self valueForKey:@"_polygonGroups"] addObject:newPoly];
// //                     NSLog(@"reee a");
// //                     return newPoly;
// //                 }
// //             };

// //         void (^appendToGroup)(VKPolygonGroup *, GEOMultiSectionFeature *) =
// //             ^(VKPolygonGroup *group, GEOMultiSectionFeature *feature) {
// //                 if (feature == (id)[NSNull null])
// //                     return;

// //                 VKTileKey *tileKey = [self valueForKey:@"_tileKey"];
// //                 uint32_t flags = [[self valueForKey:@"_flags"] unsignedIntValue];
// //                 uint32_t layerIndex = [[self valueForKey:@"_layerIndex"] unsignedIntValue];

// //                 // This matches the decompiled _addPolygonToMesh call
// //                 _addPolygonToMesh(
// //                     group,
// //                     feature,
// //                     tileKey,
// //                     flags,
// //                     layerIndex,
// //                     *((uint8_t *)triangulator->_opaque_triangulator + 16),
// //                     triangulator);
// //             };

// //             // [styleResSession evaluateFeature:poly createNewGroup:createNewGroup appendToGroup:appendToGroup];
// //             ((id (*)(id, SEL, GEOPolygon*, id, id))objc_msgSend)(
// //                 styleResSession,
// //                 @selector(evaluateFeature:createNewGroup:appendToGroup:),
// //                 poly,
// //                 createNewGroup,
// //                 appendToGroup
// //             );
// //         }
// //         NSLog(@"passed 1");
// //         for (VKPolygonGroup *polygonGroup in [self valueForKey:@"_polygonGroups"]) {
// //             NSLog(@"class = %@", [polygonGroup class]);
// //             NSLog(@"passed 2");
// //             [polygonGroup freeze];
// //             NSLog(@"passed 3");
// //             VKMesh *meshStroke = [polygonGroup strokeMesh];
// //             NSLog(@"passed 4");
// //             [meshStroke freeze];
// //             NSLog(@"passed 5");
// //         }
// //     }
    
// // }

// // %end

// #import <Foundation/Foundation.h>
// #import <objc/runtime.h>
// // Based on the decompile:
// // a1 = Feature ID (id)
// // a2 = Section Index (unsigned int)
// // a3 = Pointer to where the count will be stored (_DWORD *)
// // Returns: Pointer to the first point (float *)

// // extern "C" float * GEOMultiSectionFeaturePoints(id feature, unsigned int sectionIndex, unsigned int *pointCountOut);

// // %hookf(float *, GEOMultiSectionFeaturePoints, id feature, unsigned int sectionIndex, unsigned int *pointCountOut) {
  
// // }

// // %ctor {
// //   %init(GEOMultiSectionFeaturePoints=MSFindSymbol(NULL, "_GEOMultiSectionFeaturePoints"));
// // }

// // @interface VKTriangulator : NSObject {
// // @public
// //     void *_opaque_triangulator; 
// // }
// // @end

// // %hook VKTriangulator

// // - (BOOL)_triangulateIndicesInto:(id)arg1 {
// //     return %orig;
// // }

// // %end


// typedef struct VKTileKey {
// 	unsigned z;
// 	int x;
// 	int y;
// 	unsigned pointSize;
// } VKTileKey;

typedef struct PointsStruct {
	unsigned x;
	unsigned y;
} PointsStruct;


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
%hook VKTriangulator

- (NSMutableData*)triangulateIndicesForPoints:(PointsStruct *)points pointCount:(int)pointCount {
    const unsigned char bytes[] = {0x00};
    NSMutableData *data = [[NSData dataWithBytes:bytes length:sizeof(bytes)] mutableCopy];


    return data;

    // if (pointCount < 3) return %orig;

    // // First pass: Remove consecutive duplicates
    // PointsStruct *tempPoints = (PointsStruct *)malloc(sizeof(PointsStruct) * pointCount);
    // int tempCount = 0;
    // for (int i = 0; i < pointCount; i++) {
    //     if (tempCount > 0 && points[i].x == tempPoints[tempCount-1].x && points[i].y == tempPoints[tempCount-1].y) {
    //         continue;
    //     }
    //     tempPoints[tempCount++] = points[i];    
    // }

    // // Second pass: Remove 180-degree backtracks (including the wrap-around)
    // PointsStruct *newPoints = (PointsStruct *)malloc(sizeof(PointsStruct) * tempCount);
    // int newCount = 0;

    // for (int i = 0; i < tempCount; i++) {
    //     PointsStruct pCurrent = tempPoints[i];
        
    //     // Determine A and B. For i=0, pA is the second-to-last, pB is the last.
    //     PointsStruct pB = (i == 0) ? tempPoints[tempCount - 1] : tempPoints[i - 1];
    //     PointsStruct pA;
    //     if (i == 0) {
    //         pA = tempPoints[tempCount - 2];
    //     } else if (i == 1) {
    //         pA = tempPoints[tempCount - 1];
    //     } else {
    //         pA = tempPoints[i - 2];
    //     }

    //     double v1x = (double)pB.x - pA.x;
    //     double v1y = (double)pB.y - pA.y;
    //     double v2x = (double)pCurrent.x - pB.x;
    //     double v2y = (double)pCurrent.y - pB.y;

    //     double mag1 = sqrt(v1x*v1x + v1y*v1y);
    //     double mag2 = sqrt(v2x*v2x + v2y*v2y);

    //     if (mag1 > 0 && mag2 > 0) {
    //         double dot = (v1x * v2x + v1y * v2y) / (mag1 * mag2);
            
    //         // If it's a backtrack, we "skip" the middle point (pB).
    //         // If i == 0, that means the very last point in the array was the 'tip' of a spike
    //         // and should be ignored.
    //         if (dot < -0.99) {
    //             if (i == 0) {
    //                 // The spike tip was the last point of the array, so we just don't 
    //                 // count the last point when we eventually call %orig.
    //                 tempCount--; 
    //                 // Re-evaluate current point with new neighbors
    //                 i--; 
    //                 // kill_this_man = true;
    //                 continue;
    //             } else {
    //                 // Standard case: remove the previous point
    //                 newCount--;
    //             }
    //         }
    //     }
    //     newPoints[newCount++] = pCurrent;
    // }

    // NSMutableData *orig = %orig(newPoints, newCount);

    // if (tempPoints) free(tempPoints);
    // if (newPoints) free(newPoints);
   
    // if (!orig) {
    //     // Log the failure...
    //     NSLog(@"FAILURE");
        
    // } else {
    //     return orig;
    // }

    // if (kill_this_man) {
            int id = arc4random_uniform(99);
            if (pointCount > 0 && points != NULL) {
                NSMutableString *pointsLog = [NSMutableString stringWithString:@""];
                
                for (int i = 0; i < pointCount; i++) {
                    // Append each X,Y pair to the string
                    [pointsLog appendFormat:@"(%d, %d)%s", 
                        points[i].x, 
                        points[i].y, 
                        (i == pointCount - 1) ? "" : ", "];
                }
                
                // NSMutableString *pointsLog2 = [NSMutableString stringWithString:@""];
                
                // for (int i = 0; i < pointCount; i++) {
                //     // Append each X,Y pair to the string
                //     [pointsLog2 appendFormat:@"(%d, %d)%s", 
                //         newPoints[i].x, 
                //         newPoints[i].y, 
                //         (i == pointCount - 1) ? "" : ", "];
                // }
                
                // Log the points so you can see them over SSH (socat or tail -f /var/log/syslog)
                NSLog(@"id -> %i, original -> %@", id, pointsLog);
            }
    // }

    return %orig;
}

%end


@interface VGLVertexArrayObject : NSObject <NSCoding> {

	unsigned _VAO;
	unsigned _VBO;
	unsigned _EBO[2];
	int _stride;
	id _attributes;
    @public 
	int _vertexCount;
    @public
	int _indexCount[2];
	int _vertexPrimitiveType[2];
	unsigned _indexBufferMode;
	unsigned _bindedIndexBuffer;
	unsigned _indicesDirty : 1;
	unsigned _verticesDirty : 1;
	unsigned _vertexUsage : 2;
	unsigned _indexUsage : 2;
	unsigned _attributeCount : 8;
	// EAGLContext* _context;
	// vector<unsigned char, vk_allocator<unsigned char> > _vertices;
	// vector<unsigned short, vk_allocator<unsigned short> >* _indices[2];
}
@end
%hook VGLVertexArrayObject

- (unsigned short*)reserveIndices:(int)requestedCount {
    // 1. Access private internal state
    unsigned int mode = MSHookIvar<unsigned int>(self, "_indexBufferMode");
    int *indexCounts = MSHookIvar<int[2]>(self, "_indexCount");
    
    int currentCount = indexCounts[mode];
    
    // 2. Define the absolute hardware limit for 16-bit indices
    // 0xFFFF is 65535. We use 0x10000 (65536) as the boundary check.
    const unsigned int MAX_16BIT_INDICES = 0x10000;

    if ((unsigned int)(currentCount + requestedCount) <= MAX_16BIT_INDICES) {
        // We can't easily call std::vector::resize() from a tweak without 
        // complex header imports, so we call %orig to let the system 
        // handle the memory allocation and vector logic.
        return %orig;
    } else {
        // 3. Handle the Overflow Case
        // If we hit this, the map tile is simply too complex for 16-bit rendering.
            // NSLog(@"[MapsX] CRITICAL: Index bbuffer overflow prevented. Requested: %d, Capacity left: %d", 
            //   requestedCount, (MAX_16BIT_INDICES - currentCount));
              
        return NULL; // This will trigger the "Can't render polygon" log you saw earlier.
    }
}

%end

// %hookf(void, addPolygonToMesh, id polygonGroup, id feature, const void* tileKey, unsigned int polygonStart, unsigned int polygonEnd, signed char shouldStroke, id triangulator) {
    
//     NSLog(@"[VectorKitHook] addPolygonToMesh called - Forcing stroke to NO");

//     %orig(polygonGroup, feature, tileKey, polygonStart, polygonEnd, 0, triangulator);
// }

// %ctor {
//   %init(addPolygonToMesh=MSFindSymbol(MSGetImageByName("/System/Library/PrivateFrameworks/VectorKit.framework/VectorKit"), "__ZL17_addPolygonToMeshP14VKPolygonGroupP22GEOMultiSectionFeaturePK9VKTileKeyjjaP14VKTriangulator"));
// }


// // typedef struct Chapter
// // {
// //     char padding[20];
// // } Chapter;

// // %hook GEOVTile

// // -(void)addPoint:(id)point {
// //     return;
// // }

// // %end



// // %hook GEOVectorTile

// // -(BOOL)_readPolygons:(Chapter)polygon ofType:(int)type {
// //     return 0;
// // }
// // %end

#import <substrate.h>

// hate.
// %hookf would just segfault the app. idk why.
typedef void (*_addPolygonToMesh_t)(void* polygonGroup, void* feature, const void* tileKey, unsigned int start, unsigned int end, signed char stroke, void* triangulator);
static _addPolygonToMesh_t orig_addPolygonToMesh;

void replaced_addPolygonToMesh(void* polygonGroup, void* feature, const void* tileKey, unsigned int start, unsigned int end, signed char stroke, void* triangulator) {
    
    NSLog(@"uwu :3");
    NSLog(@"start -> %i end -> %i", start, end);
    if (orig_addPolygonToMesh) {
        orig_addPolygonToMesh(polygonGroup, feature, tileKey, start, end, 1, triangulator);
    }
}


// typedef struct {
//     int x;
//     int y;
// } IntPoint;

// // Pointer to the original function
// uintptr_t (*orig_GEOMultiSectionFeaturePoints)(void* feature, unsigned int sectionIdx, unsigned int *outCount);

// uintptr_t hooked_GEOMultiSectionFeaturePoints(void* feature, unsigned int sectionIdx, unsigned int *outCount) {
//     // 1. Get the base address as a pointer-sized integer
//     uintptr_t baseAddress = orig_GEOMultiSectionFeaturePoints(feature, sectionIdx, outCount);
    
//     if (baseAddress != 0 && outCount != nullptr && *outCount > 0) {
//         // 2. Cast directly from uintptr_t to your struct pointer
//         IntPoint *points = (IntPoint *)baseAddress;
//         unsigned int count = *outCount;

//         for (unsigned int i = 0; i < count; i++) {
//             // Modify coordinates here
//             points[i].x += 2000; 
//         }
//     }

//     return baseAddress;
// }


#include <substrate.h>
#include <sys/mman.h>


// The vertex pool descriptor we identified
struct vertexPoolDescriptor {
    void *data;
    unsigned int count;
    void *range;
    unsigned int stride;
};

struct GEOMultiSectionFeature
{
  GEOVectorTile *baseObject;
  uint8_t pad_4[24];
  uint64_t featureId;
  uint8_t pad_36[20];
  uint32_t roadType;
  uint32_t sectionBaseIndex;
  uint32_t sectionCount;
  uint8_t pad_68[8];
  uint32_t junctionBase;
  uint32_t junctionCount;
  float minX;
  float maxX;
  float minY;
  float maxY;
};



// #import <GeoServices/GeoServices-Structs.h>
// @class NSMutableData, NSData, NSMutableArray;

// @interface GEOVectorTile : NSObject {

// 	GEOTileKey _key;
// 	SCD_Struct_GE64* _lines;
// 	unsigned _linesCount;
// 	unsigned _linesVertexCount;
// 	/*function pointer*/void** _namedRoads;
// 	unsigned _namedRoadsCount;
// 	unsigned _namedRoadsVertexCount;
// 	/*function pointer*/void** _namedPoints;
// 	unsigned _namedPointsCount;
// 	/*function pointer*/void** _namedPolygons;
// 	unsigned _namedPolygonsCount;
// 	SCD_Struct_GE64* _coastlines;
// 	unsigned _coastlinesCount;
// 	SCD_Struct_GE66* _polygons;
// 	unsigned _polygonsCount;
// 	unsigned _polygonsVertexCount;
// 	SCD_Struct_GE65* _polygonLabelPositions;
// 	unsigned _polygonLabelPositionsCount;
// 	SCD_Struct_GE67* _buildingFootprints;
// 	NSMutableData* _extrusionHeightsPool;
// 	unsigned _buildingFootprintsCount;
// 	SCD_Struct_GE68* _threeDBuildings;
// 	unsigned _threeDBuildingsCount;
// 	SCD_Struct_GE69* _pois;
// 	unsigned _poisCount;
// 	SCD_Struct_GE70* _overpasses;
// 	SCD_Struct_GE71* _junctions;
// 	unsigned _junctionsCount;
// 	char _hasComputedJunctions;
// 	SCD_Struct_GE72* _laneConnections;
// 	unsigned _laneConnectionsCount;
// 	SCD_Struct_GE72* _pointsOnRoad;
// 	unsigned _pointsOnRoadCount;
// 	/*function pointer*/void** _sortedPointsOnRoad;
// 	SCD_Struct_GE73* _laneGeometry;
// 	SCD_Struct_GE74* _curveLineVertices;
// 	unsigned* _curveToLineMapping;
// 	SCD_Struct_GE74* _lineVertices;
// 	SCD_Struct_GE74* _polygonVertices;
// 	SCD_Struct_GE74* _coastlineVertices;
// 	SCD_Struct_GE74* _footprintVertices;
// 	NSData* _labelPool;
// 	SCD_Struct_GE75* _labelPoolLanguages;
// 	unsigned _labelPoolLanguagesLength;
// 	NSMutableData* _localizedLabelPool;
// 	char* _localizedLabelsLanguage;
// 	SCD_Struct_GE76* _labelIndex;
// 	unsigned _labelIndexCount;
// 	GEOFeatureShield* _shieldIndex;
// 	unsigned _shieldIndexCount;
// 	SCD_Struct_GE77* _localizationTable;
// 	unsigned _localizationTableCount;
// 	NSMutableArray* _uniqueAttributes;
// 	SCD_Struct_GE80* _lineCharacteristicPoints;
// 	unsigned _lineCharacteristicPointCount;
// 	SCD_Struct_GE80* _polygonCharacteristicPoints;
// 	unsigned _polygonCharacteristicPointCount;
// 	SCD_Struct_GE80* _coastlineCharacteristicPoints;
// 	unsigned _coastlineCharacteristicPointCount;
// }
// @property (nonatomic,readonly) SCD_Struct_GE64* lines;                                      //@synthesize lines=_lines - In the implementation block
// @property (nonatomic,readonly) unsigned linesCount;                                         //@synthesize linesCount=_linesCount - In the implementation block
// @property (nonatomic,readonly) unsigned linesVertexCount;                                   //@synthesize linesVertexCount=_linesVertexCount - In the implementation block
// @property (nonatomic,readonly) /*function pointer*/void** namedRoads;                       //@synthesize namedRoads=_namedRoads - In the implementation block
// @property (nonatomic,readonly) unsigned namedRoadsCount;                                    //@synthesize namedRoadsCount=_namedRoadsCount - In the implementation block
// @property (nonatomic,readonly) unsigned namedRoadsVertexCount; 
// @property (nonatomic,readonly) /*function pointer*/void** namedPoints;                      //@synthesize namedPoints=_namedPoints - In the implementation block
// @property (nonatomic,readonly) unsigned namedPointsCount;                                   //@synthesize namedPointsCount=_namedPointsCount - In the implementation block
// @property (nonatomic,readonly) /*function pointer*/void** namedPolygons;                    //@synthesize namedPolygons=_namedPolygons - In the implementation block
// @property (nonatomic,readonly) unsigned namedPolygonsCount;                                 //@synthesize namedPolygonsCount=_namedPolygonsCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE64* coastlines;                                 //@synthesize coastlines=_coastlines - In the implementation block
// @property (nonatomic,readonly) unsigned coastlinesCount;                                    //@synthesize coastlinesCount=_coastlinesCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE66* polygons;                                   //@synthesize polygons=_polygons - In the implementation block
// @property (nonatomic,readonly) unsigned polygonsCount;                                      //@synthesize polygonsCount=_polygonsCount - In the implementation block
// @property (nonatomic,readonly) unsigned polygonsVertexCount;                                //@synthesize polygonsVertexCount=_polygonsVertexCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE67* buildingFootprints;                         //@synthesize buildingFootprints=_buildingFootprints - In the implementation block
// @property (nonatomic,readonly) unsigned buildingFootprintsCount;                            //@synthesize buildingFootprintsCount=_buildingFootprintsCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE68* threeDBuildings;                            //@synthesize threeDBuildings=_threeDBuildings - In the implementation block
// @property (nonatomic,readonly) unsigned threeDBuildingsCount;                               //@synthesize threeDBuildingsCount=_threeDBuildingsCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE69* pois;                                       //@synthesize pois=_pois - In the implementation block
// @property (nonatomic,readonly) unsigned poisCount;                                          //@synthesize poisCount=_poisCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE70* overpasses;                                 //@synthesize overpasses=_overpasses - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE71* junctions;                                  //@synthesize junctions=_junctions - In the implementation block
// @property (nonatomic,readonly) unsigned junctionsCount;                                     //@synthesize junctionsCount=_junctionsCount - In the implementation block
// @property (nonatomic,readonly) char hasComputedJunctions;                                   //@synthesize hasComputedJunctions=_hasComputedJunctions - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE72* pointsOnRoad;                               //@synthesize pointsOnRoad=_pointsOnRoad - In the implementation block
// @property (nonatomic,readonly) unsigned pointsOnRoadCount;                                  //@synthesize pointsOnRoadCount=_pointsOnRoadCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE72* laneConnections;                            //@synthesize laneConnections=_laneConnections - In the implementation block
// @property (nonatomic,readonly) unsigned laneConnectionsCount;                               //@synthesize laneConnectionsCount=_laneConnectionsCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE80* lineCharacteristicPoints;                   //@synthesize lineCharacteristicPoints=_lineCharacteristicPoints - In the implementation block
// @property (nonatomic,readonly) unsigned lineCharacteristicPointCount;                       //@synthesize lineCharacteristicPointCount=_lineCharacteristicPointCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE80* polygonCharacteristicPoints;                //@synthesize polygonCharacteristicPoints=_polygonCharacteristicPoints - In the implementation block
// @property (nonatomic,readonly) unsigned polygonCharacteristicPointCount;                    //@synthesize polygonCharacteristicPointCount=_polygonCharacteristicPointCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE80* coastlineCharacteristicPoints;              //@synthesize coastlineCharacteristicPoints=_coastlineCharacteristicPoints - In the implementation block
// @property (nonatomic,readonly) unsigned coastlineCharacteristicPointCount;                  //@synthesize coastlineCharacteristicPointCount=_coastlineCharacteristicPointCount - In the implementation block
// @property (nonatomic,readonly) SCD_Struct_GE74* curveLineVertices; 
// @property (nonatomic,readonly) SCD_Struct_GE74* lineVertices; 
// @property (nonatomic,readonly) GEOTileKey tileKey;                                          //@synthesize key=_key - In the implementation block
// @property (nonatomic,readonly) char dataIncludesConnectivity; 
// -(SCD_Struct_GE64*)lines;
// -(id)_initWithVMP3:(id)arg1 localizationData:(id)arg2 tileKey:(const GEOTileKey*)arg3 ;
// -(id)_initWithVMP4:(id)arg1 localizationData:(id)arg2 tileKey:(const GEOTileKey*)arg3 ;
// -(void)_sortStyleAttributes;
// -(void)_attachRoadPoints;
// -(void)_buildSortedFeatureLists;
// -(void)_findJunctions;
// -(void)_findOverpasses;
// -(void)_trimWhitespace;
// -(SCD_Struct_GE74*)curveLineVertices;
// -(id)extrusionHeightsPool;
// -(SCD_Struct_GE65*)polygonLabelPositions;
// -(void)forEachJunctionInRoad:(SCD_Struct_GE64*)arg1 visitor:(/*^block*/id)arg2 ;
// -(char)hasComputedJunctions;
// -(unsigned)pointsOnRoadCount;
// -(SCD_Struct_GE72*)laneConnections;
// -(unsigned)laneConnectionsCount;
// -(SCD_Struct_GE80*)lineCharacteristicPoints;
// -(unsigned)lineCharacteristicPointCount;
// -(SCD_Struct_GE80*)polygonCharacteristicPoints;
// -(unsigned)polygonCharacteristicPointCount;
// -(SCD_Struct_GE80*)coastlineCharacteristicPoints;
// -(unsigned)coastlineCharacteristicPointCount;
// -(unsigned)_makeSpaceForLabels:(unsigned)arg1 ;
// -(unsigned)_makeSpaceForShields:(unsigned)arg1 ;
// -(char)_readPolygons:(SCD_Struct_GE82*)arg1 ofType:(unsigned short)arg2 ;
// -(char)_readWrappingCoastlines:(SCD_Struct_GE84*)arg1 tile:(SCD_Struct_GE82*)arg2 ;
// -(char)_readSimpleCoastlines:(SCD_Struct_GE84*)arg1 tile:(SCD_Struct_GE82*)arg2 ;
// -(char)_addGenericPolygonWithAttributes:(int*)arg1 ;
// -(char)_handleGenericTile:(SCD_Struct_GE82*)arg1 ;
// -(char)_readInfoChapter:(SCD_Struct_GE82*)arg1 ;
// -(char)_readLabels:(SCD_Struct_GE82*)arg1 ;
// -(char)_readPois:(SCD_Struct_GE82*)arg1 ;
// -(char)_readLines:(SCD_Struct_GE82*)arg1 ;
// -(char)_readPolygons:(SCD_Struct_GE82*)arg1 ;
// -(char)_readCoastlines:(SCD_Struct_GE82*)arg1 ;
// -(char)_read3DBuildings:(SCD_Struct_GE82*)arg1 ;
// -(void)dealloc;
// -(id)description;
// -(unsigned)linesCount;
// -(GEOTileKey)tileKey;
// -(unsigned)coastlinesCount;
// -(SCD_Struct_GE64*)coastlines;
// -(unsigned)polygonsCount;
// -(SCD_Struct_GE66*)polygons;
// -(unsigned)buildingFootprintsCount;
// -(SCD_Struct_GE67*)buildingFootprints;
// -(SCD_Struct_GE68*)threeDBuildings;
// -(unsigned)threeDBuildingsCount;
// -(SCD_Struct_GE71*)junctions;
// -(unsigned)junctionsCount;
// -(SCD_Struct_GE72*)pointsOnRoad;
// -(void)forEachJunction:(/*^block*/id)arg1 ;
// -(char)dataIncludesConnectivity;
// -(void)forEachEdgeInRoad:(SCD_Struct_GE64*)arg1 visitTwice:(char)arg2 visitor:(/*^block*/id)arg3 ;
// -(void)forEachRoad:(/*^block*/id)arg1 ;
// -(void)forEachEdgeOnJunction:(SCD_Struct_GE71*)arg1 visitor:(/*^block*/id)arg2 ;
// -(SCD_Struct_GE74*)lineVertices;
// -(SCD_Struct_GE69*)pois;
// -(unsigned)poisCount;
// -(/*function pointer*/void**)sortedPointsOnRoad;
// -(id)initWithTileData:(id)arg1 localizationData:(id)arg2 tileKey:(const GEOTileKey*)arg3 ;
// -(unsigned)namedRoadsCount;
// -(unsigned)namedPointsCount;
// -(unsigned)namedPolygonsCount;
// -(/*function pointer*/void**)namedRoads;
// -(/*function pointer*/void**)namedPoints;
// -(/*function pointer*/void**)namedPolygons;
// -(SCD_Struct_GE70*)overpasses;
// -(unsigned)linesVertexCount;
// -(unsigned)namedRoadsVertexCount;
// -(unsigned)polygonsVertexCount;
// @end

static vertexPoolDescriptor* (*orig_vertexPoolForFeature)(GEOMultiSectionFeature *feature);

vertexPoolDescriptor* hooked_vertexPoolForFeature(GEOMultiSectionFeature *feature) {
    NSLog(@"We successfully hooked vertexPoolForFeature!!!!");
    // 1. Get the original descriptor
    vertexPoolDescriptor *pool = orig_vertexPoolForFeature(feature);
    
    if (pool && feature && feature->baseObject) {
        GEOVectorTile *tile = feature->baseObject;
        
        // 2. Range check: Is this feature actually a Polygon?
        uintptr_t addr = (uintptr_t)feature;
        uintptr_t polyStart = (uintptr_t)tile->_polygons;
        uintptr_t polyEnd = polyStart + (tile->_polygonsCount * 124); // 124 = sizeof(GEOPolygons)

        if (addr >= polyStart && addr < polyEnd) {
            // This is a polygon! 
            
            // 3. Make memory writable (important if data is mmap'd from cache)
            // We use 4096 (page size) or a larger range based on pool->count * pool->stride
            size_t dataSize = pool->count * pool->stride;
            mprotect((void *)((uintptr_t)pool->data & ~0xFFF), (dataSize + 0xFFF) & ~0xFFF, PROT_READ | PROT_WRITE);

            // 4. Modify the points
            // Assuming the pool data is an array of 2D floats (X, Y)
            float *points = (float *)pool->data;
            
            // Example: Move all polygons in this tile up by a certain amount
            for (unsigned int i = 0; i < pool->count * 2; i += 2) {
                // points[i] is X, points[i+1] is Y
                points[i+1] += 100.0f; 
            }
        }
    }
    
    return pool;
}

%ctor {
    MSImageRef vkLib = MSGetImageByName("/System/Library/PrivateFrameworks/VectorKit.framework/VectorKit");
    MSImageRef geoLib = MSGetImageByName("/System/Library/PrivateFrameworks/GeoServices.framework/GeoServices");
    
    if (vkLib) {
        void *symbol = MSFindSymbol(vkLib, "__ZL17_addPolygonToMeshP14VKPolygonGroupP22GEOMultiSectionFeaturePK9VKTileKeyjjaP14VKTriangulator");
         
        if (symbol) {
            MSHookFunction(symbol, (void *)&replaced_addPolygonToMesh, (void **)&orig_addPolygonToMesh);
        }
    }
    if (geoLib) {
        // void *symbol2 = MSFindSymbol(geoLib, "_GEOMultiSectionFeaturePoints");
        void *symbol3 = MSFindSymbol(geoLib, "__Z22_vertexPoolForFeatureP22GEOMultiSectionFeature");


        // if (symbol2) {
        //     MSHookFunction(symbol2, (void *)&hooked_GEOMultiSectionFeaturePoints, (void **)&orig_GEOMultiSectionFeaturePoints);        
        // }
        if (symbol3) {
            MSHookFunction(symbol3, (void *)&hooked_vertexPoolForFeature, (void **)&orig_vertexPoolForFeature);
        } else {
            NSLog(@"PAINNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN");
        }
    }
}