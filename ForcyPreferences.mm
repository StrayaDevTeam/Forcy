#import "ForcyPreferences.h"

@implementation ForcyPreferences
+(id)sharedInstance {
	static dispatch_once_t p = 0;
	__strong static id _sharedObject = nil;
	 
	dispatch_once(&p, ^{
		_sharedObject = [[self alloc] init];
	});

	return _sharedObject;
}
-(id)init {
	self = [super init];
	if(self) {
		[self loadPrefs:NO];
	}
	return self;
}

-(void)loadPrefs:(BOOL)fromNotification{
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/Library/Preferences/com.strayadevteam.forcyprefs.plist"];

	self.enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
}
@end