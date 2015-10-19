#import "Forcy.h"

static void loadPreferences() {
    CFPreferencesAppSynchronize((CFStringRef)TWEAK_SETTINGS);
    Boolean found;
    Boolean enabled = CFPreferencesGetAppBooleanValue(CFSTR("enabled"), (CFStringRef)TWEAK_SETTINGS, &found);
    enableTweak = ((found && enabled) || !found); // --> defaulting to YES (I hope :P)
    enabled = CFPreferencesGetAppBooleanValue(CFSTR("preferForceTouch"), (CFStringRef)TWEAK_SETTINGS, &found);
    preferForceTouch = (found && enabled); // --> defaulting to NO
    enabled = CFPreferencesGetAppBooleanValue(CFSTR("removeBackgroundBlur"), (CFStringRef)TWEAK_SETTINGS, &found);
    removeBackgroundBlur = (found && enabled); // --> defaulting to NO
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  loadPreferences();
}

void hapticFeedback(){
    if(hapticFeedbackIsEnabled){
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        NSMutableArray* arr = [NSMutableArray array ];
        [arr addObject:[NSNumber numberWithBool:YES]];
        [arr addObject:[NSNumber numberWithInt:50]]; //vibrate for 50ms
        [dict setObject:arr forKey:@"VibePattern"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
    }
}

%hook SBIconView 

- (void)addGestureRecognizer:(UIGestureRecognizer *)addGesture {
    if (addGesture != nil && addGesture == self.shortcutMenuPeekGesture) {
        UILongPressGestureRecognizer *menuCanceller = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        menuCanceller.minimumPressDuration = 1.0f;
        menuCanceller.delaysTouchesEnded = NO;
        menuCanceller.cancelsTouchesInView = NO;
        menuCanceller.allowableMovement = 1.0f;
        %orig(menuCanceller);
        
        if(preferForceTouch){
            self.shortcutMenuPeekGesture.minimumPressDuration = 0.325f;
        }
        [addGesture setRequiredPreviewForceState:0];
        [addGesture requireGestureRecognizerToFail:menuCanceller];
        
        [menuCanceller release];
    }
    
    %orig;
}

- (BOOL)_delegateTapAllowed {
    if ([[%c(SBIconController) sharedInstance] presentedShortcutMenu] != nil && !self.isHighlighted)
        return NO;
    
    return %orig;
}

- (void)_handleFirstHalfLongPressTimer:(id)arg1 {
    if ([[%c(SBIconController) sharedInstance] _canRevealShortcutMenu]) {
        hapticFeedback();
    }
    %orig;
}

- (void)_handleSecondHalfLongPressTimer:(id)arg1 {
    if ([[%c(SBIconController) sharedInstance] presentedShortcutMenu] != nil) {
        [self cancelLongPressTimer];
        [self setHighlighted:NO];
        return;
    }
    %orig;
}
%new
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    HBLogInfo(@"handleLongPressGesture has been called!");
    if(gesture.state == UIGestureRecognizerStateRecognized && !preferForceTouch){
        //[[%c(SBIconController) sharedInstance] _revealMenuForIconView:self :1];
    }
}
%end

%hook SBIconController
- (BOOL)iconShouldAllowTap:(SBIconView*)arg1 {
    if (self.presentedShortcutMenu != nil && !arg1.isHighlighted)
        return NO;
    
    return %orig;
}

- (void)_revealMenuForIconView:(id)arg1 presentImmediately:(_Bool)arg2 {
    if(!enableTweak){
        %orig(arg1, YES);
    }
}

%end

%hook SBApplicationShortcutMenu
-(void)_setupViews{
    %orig;
    if(enableTweak && removeBackgroundBlur){
        _UIBackdropView *_blurView = MSHookIvar<_UIBackdropView*>(self, "_blurView");
        [_blurView setHidden:true];
    }
}
%end

%hook UIScreen
- (long long)_forceTouchCapability {
    return 4;
}
%end

%hook UIDevice
- (BOOL)_supportsForceTouch {
    return TRUE;
}
%end


%ctor{
    loadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                PreferencesChangedCallback,
                                CFSTR("com.strayadevteam.forcyprefs/prefsChanged"),
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);   
}