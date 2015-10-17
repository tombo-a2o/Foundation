//
//  NSThread.m
//  Foundation
//
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/NSThread.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSException.h>
#import <Foundation/NSLock.h>
#import <Foundation/NSRunLoop.h>
#import <Foundation/NSString.h>
#import <CoreFoundation/CFRunLoop.h>
#import <CoreFoundation/CFNumber.h>
#import <pthread.h>
#import <unistd.h>
#import <objc/message.h>
#import <assert.h>

typedef enum {
    NSThreadCreated,
    NSThreadStarted,
    NSThreadRunning,
    NSThreadCancelling,
    NSThreadEnding,
    NSThreadFinished
} NSThreadState;

static void *NSThreadKey = (void*)"NSThreadKey";

static NSThread *NSMainThread = nil;

@interface NSThread (Internal)
- (BOOL)_setThreadPriority:(double)p;
@end

@implementation NSThread {
@package
    NSString *_name;
    NSMutableDictionary *_threadDictionary;
    NSThreadState _state;
    NSMutableArray *_performers;
    id _target;
    SEL _selector;
    id _argument;
    dispatch_queue_t _queue;
}

static void NSThreadEnd(NSThread *thread)
{
    thread->_state = NSThreadFinished;
    [thread release];
}

+ (void)initialize
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSMainThread = [[NSThread alloc] init];
        NSMainThread->_queue = dispatch_get_main_queue();
        dispatch_queue_set_specific(NSMainThread->_queue, NSThreadKey, NSMainThread, NULL);
    });
}

+ (NSThread *)currentThread
{
    NSThread *thread = dispatch_get_specific(NSThreadKey);
    if (thread == nil)
    {
        thread = [[NSThread alloc] init];
        thread->_queue = dispatch_get_current_queue();
        dispatch_queue_set_specific(thread->_queue, NSThreadKey, thread, NULL);
    }
    return thread;
}

+ (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(id)argument
{
    NSThread *thread = [[NSThread alloc] initWithTarget:target selector:selector object:argument];
    [thread start];
    [thread release];
}

+ (BOOL)isMultiThreaded
{
    return YES;
}

+ (void)sleepUntilDate:(NSDate *)date
{
    [self sleepForTimeInterval:[date timeIntervalSinceNow]];
}

+ (void)sleepForTimeInterval:(NSTimeInterval)ti
{
    usleep(1000000ULL * ti);
}

+ (void)exit
{
    if([self isMainThread]) {
        exit(0);
    } else {
        assert(0);
    }
}

+ (double)threadPriority
{
    return [[NSThread currentThread] threadPriority];
}

+ (BOOL)setThreadPriority:(double)p
{
    return NO;
}

+ (NSArray *)callStackReturnAddresses
{
    // not implemented
    assert(0);
}

+ (NSArray *)callStackSymbols
{
    // not implemented
    assert(0);
}

+ (BOOL)isMainThread
{
    return [[NSThread currentThread] isMainThread];
}

+ (NSThread *)mainThread
{
    return NSMainThread;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _performers = [[NSMutableArray alloc] init];
        _threadDictionary = [[NSMutableDictionary alloc] init];
        _state = NSThreadCreated;
    }
    return self;
}

- (id)initWithTarget:(id)target selector:(SEL)selector object:(id)argument
{
    self = [self init];
    if (self)
    {
        _target = [target retain];
        _selector = selector;
        _argument = [argument retain];
    }
    return self;
}

- (void)dealloc
{
    [_target release];
    [_argument release];
    [_threadDictionary release];
    [_name release];
    [(id)_queue release];
    [super dealloc];
}

- (BOOL)isMainThread
{
    return self == NSMainThread;
}

- (BOOL)isExecuting
{
    return _state == NSThreadRunning;
}

- (BOOL)isFinished
{
    return _state == NSThreadFinished;
}

- (BOOL)isCancelled
{
    return _state == NSThreadCancelling;
}

- (void)cancel
{
    _state = NSThreadCancelling;
}

- (void)start
{
    if (_state > NSThreadCreated)
    {
        [NSException raise:NSInvalidArgumentException format:@"Attempting to start a thread more than once"];
        return;
    }
    _state = NSThreadStarted;
    [self retain];
    
    _queue = dispatch_queue_create("thread", NULL);
    dispatch_queue_set_specific(_queue, NSThreadKey, self, NULL);

    dispatch_async(_queue, ^{
        @autoreleasepool {
            self->_state = NSThreadRunning;
            [self main];
            self->_state = NSThreadFinished;
            // TODO: needs special treatment for runloop
            [self release];
        }
    });
}

- (void)main
{
    if (_target && _selector)
    {
        [_target performSelector:_selector withObject:_argument];
    }
}

@end

@implementation NSObject (NSThreadPerformAdditions)

- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)waitUntilDone modes:(NSArray *)modes
{
    [self performSelector:aSelector onThread:[NSThread mainThread] withObject:arg waitUntilDone:waitUntilDone modes:modes];
}

+ (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)waitUntilDone modes:(NSArray *)modes
{
    [self performSelector:aSelector onThread:[NSThread mainThread] withObject:arg waitUntilDone:waitUntilDone modes:modes];   
}

- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)waitUntilDone
{
    [self performSelector:aSelector onThread:[NSThread mainThread] withObject:arg waitUntilDone:waitUntilDone modes:@[(id)kCFRunLoopCommonModes]];
}

+ (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)waitUntilDone
{
    [self performSelector:aSelector onThread:[NSThread mainThread] withObject:arg waitUntilDone:waitUntilDone modes:@[(id)kCFRunLoopCommonModes]];   
}

static void NSThreadPerform(id self, SEL aSelector, NSThread *thr, id arg, BOOL waitUntilDone, NSArray *modes)
{
    if ([NSThread currentThread] == thr && waitUntilDone)
    {
        [self performSelector:aSelector withObject:arg];
        return;
    }


    [self retain];
    [arg retain];
    // TODO: mode
    if (waitUntilDone) {
        dispatch_sync(thr->_queue, ^{
            [self performSelector:aSelector withObject:arg];
            [self release];
            [arg release];
        });
    } else {
        dispatch_async(thr->_queue, ^{
            [self performSelector:aSelector withObject:arg];
            [self release];
            [arg release];
        });
    }
}

- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)waitUntilDone modes:(NSArray *)modes
{
    NSThreadPerform(self, aSelector, thr, arg, waitUntilDone, modes);
}

+ (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)waitUntilDone modes:(NSArray *)modes
{
    NSThreadPerform(self, aSelector, thr, arg, waitUntilDone, modes);
}

- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)waitUntilDone
{
    [self performSelector:aSelector onThread:thr withObject:arg waitUntilDone:waitUntilDone modes:@[(id)kCFRunLoopCommonModes]];
}

- (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:aSelector object:arg];
    [thread start];
    [thread autorelease];
}

@end
