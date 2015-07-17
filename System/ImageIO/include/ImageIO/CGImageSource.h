#ifndef IMAGEIO_CGIMAGESOURCE
#define IMAGEIO_CGIMAGESOURCE

// https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CGImageSource/index.html

#include <CoreFoundation/CoreFoundation.h>
#include <ImageIO/CGImage.h>

enum CGImageSourceStatus {
    kCGImageStatusUnexpectedEOF = -5,
    kCGImageStatusInvalidData = -4,
    kCGImageStatusUnknownType = -3,
    kCGImageStatusReadingHeader = -2,
    kCGImageStatusIncomplete = -1,
    kCGImageStatusComplete = 0
};
typedef enum CGImageSourceStatus CGImageSourceStatus;

extern CFStringRef kCGImageSourceTypeIdentifierHint;
extern CFStringRef kCGImageSourceShouldAllowFloat;
extern CFStringRef kCGImageSourceShouldCache;
extern CFStringRef kCGImageSourceCreateThumbnailFromImageIfAbsent;
extern CFStringRef kCGImageSourceCreateThumbnailFromImageAlways;
extern CFStringRef kCGImageSourceThumbnailMaxPixelSize;
extern CFStringRef kCGImageSourceCreateThumbnailWithTransform;

struct CGImageSource {
};
typedef struct CGImageSource *CGImageSourceRef;

//CGImageSourceRef CGImageSourceCreateWithDataProvider ( CGDataProviderRef provider, CFDictionaryRef options );
CGImageSourceRef CGImageSourceCreateWithData ( CFDataRef data, CFDictionaryRef options );
CGImageSourceRef CGImageSourceCreateWithURL ( CFURLRef url, CFDictionaryRef options );

CGImageRef CGImageSourceCreateImageAtIndex ( CGImageSourceRef isrc, size_t index, CFDictionaryRef options );
//CGImageRef CGImageSourceCreateThumbnailAtIndex ( CGImageSourceRef isrc, size_t index, CFDictionaryRef options );
CGImageSourceRef CGImageSourceCreateIncremental ( CFDictionaryRef options );

void CGImageSourceUpdateData ( CGImageSourceRef isrc, CFDataRef data, bool final );
//void CGImageSourceUpdateDataProvider ( CGImageSourceRef isrc, CGDataProviderRef provider, bool final );

CFTypeID CGImageSourceGetTypeID ( void );
CFStringRef CGImageSourceGetType ( CGImageSourceRef isrc );
CFArrayRef CGImageSourceCopyTypeIdentifiers ( void );
size_t CGImageSourceGetCount ( CGImageSourceRef isrc );
CFDictionaryRef CGImageSourceCopyProperties ( CGImageSourceRef isrc, CFDictionaryRef options );
CFDictionaryRef CGImageSourceCopyPropertiesAtIndex ( CGImageSourceRef isrc, size_t index, CFDictionaryRef options );
CGImageSourceStatus CGImageSourceGetStatus ( CGImageSourceRef isrc );
CGImageSourceStatus CGImageSourceGetStatusAtIndex ( CGImageSourceRef isrc, size_t index );

#endif
