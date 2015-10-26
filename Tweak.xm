#import "Forcy.h"



static void loadPreferences() {
    preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.strayadevteam.forcyprefs"];

    [preferences registerDefaults:@{
        @"enabled": @YES,
        @"hapticFeedbackIsEnabled": @YES,
        @"removeBackgroundBlur": @NO,
        @"preferForceTouch": @NO,
        @"shortHoldTime": [NSNumber numberWithFloat:0.325],
        @"vibrationTime": [NSNumber numberWithFloat:50],
        @"invokeMethods": [NSNumber numberWithInteger:0]
    }];

    enabled = [preferences boolForKey:@"enabled"];
    hapticFeedbackIsEnabled = [preferences boolForKey:@"hapticFeedbackIsEnabled"];
    removeBackgroundBlur = [preferences boolForKey:@"removeBackgroundBlur"];
    preferForceTouch = [preferences boolForKey:@"preferForceTouch"];
    shortHoldTime = [preferences floatForKey:@"shortHoldTime"];
    vibrationTime = [preferences floatForKey:@"vibrationTime"];
    invokeMethods = [preferences integerForKey:@"invokeMethods"];
}

void hapticFeedback(){
    if(hapticFeedbackIsEnabled){
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        NSMutableArray* arr = [NSMutableArray array];
        [arr addObject:[NSNumber numberWithBool:YES]];
        [arr addObject:[NSNumber numberWithInt:vibrationTime]]; //vibrate for 50ms
        [dict setObject:arr forKey:@"VibePattern"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
    }
}

SBIconView *currentlyHighlightedIcon;

%hook SBIconView 

UISwipeGestureRecognizer *swipeUp;
UITapGestureRecognizer *doubleTap;
- (void)setLocation:(id)arg1 {
    //im trying mum - i did it you proud?
        if(invokeMethods == 0){
            self.shortcutMenuPeekGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:[%c(SBIconController) sharedInstance] action:@selector(_handleShortcutMenuPeek:)];
            self.shortcutMenuPeekGesture.minimumPressDuration = shortHoldTime;
        } else if(invokeMethods == 2){
            doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fc_handleDoubleTapGesture:)];
            doubleTap.numberOfTapsRequired = 2;
            [self addGestureRecognizer:doubleTap];
            [doubleTap release];
        }
        //NSLog(@"invokeMethods == 1");
        swipeUp = [[[%c(UISwipeGestureRecognizer) alloc] initWithTarget:self action:@selector(fc_swiped:)] autorelease];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        swipeUp.delegate = (id <UIGestureRecognizerDelegate>)self;
        [self addGestureRecognizer:swipeUp];

    return %orig;
}

%new -(void)fc_handleDoubleTapGesture:(UITapGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateRecognized){
            [[%c(SBIconController) sharedInstance] _revealMenuForIconView:self presentImmediately:true];
            [self cancelLongPressTimer];
    }
}

%new - (void)fc_swiped:(UISwipeGestureRecognizer *)gesture {
    if(invokeMethods == 0){
        [[%c(SBIconController) sharedInstance] setIsEditing:YES];
        [self _handleSecondHalfLongPressTimer:nil];
    } else if (invokeMethods == 1){
        [[%c(SBIconController) sharedInstance] _revealMenuForIconView:self presentImmediately:true];
        [self cancelLongPressTimer];
    }
}

%new - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]] 
                        && ![[%c(SBIconController) sharedInstance] _canRevealShortcutMenu])
        return NO;
    
    return YES;
}

- (void)_handleFirstHalfLongPressTimer:(id)timer{
    if(enabled && [[%c(SBIconController) sharedInstance] _canRevealShortcutMenu] && timer != nil){
        if(invokeMethods == 0){
            [[%c(SBIconController) sharedInstance] _revealMenuForIconView:self presentImmediately:true];
            [self cancelLongPressTimer];
        } else if (invokeMethods == 1){
            [[%c(SBIconController) sharedInstance] setIsEditing:YES];
            [self _handleSecondHalfLongPressTimer:nil];
        } else if (invokeMethods == 2){

        }
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
    return 2;
}
%end

%hook UITraitCollection
- (int)forceTouchCapability {
    return 2;
}
%end

%hook UIDevice
- (BOOL)_supportsForceTouch {
    return TRUE;
}
%end


%hook SBIconController
- (void)_revealMenuForIconView:(SBIconView *)iconView presentImmediately:(BOOL)imm {
    if(hapticFeedbackIsEnabled && !self.isEditing){
        hapticFeedback();
    }
    %orig(iconView, YES);
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