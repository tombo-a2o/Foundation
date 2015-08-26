#import <Foundation/NSObject.h>
#import <Foundation/NSDate.h>

@interface NSTimer : NSObject

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)sel userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)sel userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

@property(copy) NSDate *fireDate;
@property(readonly, getter=isValid) BOOL valid;
@property(readonly) NSTimeInterval timeInterval;
@property(readonly, retain) id userInfo;
@property NSTimeInterval tolerance;

- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(id)ui repeats:(BOOL)rep;
- (void)fire;
- (void)invalidate;

@end
