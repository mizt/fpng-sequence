### Export to `.mov` (PNG Sequence).

Encoder is dependency on [fpng](https://github.com/richgel999/fpng) (Dec 28, 2021).

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