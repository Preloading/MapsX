// #import <Foundation/Foundation.h>

// %hook VKVectorTile

// // probably?
// typedef struct GEOPolygon
// {
//   uint32_t type;
//   uint32_t attributeIndex;
//   uint32_t styleID;
//   uint32_t flags;
//   float bounds[4];
//   uint32_t vertexOffset;
//   uint32_t vertexCount;
//   uint32_t ringCount;
//   uint32_t ringOffsets[4];
//   uint32_t elevationData;
//   uint32_t labelPositionIndex;
//   uint32_t textureInfo;
//   uint32_t reserved[7];
//   uint32_t hasValidGeometry;
//   uint32_t characteristicPointsOffset;
//   uint32_t lodInfo;
//   float centroid[2];
//   float area;
//   uint32_t neighborInfo[2];
//   uint32_t timestamp;
//   uint32_t reserved2[3];
// } GEOPolygon;


// @interface GEOVectorTile : NSObject 
//     -(unsigned)polygonsCount;
//     -(GEOPolygon*)polygons;
// @end

// // https://developer.limneos.net/index.php?ios=6.0&framework=VectorKit.framework&header=VKVectorTile.h
// @interface VKVectorTile : NSObject  { // actually VKTile instead of NSObject

// 	GEOVectorTile* _modelTile;
// 	id _trafficTile; // VKTraffic 
// 	NSMutableArray* _roadGroups;
// 	NSMutableArray* _polygonGroups;
// 	NSMutableArray* _coastlineGroups;
// 	char _shouldBlend;
// 	float _alpha;
// 	id _buildingFootprintMaker; // VKBuildingFootprintMaker
// 	float _maximumStyleZ;
// 	float _textureScale;
// 	id _stylesheet; // VKStylesheet
// 	int _vectorType;
// 	id _fragments; // VKMapTileList
// }

// -(int)vectorType;
// @end

// @interface VKPolygon : NSObject
// - (id)featureId;
// - (NSUInteger)sectionCount;
// - (const void *)pointsForSection:(NSUInteger)section pointCount:(NSUInteger *)pointCount;
// - (id)attributes;
// @end


// // https://developer.limneos.net/index.php?ios=6.0&framework=VectorKit.framework&header=VKStyleResolutionSession.h
// @interface VKStyleResolutionSession : NSObject
// -(id)initWithStylesheet:(id)arg1 vectorType:(int)arg2 ;
// -(id)evaluateFeature:(GEOPolygon*)arg1 createNewGroup:(/*^block*/id)arg2 appendToGroup:(/*^block*/id)arg3 ;
// @end

// @interface VKTriangulator : NSObject {

// 	void* _opaque_triangulator;
// 	unsigned long _segments_capacity;
// 	void* _opaque_segments;
// 	unsigned long _mesh_capacity;
// 	unsigned* _mesh;
// 	NSMutableData* _scratch;
// }
// -(id)init;
// -(void)dealloc;
// // -(id)triangulateIndicesForPoints:(SCD_Struct_VK90*)arg1 pointCount:(int)arg2 ;
// -(char)_triangulateIndicesInto:(id)arg1 ;
// @end

// @interface VKPolygonGroup : NSObject
// - (id)initWithStyle:(id)arg1 tile:(id)arg2 attributes:(id)arg3 ;
// - (void)freeze;
// - (id)strokeMesh;
// @end

// @interface VKMesh : NSObject
// - (void)freeze;
// @end

// struct GEOMultiSectionFeature
// {
//   uint8_t gap0[28];
//   int64_t int641C;
//   uint8_t gap24[28];
//   uint32_t _sectionCount;
// };

// @interface VKPolygonDrawStyle : NSObject {

