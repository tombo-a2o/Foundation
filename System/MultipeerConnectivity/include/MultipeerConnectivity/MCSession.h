#import <Foundation/NSObject.h>

typedef NS_ENUM (NSInteger, MCSessionState) {
    MCSessionStateNotConnected,
    MCSessionStateConnecting,
    MCSessionStateConnected 
};

@protocol MCSessionDelegate
@end

@interface MCSession : NSObject
@end
