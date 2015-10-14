#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#include <IOKit/hid/IOHIDEventSystem.h>
#include <IOKit/hid/IOHIDEventSystemClient.h>
#include <dlfcn.h>

@interface SBApplicationController
    +(id)sharedInstance;
    -(id)applicationWithBundleIdentifier:(id)arg1 ;
    @end

    @interface SBApplication
    @end

    @interface SBApplicationIcon : NSObject
    -(id)initWithApplication:(id)arg1 ;
    @end

@interface SBIcon
@end

@interface SBIconView : UIView
@property(retain, nonatomic) SBIcon *icon;
+(id)sharedInstance;
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
- (BOOL)isEditing;
@end

SBIconView *currentlyHighlightedIcon;

%hook SBIconView 

-(void)setLocation:(int)arg1 {

    UISwipeGestureRecognizer *swipeUp = [[[%c(UISwipeGestureRecognizer) alloc] initWithTarget:self action:@selector(fc_swiped:)] autorelease];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUp];

    %orig;
}
- (id)initWithContentType:(unsigned long long)arg1{
	return %orig;
}

%new -(void)fc_presentAppShortcutMenu:(NSString*)bundleID {
    if ([[%c(SBIconController) sharedInstance] isEditing])
        return;
    SBApplication *application = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:bundleID];
    SBApplicationIcon *applicationIcon = [[%c(SBApplicationIcon) alloc] initWithApplication:application];
    SBIconView *iconView = [[%c(SBIconViewMap) homescreenMap] mappedIconViewForIcon:applicationIcon];
    [[%c(SBIconController) sharedInstance] _revealMenuForIconView:iconView presentImmediately:true];
}

%new - (void)fc_swiped:(UISwipeGestureRecognizer *)gesture {
    if ([[%c(SBIconController) sharedInstance] isEditing])
        return;
    [[%c(SBIconController) sharedInstance] _revealMenuForIconView:self presentImmediately:true];
}

- (void)setHighlighted:(BOOL)highlighted {
    %orig;
    currentlyHighlightedIcon = highlighted ? self : nil;
}
%end