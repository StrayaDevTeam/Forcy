#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#include <IOKit/hid/IOHIDEventSystem.h>
#include <IOKit/hid/IOHIDEventSystemClient.h>
#include <dlfcn.h>

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

bool enabled;
bool hapticFeedbackIsEnabled;
bool swapInvokeMethods;

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
+(id)sharedInstance;
- (void)_handleSecondHalfLongPressTimer:(id)arg1;
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
@end

static void loadPreferences() {
    CFPreferencesAppSynchronize(CFSTR("com.strayadevteam.forcyprefs"));

    enabled = !CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.strayadevteam.forcyprefs")) ? YES : [(id)CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.strayadevteam.forcyprefs")) boolValue];
    hapticFeedbackIsEnabled = !CFPreferencesCopyAppValue(CFSTR("hapticFeedbackIsEnabled"), CFSTR("com.strayadevteam.forcyprefs")) ? YES : [(id)CFPreferencesCopyAppValue(CFSTR("hapticFeedbackIsEnabled"), CFSTR("com.strayadevteam.forcyprefs")) boolValue];
    swapInvokeMethods = !CFPreferencesCopyAppValue(CFSTR("swapInvokeMethods"), CFSTR("com.strayadevteam.forcyprefs")) ? NO : [(id)CFPreferencesCopyAppValue(CFSTR("swapInvokeMethods"), CFSTR("com.strayadevteam.forcyprefs")) boolValue];
}

void hapticFeedback(){
    if(hapticFeedbackIsEnabled){
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        NSMutableArray* arr = [NSMutableArray array ];
        [arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for 2000ms
        [arr addObject:[NSNumber numberWithInt:50]];
        [dict setObject:arr forKey:@"VibePattern"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
    }
}

SBIconView *currentlyHighlightedIcon;

%hook SBIconView 

-(void)setLocation:(int)arg1 {
    UISwipeGestureRecognizer *swipeUp = [[[%c(UISwipeGestureRecognizer) alloc] initWithTarget:self action:@selector(fc_swiped:)] autorelease];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUp.delegate = (id <UIGestureRecognizerDelegate>)self;
    [self addGestureRecognizer:swipeUp];

    %orig;
}
- (id)initWithContentType:(unsigned long long)arg1{
	return %orig;
}

%new - (void)fc_swiped:(UISwipeGestureRecognizer *)gesture {
    if(enabled && gesture.state == UIGestureRecognizerStateRecognized){
        if(!swapInvokeMethods && [[%c(SBIconController) sharedInstance] _canRevealShortcutMenu]){
            [[%c(SBIconController) sharedInstance] _revealMenuForIconView:self presentImmediately:true];
            hapticFeedback();
        } else {
            [self _handleSecondHalfLongPressTimer:nil];
        }
    }
}
%new
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]] 
                        && ![[%c(SBIconController) sharedInstance] _canRevealShortcutMenu])
        return NO;
    
    return YES;
}
- (void)_handleSecondHalfLongPressTimer:(id)timer {
    if(enabled && [[%c(SBIconController) sharedInstance] _canRevealShortcutMenu] 
                                                    && swapInvokeMethods && timer != nil){
        [[%c(SBIconController) sharedInstance] _revealMenuForIconView:self presentImmediately:true];
        hapticFeedback();
        
        return;
    }
    
    %orig;
}

- (void)setHighlighted:(BOOL)highlighted {
    %orig;
    currentlyHighlightedIcon = highlighted ? self : nil;
}
%end

%ctor{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                (CFNotificationCallback)loadPreferences,
                                CFSTR("com.strayadevteam.forcyprefs/prefsChanged"),
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPreferences();
}