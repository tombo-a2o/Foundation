// FIX_FOR_EMSCRIPTEN:

#ifndef _SKAFNETWORK_EMSCRIPTEN_
#define _SKAFNETWORK_EMSCRIPTEN_

// Define nullable keywords
#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#define nullable
#define _Nullable
#define NS_ASSUME_NONNULL_END
#endif

// Define NS_SWIFT_NOTHROW
#ifndef NS_SWIFT_NOTHROW
#define NS_SWIFT_NOTHROW
#endif

#endif
