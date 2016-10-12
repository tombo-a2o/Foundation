#import <Foundation/NSObject.h>
#import <Foundation/NSDictionary.h>

@interface NSProgress : NSObject
+ (id)currentProgress;
+ (id)progressWithTotalUnitCount:(int64_t)unitCount;

- (NSProgress *)initWithParent:(NSProgress *)parentProgressOrNil userInfo:(NSDictionary *)userInfoOrNil;

@property(readonly, getter=isCancelled) BOOL cancelled;
@property int64_t completedUnitCount;
@property int64_t totalUnitCount;
@property(copy) void (^pausingHandler)(void);
@property(copy) void (^cancellationHandler)(void);
@property(getter=isCancellable) BOOL cancellable;
@property(getter=isPausable) BOOL pausable;
@property(copy) void (^resumingHandler)(void);

@end
