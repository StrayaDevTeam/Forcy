#import <Preferences/PSListController.h>

@interface Forcy3DMenuPrefs : PSListController {
}
@end

@implementation Forcy3DMenuPrefs
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Forcy3DMenuPrefs" target:self] retain];
	}
	return _specifiers;
}

- (void)dismissKeyboard {
	[self.view endEditing:YES];
}

@end

// vim:ft=objc
