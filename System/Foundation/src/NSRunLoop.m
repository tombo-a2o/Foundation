#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <assert.h>

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
    assert(0);
    /*
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_current_queue());

    NSDate *fireDate = timer.fireDate;
    NSTimeInterval interval = timer.timeInterval;
    NSTimeInterval tolerance = timer.torelance;

    __block NSTimer t = timer;

    dispatch_source_set_timer(source, ----, ----, ---);
    dispatch_source_set_event_handler(source, ^{
        if(t.valid) {
            [tfire]
        }
    });
    */
}

- (void)addPort:(NSPort *)aPort forMode:(NSString *)mode
{
    // not implemented
    assert(0);
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
    
    if(dispatch_get_current_queue() == dispatch_get_current_queue()) {
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
    // not implemented
    assert(0);
}

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay
{
    // not implemented
    assert(0);
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
    // not implemented
    assert(0);
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
