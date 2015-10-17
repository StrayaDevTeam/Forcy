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

//who fucking knows, enjoy doing this shit hayden
- (void)viewWillAppear:(BOOL)arg1{
	[super viewWillAppear:arg1];

	UIImage *banner = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/ForcyPrefs.bundle/Banner.png"];
	UIImageView *bannerView = [[UIImageView alloc] initWithImage:banner];
	[bannerView setFrame:CGRectMake(0,0,[self.view].bounds.size.width,100)];
	bannerView.contentMode = UIViewContentModeScaleAspectFit;

	[self.view addSubview:bannerView];
}
@end

// vim:ft=objc
