#import <Foundation/NSTimer.h>

@interface NSTimer (Private)
@property(atomic, retain) dispatch_source_t source;
@end

