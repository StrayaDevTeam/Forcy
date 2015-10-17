#import <Preferences/PSListController.h>

int width = self.view.bounds.size.width;

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

// vim:ft=objc
