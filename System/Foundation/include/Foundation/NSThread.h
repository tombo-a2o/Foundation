#import <Foundation/NSObject.h>
#import <Foundation/NSDate.h>

@class NSArray, NSMutableDictionary, NSDate;

FOUNDATION_EXPORT NSString * const NSWillBecomeMultiThreadedNotification;
FOUNDATION_EXPORT NSString * const NSDidBecomeSingleThreadedNotification;
FOUNDATION_EXPORT NSString * const NSThreadWillExitNotification;

@interface NSThread : NSObject

+ (NSThread *)currentThread;
+ (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(id)argument;
+ (BOOL)isMultiThreaded;
+ (void)sleepUntilDate:(NSDate *)date;
+ (void)sleepForTimeInterval:(NSTimeInterval)ti;
+ (void)exit;
+ (double)threadPriority;
+ (BOOL)setThreadPriority:(double)p;
+ (NSArray *)callStackReturnAddresses;
+ (NSArray *)callStackSymbols;
+ (BOOL)isMainThread;
+ (NSThread *)mainThread;
- (id)init;
- (id)initWithTarget:(id)target selector:(SEL)selector object:(id)argument;
- (NSUInteger)stackSize;
- (void)setStackSize:(NSUInteger)s;
- (BOOL)isMainThread;
- (BOOL)isExecuting;
- (BOOL)isFinished;
- (BOOL)isCancelled;
- (void)cancel;
- (void)start;
- (void)main;

@property(readonly, retain) NSMutableDictionary *threadDictionary;
@property(copy) NSString *name;
@property double threadPriority;
@property NSUInteger stackSize;
@end

@interface NSObject (NSThreadPerformAdditions)

- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array;
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array;
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait;
- (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg;

@end
