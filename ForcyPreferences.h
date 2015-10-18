#import "Forcy.h"

@interface ForcyPreferences : NSObject
+(id)sharedInstance;
-(void)loadPrefs:(BOOL)fromNotification;

@property(nonatomic) BOOL enabled;
@property(nonatomic) BOOL hapticFeedbackIsEnabled;
@property(nonatomic) BOOL swapInvokeMethods;
@property(nonatomic) BOOL removeBackgroundBlur;

@end
