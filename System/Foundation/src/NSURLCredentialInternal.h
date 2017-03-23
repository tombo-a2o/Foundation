#import <Foundation/NSURLCredential.h>
#import <CFNetwork/CFURLAuthChallenge.h>

@interface NSURLCredential (Internal)
- (id)_initWithCFURLCredential:(CFURLCredentialRef)cfspace;
@end
