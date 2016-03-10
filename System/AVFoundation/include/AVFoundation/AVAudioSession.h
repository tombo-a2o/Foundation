#import <Foundation/NSObject.h>

extern NSString *const AVAudioSessionCategoryAmbient;
extern NSString *const AVAudioSessionCategorySoloAmbient;
extern NSString *const AVAudioSessionCategoryPlayback;
extern NSString *const AVAudioSessionCategoryRecord;
extern NSString *const AVAudioSessionCategoryPlayAndRecord;
extern NSString *const AVAudioSessionCategoryAudioProcessing;
extern NSString *const AVAudioSessionCategoryMultiRoute;

@protocol AVAudioSessionDelegate
@end

@interface AVAudioSession : NSObject
+ (AVAudioSession *)sharedInstance;
- (BOOL)setActive:(BOOL)beActive error:(NSError **)outError;
- (BOOL)setCategory:(NSString *)theCategory error:(NSError **)outError;
@property(assign) id< AVAudioSessionDelegate > delegate;
@end
