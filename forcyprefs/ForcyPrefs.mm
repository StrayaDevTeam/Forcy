#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>

#define kWidth [[UIApplication sharedApplication] keyWindow].frame.size.width

@interface ForcyPrefsListController: PSListController {
}
@end

@implementation ForcyPrefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ForcyPrefs" target:self] retain];
	}
	return _specifiers;
}
@end

@interface ForcyPrefsEasterEggCell : PSTableCell{
	UILabel *easterEggLabel;
}
@end

@implementation ForcyPrefsEasterEggCell
- (id)initWithSpecifier:(PSSpecifier *)specifier{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EasterEggCell" specifier:specifier];
	if(self){
		CGRect easterEggTextRect = CGRectMake(0, -300, kWidth, 100);

		easterEggLabel = [[UILabel alloc] initWithFrame:easterEggTextRect]; 
		[easterEggLabel setNumberOfLines:1];
		[easterEggLabel setText:@"Includes no stolen code!"];
		[easterEggLabel setBackgroundColor:[UIColor clearColor]];
		[easterEggLabel setTextColor:[UIColor grayColor]];
		[easterEggLabel setTextAlignment:NSTextAlignmentCenter];

		[self addSubview:easterEggLabel];
	}

	return self;
}
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
    return 25.0f;
}
@end
// vim:ft=objc
