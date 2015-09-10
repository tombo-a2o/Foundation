//
//  NSTimer.m
//  Foundation
//
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/NSTimer.h>
#import <Foundation/NSInvocation.h>
#import <Foundation/NSRunLoop.h>
#import <Foundation/NSObjectInternal.h>
#import <dispatch/dispatch.h>
#import <objc/runtime.h>

@implementation NSTimer {
    id _target;
    SEL _sel;
    dispatch_source_t _timerSource;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo
{
    [invocation retainArguments];
    return [[[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:invocation selector:@selector(invoke) userInfo:nil repeats:yesOrNo] autorelease];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo
{
    [invocation retainArguments];
    NSTimer *timer = [[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:invocation selector:@selector(invoke) userInfo:nil repeats:yesOrNo];
    return [timer autorelease];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)sel userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    return [[[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:aTarget selector:sel userInfo:userInfo repeats:yesOrNo] autorelease];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)sel userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    NSTimer *timer = [[self alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:ti] interval:ti target:aTarget selector:sel userInfo:userInfo repeats:yesOrNo];
    return [timer autorelease];
}

- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(id)ui repeats:(BOOL)rep
{
    _timeInterval = rep ? ti : 0.0;
    _fireDate = date;
    _valid = YES;
    _target = [t retain];
    _sel = s;
    _userInfo = [ui retain];

    _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_current_queue());
    dispatch_source_set_timer(_timerSource, dispatch_time(DISPATCH_TIME_NOW, date.timeIntervalSinceNow*NSEC_PER_SEC), _timeInterval*NSEC_PER_SEC, _tolerance);
    dispatch_source_set_event_handler(_timerSource, ^{
        [_target performSelector:_sel withObject:self];
    });
    dispatch_resume(_timerSource);

    return self;
}

- (void)fire
{
    [_target performSelector:_sel withObject:self];
    if(_timeInterval == 0.0) {
        dispatch_source_cancel(_timerSource);
    }
}

- (void)invalidate
{
    _valid = NO;
    dispatch_suspend(_timerSource);
}

@end