// 	// VKProfileSparseRamp<signed char> visibility;
// 	// VKProfileSparseRamp<_VGLColor>* fillColor;
// 	// VKProfileSparseRamp<float>* strokeWidth;
// 	// VKProfileSparseRamp<_VGLColor>* strokeColor;
// 	// VKProfileSparseRamp<float>* outerStrokeWidth;
// 	// VKProfileSparseRamp<_VGLColor>* outerStrokeColor;
// 	// VKProfileSparseRamp<int>* zIndices;
// 	int polygonType;
// 	NSMutableArray* textures;
// 	// VKProfileSparseRamp<float>* textureOpacity;
// 	int textureBlendMode;
// 	NSMutableArray* secondTextures;
// 	// VKProfileSparseRamp<float>* secondTextureOpacity;
// 	int secondTextureBlendMode;
// 	NSMutableArray* thirdTextures;
// 	// VKProfileSparseRamp<float>* thirdTextureOpacity;
// 	int thirdTextureBlendMode;
// 	// VKProfileSparseRamp<signed char> casingsVisible;
// 	// VKProfileSparseRamp<signed char> fancyCasingsVisible;
// 	NSString* descriptionKey;
// 	unsigned hasFillColor : 1;
// 	unsigned hasFillTexture : 1;
// 	unsigned hasStrokeColor : 1;
// 	NSString* _name;
// }
// @property (nonatomic,retain) NSString * name;              //@synthesize name=_name - In the implementation block
// -(id)init;
// -(void)dealloc;
// -(NSString *)name;
// -(void)setName:(NSString *)arg1 ;
// -(char)hasFillColor;
// -(char)hasFillTexture;
// -(int)polygonType;
// -(void)takeFromStyleProperties:(id)arg1 atZoom:(unsigned)arg2 ;
// -(void)takeFromZoomInvariantProperties:(id)arg1 ;
// -(char)visibleAtZoom:(float)arg1 ;
// -(char)isNotDrawn;
// // -(VGLColor)fillColorAtZoom:(float)arg1 ;
// -(id)textureAtZoom:(float)arg1 ;
// -(float)textureOpacityAtZoom:(float)arg1 ;
// -(int)textureBlendMode;
// -(id)secondTextureAtZoom:(float)arg1 ;
// -(float)secondTextureOpacityAtZoom:(float)arg1 ;
// -(int)secondTextureBlendMode;
// -(id)thirdTextureAtZoom:(float)arg1 ;
// -(float)thirdTextureOpacityAtZoom:(float)arg1 ;
// -(int)thirdTextureBlendMode;
// -(unsigned)zIndexAtZoom:(float)arg1 ;
// -(float)strokeWidthAtZoom:(float)arg1 ;
// // -(VGLColor)strokeColorAtZoom:(float)arg1 ;
// -(float)outerStrokeWidthAtZoom:(float)arg1 ;
// // -(VGLColor)outerStrokeColorAtZoom:(float)arg1 ;
// -(char)casingsVisibleAtZoom:(float)arg1 ;
// -(char)fancyCasingsVisibleAtZoom:(float)arg1 ;
// -(id)descriptionAtZoom:(float)arg1 ;
// @end

// // a2 is probably  , but that doesnt exist in IDA! yay
// void addPolygonToMesh(VKPolygonGroup *group,
//         GEOMultiSectionFeature *multiSectionFeature,
//         VKTileKey *tileKey,
//         unsigned int polyIndex,
//         unsigned int polyCount,
//         char a6,
//         VKTriangulator *triangulator) {

//     NSLog(@"a");
//     // VGLCenterLineMesh *strokeMesh = [group strokeMesh];
//     // int unkCount = *(_DWORD *)(a2 + 0x40);
//     // if (unkCount) {

//     // }
// }

// - (void)buildPolygons {
//     GEOVectorTile *modelTile = [self valueForKey:@"_modelTile"];


//     unsigned int polygonCount = [modelTile polygonsCount];
//     if (polygonCount) {
//         // VKStyleResolutionSession *styleResSession = [[VKStyleResolutionSession alloc] initWithStylesheet:[self valueForKey:@"_stylesheet"] vectorType:[self vectorType]];
//         Class VKStyleResolutionSessionClass = NSClassFromString(@"VKStyleResolutionSession");
//         if (!VKStyleResolutionSessionClass) {
//             // Class missing on this OS/arch; skip gracefully (fuck)
//             return;
//         }
//         id styleResSession = ((id (*)(id, SEL))objc_msgSend)(VKStyleResolutionSessionClass, @selector(alloc));
//         styleResSession = ((id (*)(id, SEL, id, int))objc_msgSend)(
//             styleResSession,
//             @selector(initWithStylesheet:vectorType:),
//             [self valueForKey:@"_stylesheet"],
//             [self vectorType]
//         );

//         [self setValue:[[NSMutableArray alloc] initWithCapacity:polygonCount] forKey:@"_polygonGroups"];
//         VKTriangulator *triangulator = [[VKTriangulator alloc] init];
//         GEOPolygon *geoPolygons = [modelTile polygons];
//         const size_t kPolygonStride = 124;

