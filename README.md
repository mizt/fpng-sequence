### Export to `.mov` (PNG Sequence).

Encoder is dependency on [fpng](https://github.com/richgel999/fpng) (Dec 28, 2021).

```
inline unsigned char predictor(unsigned char a, unsigned char b, unsigned char c) {
    int p = a+b-c;
    int pa = abs(p-a);
    int pb = abs(p-b);
    int pc = abs(p-c);
    return (pa<=pb&&pa<=pc)?a:((pb<=pc)?b:c);
}

void apply_filter(int tid, uint8_t *pDst, uint8_t *pSrc, int w, int begin, int end, uint32_t ch) {

    unsigned char _blank[4] = {0,0,0,0};
    unsigned char *_filters[5] = {nullptr,nullptr,nullptr,nullptr,nullptr};

    for(int f=1; f<5; f++) {
        if(_filters[f]==nullptr) {
            _filters[f] = new unsigned char[w*ch];
        }
    }

    unsigned int src_row = w*ch;
    unsigned int dst_row = w*ch+1;

    for(int i=begin; i<end; i++) {

        unsigned char *src = pSrc+i*src_row;
        unsigned char *dst = pDst+i*dst_row+1;

        for(int j=0; j<w; j++) {
            unsigned char *W = (j==0)?_blank:src-ch;
            unsigned char *N = (i==0)?_blank:src-src_row;;
            unsigned char *NW = (i==0||j==0)?_blank:src-src_row-ch;
            for(int n=0; n<ch; n++) {
                _filters[1][j*ch+n] = (*src-*W)&0xFF;
                _filters[2][j*ch+n] = (*src-*N)&0xFF;
                _filters[3][j*ch+n] = (*src-((*W+*N)>>1))&0xFF;
                _filters[4][j*ch+n] = (*src-predictor(*W,*N,*NW))&0xFF;
                src++;
                W++;
                N++;
                NW++;
            }
        }

        const int INDEX = 0, VALUE = 1;
        int best_filter[2] = { 1, 0x7FFFFFFF };
        for(int f=1; f<5; f++) {
            for(int n=0; n<ch; n++) {
                int est = 0;
                for(int j=0; j<w; j++) {
                    est+=abs((char)_filters[f][j*ch+n]);
                }
                if(est<best_filter[VALUE]) {
                    best_filter[INDEX] = f;
                    best_filter[VALUE] = est;
                }
            }
        }

        int type = best_filter[INDEX];
        for(int j=0; j<w; j++) {
            for(int n=0; n<ch; n++) {
                *dst++ = _filters[type][j*ch+n];
            }
        }
        pDst[i*dst_row] = type;
    }

    for(int f=1; f<5; f++) {
        if(_filters[f]) {
            delete[] _filters[f];
        }
    }
}
```

### Import from `.mov` (PNG Sequence).

Decoder is dependency on [spng](https://github.com/randy408/libspng) (v0.7.1).

```
xcodebuild -project ./spng.xcodeproj -scheme spng -sdk macosx -SKIP_INSTALL=NO
xcodebuild -project ./spng.xcodeproj -scheme spng -sdk iphoneos -SKIP_INSTALL=NO
xcodebuild -project ./spng.xcodeproj -scheme spng -sdk iphonesimulator -SKIP_INSTALL=NO

cp ./build/Release/libspng.a ./libspng.xcframework/macos-arm64/libspng.a
cp ./build/Release-iphoneos/libspng.a ./libspng.xcframework/ios-arm64/libspng.a
cp ./build/Release-iphonesimulator/libspng.a ./libspng.xcframework/ios-arm64-simulator/libspng.a
```