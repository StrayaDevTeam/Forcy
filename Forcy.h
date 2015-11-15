#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIView.h>
#import <Photos/Photos.h>
#import "substrate.h"

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

static NSUserDefaults *preferences;
static bool enabled;
static bool hapticFeedbackIsEnabled;
static bool removeBackgroundBlur;
static bool preferForceTouch;
static CGFloat shortHoldTime;
static int vibrationTime;
static NSInteger invokeMethods;
static bool HardPress;
static bool FirstPress;
static bool menuEnabled;
static CGFloat lightPress;
static NSInteger peekAndPopSens = 20;
static bool peekAndPopEnabled;

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

@interface SAUIUnlockDevice
+(id)unlockDevice;
@end

@interface SpringBoard
-(UIImage*)getLatestPhoto;
@end

@interface DCIMImageWellUtilities : NSObject

+ (id)cameraPreviewWellImage;
+ (id)cameraPreviewWellImageFileURL;

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

@interface UIApplicationShortcutIcon (Private)
- (id)sbsShortcutIcon;
+ (id)iconWithCustomImage:(id)arg1;
@end

@interface SBSApplicationShortcutIcon
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) SBSApplicationShortcutIcon *icon;
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *type;
@end

@interface SBApplication
@property(copy, nonatomic) NSArray *staticShortcutItems;
-(id)path;
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