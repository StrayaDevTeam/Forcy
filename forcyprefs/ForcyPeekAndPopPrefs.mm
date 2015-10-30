#import <Preferences/PSListController.h>

@interface ForcyPeekAndPopPrefs: PSListController {
}
@end

@implementation ForcyPeekAndPopPrefs
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ForcyPeekAndPopPrefs" target:self] retain];
	}
	return _specifiers;
}

- (void)dismissKeyboard {
	[self.view endEditing:YES];
}

@end

// vim:ft=objc
