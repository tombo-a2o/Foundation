#import <Foundation/NSURLAuthenticationChallenge.h>

@interface NSURLAuthenticationChallenge (Internal)
- (id)_initWithCFAuthChallenge:(CFURLAuthChallengeRef)cfchallenge sender:(id<NSURLAuthenticationChallengeSender>)sender;
@end
