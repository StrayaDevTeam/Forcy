#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIView.h>
#import "substrate.h"

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

NSUserDefaults *preferences;
bool enabled;
bool hapticFeedbackIsEnabled;
bool removeBackgroundBlur;
bool preferForceTouch;
CGFloat shortHoldTime;
int vibrationTime;
NSInteger invokeMethods;
bool HardPress;
bool FirstPress;
bool menuEnabled;
CGFloat lightPress;
NSInteger kForceSensitivity = 20;

@interface _UITouchForceMessage : NSObject
@property (nonatomic) double timestamp;
@property (nonatomic) float unclampedTouchForce;
- (void)setUnclampedTouchForce:(float)touchForce;
- (float)unclampedTouchForce;
@end
@interface UITouch (Private)
- (void)_setPressure:(float)arg1 resetPrevious:(BOOL)arg2;
- (float)_pathMajorRadius;
- (float)majorRadius;
+ (id)sharedInstance;
@end

@interface _UIBackdropView : UIView
@end

@interface _UIBackdropViewSettings : NSObject
-(id)settingsForStyle:(long long)arg1 graphicsQuality:(long long)arg2 ;
-(void)setGrayscaleTintAlpha:(CGFloat)arg1;
-(CGFloat)grayscaleTintAlpha;
@end

@interface SBApplicationController
+(id)sharedInstance;    
-(id)applicationWithBundleIdentifier:(id)arg1 ;

@end

@interface SBApplication
@end

@interface SBApplicationIcon : NSObject
-(id)initWithApplication:(id)arg1;
@end

@interface SBIcon
@end

@interface SBIconView : UIView
@property(retain, nonatomic) SBIcon *icon;
@property(retain, nonatomic) UILongPressGestureRecognizer *shortcutMenuPeekGesture;
+(id)sharedInstance;
- (void)_handleSecondHalfLongPressTimer:(id)arg1;
- (void)cancelLongPressTimer;
// New methods
- (void)fc_swiped:(UISwipeGestureRecognizer *)gesture;
@end

@interface SBIconViewMap
+(id)homescreenMap;
-(id)mappedIconViewForIcon:(id)arg1 ;
@end

@interface SBIconController
+(id)sharedInstance;
- (void)_revealMenuForIconView:(id)arg1 presentImmediately:(BOOL)arg2;
- (BOOL)_canRevealShortcutMenu;
- (BOOL)isEditing;
- (void)iconHandleLongPress:(id)arg1;
- (void)setIsEditing:(_Bool)arg1;
- (void)_handleShortcutMenuPeek:(id)arg1;
@end

@interface SBApplicationShortcutMenu : UIView
@end