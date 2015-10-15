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
// New methods
- (void)fc_swiped:(UISwipeGestureRecognizer *)gesture;
- (void)fc_swappedGestures;
@end

@interface SBIconViewMap
+(id)homescreenMap;
-(id)mappedIconViewForIcon:(id)arg1 ;
@end

@interface SBIconController
+(id)sharedInstance;
- (void)_revealMenuForIconView:(id)arg1 presentImmediately:(BOOL)arg2;
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
    [self addGestureRecognizer:swipeUp];

    UILongPressGestureRecognizer *longPress = [[[%c(UILongPressGestureRecognizer) alloc] initWithTarget:self action:@selector(fc_swappedGestures:)] autorelease];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];

    %orig;
}
- (id)initWithContentType:(unsigned long long)arg1{
	return %orig;
}

%new - (void)fc_swiped:(UISwipeGestureRecognizer *)gesture {
    if(enabled){
    if ([[%c(SBIconController) sharedInstance] isEditing])
        return;

    if(!swapInvokeMethods){
        [[%c(SBIconController) sharedInstance] _revealMenuForIconView:self presentImmediately:true];
        hapticFeedback();
    } else {
        [[%c(SBIconController) sharedInstance] setIsEditing:YES];
    }
}
}
%new - (void)fc_swappedGestures:(UILongPressGestureRecognizer *)gesture {
    if(enabled){
        if ([[%c(SBIconController) sharedInstance] isEditing])
            return;

        if(swapInvokeMethods){
            [[%c(SBIconController) sharedInstance] setIsEditing:NO];
            [[%c(SBIconController) sharedInstance] _revealMenuForIconView:self presentImmediately:true];
            hapticFeedback();
        } else {
            [[%c(SBIconController) sharedInstance] setIsEditing:YES];
        }
    }
    if(!swapInvokeMethods){
        [[%c(SBIconController) sharedInstance] setIsEditing:YES];
    }
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