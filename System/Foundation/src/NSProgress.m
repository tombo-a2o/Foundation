#import <Foundation/Foundation.h>

@implementation NSProgress {
    int64_t _totalUnitCount;
    int64_t _completedUnitCount;
}

- (instancetype)initWithParent:(NSProgress *)parentProgressOrNil userInfo:(NSDictionary<NSProgressUserInfoKey, id> *)userInfoOrNil
{
    if(parentProgressOrNil) {
        NSLog(@"*** %s: Hierarchical NSProgress is not supported", __FUNCTION__);
        return nil;
    }
    if(userInfoOrNil) {
        NSLog(@"*** %s: userInfo is not supported", __FUNCTION__);
        return nil;
    }

    return self;
}

+ (NSProgress *)discreteProgressWithTotalUnitCount:(int64_t)unitCount
{
    NSProgress *progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    progress.totalUnitCount = unitCount;
    return progress;
}

+ (NSProgress *)progressWithTotalUnitCount:(int64_t)unitCount
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (NSProgress *)progressWithTotalUnitCount:(int64_t)unitCount parent:(NSProgress *)parent pendingUnitCount:(int64_t)portionOfParentTotalUnitCount
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (id)currentProgress
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)becomeCurrentWithPendingUnitCount:(int64_t)unitCount
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)addChild:(NSProgress *)child withPendingUnitCount:(int64_t)inUnitCount
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)resignCurrent
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)cancel
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)pause
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)resume
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)setUserInfoObject:(id)objectOrNil forKey:(NSProgressUserInfoKey)key
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)setTotalUnitCount:(int64_t)totalUnitCount
{
    [self willChangeValueForKey:@"fractionCompleted"];
    _totalUnitCount = totalUnitCount;
    [self didChangeValueForKey:@"fractionCompleted"];
}

- (int64_t)totalUnitCount
{
    return _totalUnitCount;
}

- (void)setCompletedUnitCount:(int64_t)completedUnitCount
{
    [self willChangeValueForKey:@"fractionCompleted"];
    _completedUnitCount = completedUnitCount;
    [self didChangeValueForKey:@"fractionCompleted"];
}

- (int64_t)completedUnitCount
{
    return _completedUnitCount;
}

- (double)fractionCompleted
{
    return 1.0f * _totalUnitCount / _completedUnitCount;
}

@end
