#include <dlfcn.h>
#include "lib/libheif/include/libheif/heif.h"
#include <CoreGraphics/CoreGraphics.h>
#include "VGLTexture.h"

@interface VGLUncompressedTexture : VGLTexture //{

// 	CGImageRef _image;
// 	char* _imageData;
// 	unsigned _pixelFormat;
// 	unsigned _colorFormat;
// 	CGImageBlockSetRef _blockSetRef;
// 	char _fastPath;
// }
-(id)initWithData:(id)arg1 ;
-(id)initWithCGImage:(CGImageRef)arg1 ;
-(void)dealloc;
-(char)decodeTexture;
-(char)loadTexture;
// -(VGLColor)textureCoordinateRect:(CGRect)arg1 ;
@end

@interface VGLUncompressedTexture (MapsX)
-(CGImageRef)decompressImage:(NSData*)heifData;
@end

%hook VGLUncompressedTexture 

-(id)initWithData:(NSData*)data {
    NSLog(@"uncompressed text");
    // this contains compressed HEIC stuff    
    static char heicSignatureBytes[16] = {0x00, 0x00, 0x00, 0x18, 0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x63, 0x00, 0x00, 0x00, 0x00};
    NSData *heicSignature = [NSData dataWithBytes:heicSignatureBytes length:16];
    NSData *imgDataStart = [data subdataWithRange:NSMakeRange(0,16)];
    // NSLog(@"%@ vs %@", heicSignature, imgDataStart);
    if ([heicSignature isEqualToData:imgDataStart]) {
        // NSLog(@"HEIC texture detected!");

        CGImageRef decompressedImg = [self decompressImage:data];
        VGLUncompressedTexture *texture = [self initWithCGImage:decompressedImg];
        // NSLog(@"raw -> %@,\n\n\n png version -> %@", data, UIImagePNGRepresentation([UIImage imageWithCGImage:decompressedImg]));
        CGImageRelease(decompressedImg);
        return texture;
        // v5 = CGImageSourceCreateWithData(data: (CFDataRef)a3, options: nullptr);
        // v6 = v5;
        // if ( v5 == nullptr )
        //     return nullptr;
        // if ( CGImageSourceGetCount(isrc: v5) == 0 )
        //     return nullptr;
        // ImageAtIndex = CGImageSourceCreateImageAtIndex(isrc: v6, index: 0, options: nullptr);
        // if ( ImageAtIndex == nullptr )
        //     return nullptr;
        // v9 = -[VGLUncompressedTexture initWithCGImage:](a1: self, a2: , ImageAtIndex);
        // CGImageRelease(image: ImageAtIndex);
        // return v9;
    }
    // https://en.wikipedia.org/wiki/List_of_file_signatures, Apple HEIC
    // 
    // [VGLHEICTexture]
    return %orig;
}

%new
-(CGImageRef)decompressImage:(NSData*)heifData {
    const void *heifBytes = [heifData bytes];
    heif_context* ctx = heif_context_alloc();
    heif_context_read_from_memory_without_copy(ctx, heifBytes, [heifData length], nil);

    // get a handle to the primary image
    heif_image_handle* handle;
    heif_context_get_primary_image_handle(ctx, &handle);

    // decode the image and convert colorspace to RGB, saved as 24bit interleaved
    heif_image* img;
    heif_decode_image(handle, &img, heif_colorspace_RGB, heif_chroma_interleaved_RGBA, nil);

    int stride;
    const uint8_t* data = heif_image_get_plane_readonly(img, heif_channel_interleaved, &stride);

    int bpp = heif_image_get_bits_per_pixel(img, heif_channel_interleaved);
    int h = heif_image_handle_get_height(handle);
    
    // image flipping, since the image is vertically inverted to what iOS 6 expects
    void *pixelRow = malloc(sizeof(uint8_t)*stride);
    for (int i = 0; i<(h/2); i++) { // hopefully should round down
        memcpy((void*)(pixelRow),(void*)(data+i*stride), stride); // save the row
        memcpy((void*)(data+i*stride),(void*)(data+(h-i)*stride), stride);
        memcpy((void*)(data+(h-i)*stride), (void*)(pixelRow), stride);        
    }
    free(pixelRow);
    

    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, data, stride*heif_image_handle_get_height(handle), NULL); // kinda cursed
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef image = CGImageCreate(heif_image_handle_get_width(handle), // width
                                     h, // height
                                     8, // bitsPerComponent
                                     bpp, // bitsPerPixel
                                     stride, // bytesPerRow
                                     colorspace,
                                     kCGImageAlphaLast, // bitmapInfo
                                     provider,
                                     NULL, // decode
                                     true, // shouldInterpolate
                                     kCGRenderingIntentDefault // intent
                                    );
    CGColorSpaceRelease(colorspace);
    CGDataProviderRelease(provider);
    // clean up resources
    // heif_image_release(img);
    heif_image_handle_release(handle);
    heif_context_free(ctx);
    return image;
}

%end

// %ctor {
//     NSLog(@"3d mesh");
//     %init(VKA3DPopulateMesh=MSFindSymbol(NULL, "_VKA3DPopulateMesh"));
// }