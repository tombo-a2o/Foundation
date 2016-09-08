#import <Foundation/NSRunLoop.h>

@interface NSRunLoop()
@property(nonatomic) BOOL infiniteLoopEmulation;
@end

@interface NSRunLoopInfiniteRunLoopExitException : NSException
@end
