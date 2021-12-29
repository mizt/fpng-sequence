#import <Foundation/Foundation.h>
#import "QTZPNG.h"
#import "spng.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *path = @"./test.mov";
        QTPNGParser *png = new QTPNGParser(path);
        NSLog(@"%d",png->length());
        if(png->length()>0) {
            double then = CFAbsoluteTimeGetCurrent();
            NSData *data = png->get(0);
            if(data) {
                unsigned int *texture = new unsigned int[png->width()*png->height()];
                char *pngbuf = (char *)[data bytes];
                long siz_pngbuf = [data length];
                spng_ctx *ctx = spng_ctx_new(0);
                spng_set_crc_action(ctx,SPNG_CRC_USE,SPNG_CRC_USE);
                spng_set_png_buffer(ctx,pngbuf,siz_pngbuf);
                struct spng_ihdr ihdr;
                spng_get_ihdr(ctx,&ihdr);
                size_t out_size;
                spng_decoded_image_size(ctx,SPNG_FMT_RGBA8,&out_size);
                spng_decode_image(ctx,(unsigned char *)texture,out_size,SPNG_FMT_RGBA8,0);
                spng_ctx_free(ctx);
                delete[] texture;
                NSLog(@"%f",CFAbsoluteTimeGetCurrent()-then);
            }
        }
        delete png;
    }
}
