#import <Preferences/PSListController.h>

@interface ForcyInvokeMethodController: PSListController {
}
@end

@implementation ForcyInvokeMethodController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ForcyInvokeMethods" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