//         for (unsigned int i = 0; i < polygonCount; i++) {
//             uint32_t *labelIndexPtr = (uint32_t *)((char *)&geoPolygons->labelPositionIndex + i * kPolygonStride);
//             if (!*labelIndexPtr) continue;

//             GEOPolygon *poly = (GEOPolygon *)((char *)geoPolygons + i * kPolygonStride);

//             id (^createNewGroup)(id) = ^id(id group) {
//                 // not horrible version
//                 // id (^createNewGroup)(id) = ^id(id group) {
//                 //     VKPolygonDrawStyle *drawStyle = [(VKStyle *)group polygonStyle];
//                 //     if ([drawStyle isNotDrawn]) {
//                 //         return nil;
//                 //     } else {
//                 //         VKPolygonGroup *newPoly = [[VKPolygonGroup alloc] initWithStyle:group tile:self];
//                 //         [[self valueForKey:@"_polygonGroups"] addObject:newPoly];
//                 //         return newPoly;
//                 //     }
//                 // };
//                 VKPolygonDrawStyle *drawStyle =
//                     ((VKPolygonDrawStyle* (*)(id, SEL))objc_msgSend)(group, @selector(polygonStyle));
//                     NSLog(@"reee b");
//                 if ([drawStyle isNotDrawn]) {
//                     return nil;
//                 } else {
//                     Class VKPolygonGroupClass = NSClassFromString(@"VKPolygonGroup");
//                     if (!VKPolygonGroupClass ||
//                         ![VKPolygonGroupClass instancesRespondToSelector:@selector(initWithStyle:tile:)]) {
//                         return nil;
//                     }
//                     id allocObj = ((id (*)(id, SEL))objc_msgSend)(VKPolygonGroupClass, @selector(alloc));
//                     id newPoly = ((id (*)(id, SEL, id, id))objc_msgSend)(allocObj, @selector(initWithStyle:tile:), group, self);
//                     [[self valueForKey:@"_polygonGroups"] addObject:newPoly];
//                     NSLog(@"reee a");
//                     return newPoly;
//                 }
//             };

//         void (^appendToGroup)(VKPolygonGroup *, GEOMultiSectionFeature *) =
//             ^(VKPolygonGroup *group, GEOMultiSectionFeature *feature) {
//                 if (feature == (id)[NSNull null])
//                     return;

//                 VKTileKey *tileKey = [self valueForKey:@"_tileKey"];
//                 uint32_t flags = [[self valueForKey:@"_flags"] unsignedIntValue];
//                 uint32_t layerIndex = [[self valueForKey:@"_layerIndex"] unsignedIntValue];

//                 // This matches the decompiled _addPolygonToMesh call
//                 _addPolygonToMesh(
//                     group,
//                     feature,
//                     tileKey,
//                     flags,
//                     layerIndex,
//                     *((uint8_t *)triangulator->_opaque_triangulator + 16),
//                     triangulator);
//             };

//             // [styleResSession evaluateFeature:poly createNewGroup:createNewGroup appendToGroup:appendToGroup];
//             ((id (*)(id, SEL, GEOPolygon*, id, id))objc_msgSend)(
//                 styleResSession,
//                 @selector(evaluateFeature:createNewGroup:appendToGroup:),
//                 poly,
//                 createNewGroup,
//                 appendToGroup
//             );
//         }
//         NSLog(@"passed 1");
//         for (VKPolygonGroup *polygonGroup in [self valueForKey:@"_polygonGroups"]) {
//             NSLog(@"class = %@", [polygonGroup class]);
//             NSLog(@"passed 2");
//             [polygonGroup freeze];
//             NSLog(@"passed 3");
//             VKMesh *meshStroke = [polygonGroup strokeMesh];
//             NSLog(@"passed 4");
//             [meshStroke freeze];
//             NSLog(@"passed 5");
//         }
//     }
    
// }

// %end

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
// Based on the decompile:
// a1 = Feature ID (id)
// a2 = Section Index (unsigned int)
// a3 = Pointer to where the count will be stored (_DWORD *)
// Returns: Pointer to the first point (float *)

// extern "C" float * GEOMultiSectionFeaturePoints(id feature, unsigned int sectionIndex, unsigned int *pointCountOut);

// %hookf(float *, GEOMultiSectionFeaturePoints, id feature, unsigned int sectionIndex, unsigned int *pointCountOut) {
  
// }

// %ctor {
//   %init(GEOMultiSectionFeaturePoints=MSFindSymbol(NULL, "_GEOMultiSectionFeaturePoints"));
// }