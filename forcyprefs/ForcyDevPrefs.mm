#import <Preferences/PSListController.h>
#import <UIKit/UIKit.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface ForcyDevPrefs : PSListController {
}
@end

@implementation ForcyDevPrefs
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ForcyDevPrefs" target:self] retain];
	}
	return _specifiers;
}

//------------------- Developer twitters (there's probably a better way to do this) -------------------//

-(void)openGreenyTwitter {
	NSString *user = @"GreenyDev";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

-(void)openHaydenTwitter {
	NSString *user = @"HHunterDev";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

-(void)openGeorgeTwitter {
    NSString *user = @"theninjaprawn";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

-(void)openEvanTwitter {
    NSString *user = @"evilgoldfish01";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

@end

@interface ForcyDevCell : PSTableCell {
    UIImageView *_background;
    UILabel *devName;
    UILabel *devTwitter;
    UILabel *jobSub;
    UIImage *iconImage;
}
@end

@implementation ForcyDevCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier])){

        NSMutableDictionary *properties = specifier.properties;
        //UIImage *bkIm = properties[@"iconImage"];
        _background = [[UIImageView alloc] initWithImage:properties[@"iconImage"]];
        _background.frame = CGRectMake(10, 15, 70, 70);
        _background.layer.cornerRadius = 15;
        _background.layer.masksToBounds = TRUE;
        properties[@"iconImage"] = nil;
        [self addSubview:_background];

        CGRect frame = [self frame];

        devName = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 95, frame.origin.y +10, frame.size.width, frame.size.height)];
        [devName setText:properties[@"devName"]];
        [devName setBackgroundColor:[UIColor clearColor]];
        [devName setTextColor:[UIColor blackColor]];
        [devName setFont:[UIFont fontWithName:@"Helvetica Light" size:23]];

        [self addSubview:devName];

        devTwitter = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 95, frame.origin.y + 30, frame.size.width, frame.size.height)];
        [devTwitter setText:properties[@"devTwitter"]];
        [devTwitter setTextColor:[UIColor grayColor]];
        [devTwitter setBackgroundColor:[UIColor clearColor]];
        [devTwitter setFont:[UIFont fontWithName:@"Helvetica Light" size:15]];

        [self addSubview:devTwitter];

        jobSub = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 95, frame.origin.y + 50, frame.size.width, frame.size.height)];
        [jobSub setText:properties[@"jobSub"]];
        [jobSub setTextColor:[UIColor grayColor]];
        [jobSub setBackgroundColor:[UIColor clearColor]];
        [jobSub setFont:[UIFont fontWithName:@"Helvetica Light" size:15]];

        [self addSubview:jobSub];
    }
    return self;
}

@end

// vim:ft=objc
