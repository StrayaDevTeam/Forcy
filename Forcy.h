#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIView.h>
#define TWEAK_SETTINGS @"com.strayadevteam.forcyprefs"
#if INSPECTIVEC_DEBUG
#include "InspCWrapper.m"
#endif

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

Boolean enabled;
bool enableTweak;
bool hapticFeedbackIsEnabled;
bool swapInvokeMethods;
bool removeBackgroundBlur;
bool preferForceTouch;

@interface _UIBackdropView : UIView
@end

@interface UIGestureRecognizer (Forcy)
- (void)setRequiredPreviewForceState:(int)arg1;
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
- (void)fc_swiped:(UISwipeGestureRecognizer *)gesture;
- (void)setHighlighted:(BOOL)arg1;
- (BOOL)isHighlighted;
@end

@interface SBIconViewMap
+(id)homescreenMap;
-(id)mappedIconViewForIcon:(id)arg1;
@end

@interface SBApplicationShortcutMenu : NSObject @end

@interface SBIconController
+ (id)sharedInstance;
- (void)_revealMenuForIconView:(id)arg1 presentImmediately:(BOOL)arg2;
- (BOOL)_canRevealShortcutMenu;
- (BOOL)isEditing;
- (void)iconHandleLongPress:(id)arg1;
- (void)setIsEditing:(_Bool)arg1;
- (void)_handleShortcutMenuPeek:(id)arg1;
@property(retain, nonatomic) SBApplicationShortcutMenu *presentedShortcutMenu;
@end

@interface SBApplicationShortcutMenuBackgroundView : UIView
-(void)setAlpha:(double)arg1;
@end
