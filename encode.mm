#import <Foundation/Foundation.h>
#import "QTPNG.h"
#import "fpng.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int w = 1920;
        int h = 1080;
        int bpp = 4;
        std::vector<uint8_t> fpng_file_buf;
        unsigned char *src = new unsigned char[w*h*4];
        unsigned char *dst = new unsigned char[4096+(w+1)*h*4];
        QTPNGRecorder *recorder = new QTPNGRecorder(w,h,30,8*4,@"./test.mov");
        for(int n=0; n<30; n++) {
            unsigned int *p = (unsigned int *)src;
            unsigned int color = 0xFF000000|random()&0xFFFFFF; 
            for(int k=0; k<w*h; k++) *p++ = color;
            double then = CFAbsoluteTimeGetCurrent();
            if(fpng::fpng_encode_image_to_memory((const char *)src,w,h,4,fpng_file_buf)) {
                std::copy(fpng_file_buf.begin(),fpng_file_buf.end(),dst);
                recorder->add(dst,(unsigned int)fpng_file_buf.size());
                NSLog(@"%d, %zu, %f",n,fpng_file_buf.size(),CFAbsoluteTimeGetCurrent()-then);
            }
        }
        recorder->save();
        delete[] src;
        delete[] dst;
    }
}
