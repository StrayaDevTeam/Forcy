#import "Forcy.h"

static void loadPreferences() {
    CFPreferencesAppSynchronize(CFSTR("com.strayadevteam.forcyprefs"));

    enabled = !CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.strayadevteam.forcyprefs")) ? YES : [(id)CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.strayadevteam.forcyprefs")) boolValue];
    hapticFeedbackIsEnabled = !CFPreferencesCopyAppValue(CFSTR("hapticFeedbackIsEnabled"), CFSTR("com.strayadevteam.forcyprefs")) ? YES : [(id)CFPreferencesCopyAppValue(CFSTR("hapticFeedbackIsEnabled"), CFSTR("com.strayadevteam.forcyprefs")) boolValue];
    swapInvokeMethods = !CFPreferencesCopyAppValue(CFSTR("swapInvokeMethods"), CFSTR("com.strayadevteam.forcyprefs")) ? NO : [(id)CFPreferencesCopyAppValue(CFSTR("swapInvokeMethods"), CFSTR("com.strayadevteam.forcyprefs")) boolValue];
    removeBackgroundBlur = !CFPreferencesCopyAppValue(CFSTR("removeBackgroundBlur"), CFSTR("com.strayadevteam.forcyprefs")) ? NO : [(id)CFPreferencesCopyAppValue(CFSTR("removeBackgroundBlur"), CFSTR("com.strayadevteam.forcyprefs")) boolValue];
    useSlideDownGestureToo = !CFPreferencesCopyAppValue(CFSTR("useSlideDownGestureToo"), CFSTR("com.strayadevteam.forcyprefs")) ? NO : [(id)CFPreferencesCopyAppValue(CFSTR("useSlideDownGestureToo"), CFSTR("com.strayadevteam.forcyprefs")) boolValue];
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

SBIconView *currentlyHighlightedIcon;

%hook SBIconView 

-(void)setLocation:(int)arg1 {
    self.shortcutMenuPeekGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:[%c(SBIconController) sharedInstance] action:@selector(_handleShortcutMenuPeek:)];
    self.shortcutMenuPeekGesture.minimumPressDuration = 0.5f;

    UISwipeGestureRecognizer *swipeUp = [[[%c(UISwipeGestureRecognizer) alloc] initWithTarget:self action:@selector(fc_swiped:)] autorelease];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUp.delegate = (id <UIGestureRecognizerDelegate>)self;
    [self addGestureRecognizer:swipeUp];

    /*if(useSlideDownGestureToo){
        UISwipeGestureRecognizer *swipeDown = [[[%c(UISwipeGestureRecognizer) alloc] initWithTarget:self action:@selector(fc_swiped:)] autorelease];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDown.delegate = (id <UIGestureRecognizerDelegate>)self;
    [self addGestureRecognizer:swipeDown];
    }*/

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
    %orig;
}
- (void)_handleFirstHalfLongPressTimer:(id)timer{
    if(enabled && [[%c(SBIconController) sharedInstance] _canRevealShortcutMenu] && swapInvokeMethods && timer != nil){

        [[%c(SBIconController) sharedInstance] _revealMenuForIconView:self presentImmediately:true];
        [self cancelLongPressTimer];
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

%hook SBApplicationShortcutMenu
-(void)_setupViews{
    %orig;
    if(enabled && removeBackgroundBlur){
        _UIBackdropView *_blurView = MSHookIvar<_UIBackdropView*>(self, "_blurView");
        [_blurView setHidden:true];
    }
}
%end

%hook UIScreen
- (int)_forceTouchCapability {
    return 1;
}
%end
%hook UITraitCollection
- (int)forceTouchCapability {
    return 1;
}
%end
%hook UIDevice
- (BOOL)_supportsForceTouch {
    return YES;
}
- (BOOL)_supportsHapticFeedback {
    return YES;
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