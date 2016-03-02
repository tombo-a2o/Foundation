#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <assert.h>
#import "NSTimerInternal.h"

@implementation NSRunLoop

void *_NS_RUNLOOP_KEY = (void*)"NS_RUNLOOP_KEY";

+ (NSRunLoop *)currentRunLoop
{
    NSRunLoop *runLoop = dispatch_get_specific(_NS_RUNLOOP_KEY);
    if(!runLoop) {
        runLoop = [[NSRunLoop alloc] init];
        [runLoop retain]; // TODO release
        dispatch_queue_set_specific(dispatch_get_current_queue(), _NS_RUNLOOP_KEY, runLoop, NULL);
    }
    return runLoop;
}

+ (NSRunLoop *)mainRunLoop
{
    NSRunLoop *runLoop = dispatch_queue_get_specific(dispatch_get_main_queue(), _NS_RUNLOOP_KEY);
    if(!runLoop) {
        runLoop = [[NSRunLoop alloc] init];
        [runLoop retain]; // TODO release
        dispatch_queue_set_specific(dispatch_get_main_queue(), _NS_RUNLOOP_KEY, runLoop, NULL);
    }
    return runLoop;
}

- (void)dealloc
{
    [super dealloc];
}

- (CFRunLoopRef)getCFRunLoop
{
    return nil;
}

- (void)addTimer:(NSTimer *)timer forMode:(NSString *)mode
{
    dispatch_source_t source = timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_current_queue());

    NSDate *date = timer.fireDate;
    NSTimeInterval interval = timer.timeInterval;
    NSTimeInterval tolerance = timer.tolerance;

    __block NSTimer *t = [timer retain];

    dispatch_source_set_timer(source, dispatch_time(DISPATCH_TIME_NOW, date.timeIntervalSinceNow*NSEC_PER_SEC), interval*NSEC_PER_SEC, tolerance);
    dispatch_source_set_event_handler(source, ^{
        if(t.valid) {
            [t fire];
        }
    });
    dispatch_resume(source);
}

- (void)addPort:(NSPort *)aPort forMode:(NSString *)mode
{
    // not implemented, just ignore
    // assert(0);
}

- (void)removePort:(NSPort *)aPort forMode:(NSString *)mode
{
    // not implemented
    assert(0);
}

- (NSDate *)limitDateForMode:(NSString *)mode
{
    // not implemented
    assert(0);
    return nil;
}

- (void)acceptInputForMode:(NSString *)mode beforeDate:(NSDate *)limitDate
{
    // not implemented
    assert(0);
}


@end

@implementation NSRunLoop (NSRunLoopConveniences)

- (void)run
{
    [self runUntilDate:[NSDate distantFuture]];
}

- (void)runUntilDate:(NSDate *)limitDate
{
    [self runMode:NSDefaultRunLoopMode beforeDate:limitDate];
}

- (BOOL)runMode:(NSString *)mode beforeDate:(NSDate *)limitDate
{
    if (mode == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Mode cannot be nil"];
        return NO;
    }

    // check limitDate is infinite

    if(dispatch_get_current_queue() == dispatch_get_main_queue()) {
        dispatch_main();
    } else {
        // todo
    }

    return false;
}

@end

@implementation NSObject (NSDelayedPerforming)

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray *)modes
{
    [self retain];
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW,  (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(t, dispatch_get_current_queue(), ^{
        [self performSelector:aSelector withObject:anArgument];
        [self release];
    });
}

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay
{
    if(delay > 0) {
        [self retain];
        dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW,  (int64_t)(delay * NSEC_PER_SEC));
        dispatch_after(t, dispatch_get_current_queue(), ^{
            [self performSelector:aSelector withObject:anArgument];
            [self release];
        });
    } else {
        [self retain];
        dispatch_async(dispatch_get_current_queue(), ^{
            [self performSelector:aSelector withObject:anArgument];
            [self release];
        });
    }
}

+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(id)anArgument
{
    // not implemented
    assert(0);
}

+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget
{
    // not implemented
    assert(0);
}

@end

@implementation NSRunLoop (NSOrderedPerform)

- (void)performSelector:(SEL)aSelector target:(id)target argument:(id)arg order:(NSUInteger)order modes:(NSArray *)modes
{
    dispatch_async(dispatch_get_current_queue(), ^{
        [target performSelector:aSelector withObject:arg];
    });
}

- (void)cancelPerformSelector:(SEL)aSelector target:(id)target argument:(id)arg
{
    // not implemented
    assert(0);
}

- (void)cancelPerformSelectorsWithTarget:(id)target
{
    // not implemented
    assert(0);
}

@end
