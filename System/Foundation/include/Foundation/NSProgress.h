#import <Foundation/NSObject.h>
#import <Foundation/NSDictionary.h>

typedef NSString *NSProgressKind;
typedef NSString *NSProgressFileOperationKind;
typedef NSString *NSProgressUserInfoKey;

@interface NSProgress : NSObject
- (instancetype)initWithParent:(NSProgress *)parentProgressOrNil
                      userInfo:(NSDictionary<NSProgressUserInfoKey, id> *)userInfoOrNil;
+ (NSProgress *)discreteProgressWithTotalUnitCount:(int64_t)unitCount;
+ (NSProgress *)progressWithTotalUnitCount:(int64_t)unitCount;
+ (NSProgress *)progressWithTotalUnitCount:(int64_t)unitCount
                                    parent:(NSProgress *)parent
                          pendingUnitCount:(int64_t)portionOfParentTotalUnitCount;

+ (id)currentProgress;
- (void)becomeCurrentWithPendingUnitCount:(int64_t)unitCount;
- (void)addChild:(NSProgress *)child
withPendingUnitCount:(int64_t)inUnitCount;
- (void)resignCurrent;

@property int64_t totalUnitCount;
@property int64_t completedUnitCount;
@property(copy) NSString *localizedDescription;
@property(copy) NSString *localizedAdditionalDescription;

@property(readonly) double fractionCompleted;

@property(getter=isCancellable) BOOL cancellable;
@property(readonly, getter=isCancelled) BOOL cancelled;
- (void)cancel;
@property(copy) void (^cancellationHandler)(void);
@property(getter=isPausable) BOOL pausable;
@property(readonly, getter=isPaused) BOOL paused;
- (void)pause;
@property(copy) void (^pausingHandler)(void);
- (void)resume;
@property(copy) void (^resumingHandler)(void);

@property(readonly, getter=isIndeterminate) BOOL indeterminate;
@property(copy) NSProgressKind kind;
- (void)setUserInfoObject:(id)objectOrNil
                   forKey:(NSProgressUserInfoKey)key;
@property(readonly, copy) NSDictionary<NSProgressUserInfoKey, id> *userInfo;


@end
