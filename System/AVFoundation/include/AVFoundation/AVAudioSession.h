#import <Foundation/NSObject.h>

@protocol AVAudioSessionDelegate
@end

@interface AVAudioSession : NSObject
@property(assign) id< AVAudioSessionDelegate > delegate;
@end
