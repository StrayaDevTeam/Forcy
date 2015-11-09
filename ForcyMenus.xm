#import "Forcy.h"

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig();
    SBApplication *photoApp = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:@"com.apple.mobileslideshow"];

    UIApplicationShortcutIcon *photoSearchIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutIcon *photoFavoritesIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"QuickActionFavorite-OrbHW"];
    UIApplicationShortcutIcon *photosYearIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"QuickActionAYearAgo-OrbHW"];
    
    SBSApplicationShortcutItem *photoSearch = [%c(SBSApplicationShortcutItem) alloc];
    photoSearch.localizedTitle = @"Search";
    photoSearch.type = @"com.apple.photos.shortcuts.search";
    photoSearch.icon = [photoSearchIcon sbsShortcutIcon];

    SBSApplicationShortcutItem *photoFavorites = [%c(SBSApplicationShortcutItem) alloc];
    photoFavorites.localizedTitle = @"Favorites";
    photoFavorites.type = @"com.apple.photos.shortcuts.favorites";
    photoFavorites.icon = [photoFavoritesIcon sbsShortcutIcon];

    SBSApplicationShortcutItem *photoYear = [%c(SBSApplicationShortcutItem) alloc];
    photoYear.localizedTitle = @"One Year Ago";
    photoYear.type = @"com.apple.photos.shortcuts.oneyearago";
    photoYear.icon = [photosYearIcon sbsShortcutIcon];

    SBSApplicationShortcutItem *photoRecent = [%c(SBSApplicationShortcutItem) alloc];
        UIApplicationShortcutIcon *photoRecentIcon = [UIApplicationShortcutIcon iconWithCustomImage:[self getLatestPhoto]];
        photoRecent.icon = [photoRecentIcon sbsShortcutIcon];

    photoRecent.localizedTitle = @"Most Recent";
    photoRecent.type = @"com.apple.photos.shortcuts.recentphoto";
    
    photoApp.staticShortcutItems = [[NSArray alloc] initWithObjects:photoRecent, photoFavorites, photoYear, photoSearch, nil];

    SBApplication *mapsApp = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:@"com.apple.Maps"];

    UIApplicationShortcutIcon *mapsHomeIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"action-home-OrbHW"];
    UIApplicationShortcutIcon *mapsLocationIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"action-drop-pin-OrbHW"];
    UIApplicationShortcutIcon *mapsShareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIApplicationShortcutIcon *mapsSearchIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];

    SBSApplicationShortcutItem *mapsHome = [%c(SBSApplicationShortcutItem) alloc];
    mapsHome.localizedTitle = @"Directions Home";
    mapsHome.type = @"com.apple.Maps.directions";
    mapsHome.icon = [mapsHomeIcon sbsShortcutIcon];

    SBSApplicationShortcutItem *mapsMarkLocation = [%c(SBSApplicationShortcutItem) alloc];
    mapsMarkLocation.localizedTitle = @"Mark My Location";
    mapsMarkLocation.type = @"com.apple.Maps.mark-my-location";
    mapsMarkLocation.icon = [mapsLocationIcon sbsShortcutIcon];

    SBSApplicationShortcutItem *mapsShareLocation = [%c(SBSApplicationShortcutItem) alloc];
    mapsShareLocation.localizedTitle = @"Send My Location";
    mapsShareLocation.type = @"com.apple.Maps.share-location";
    mapsShareLocation.icon = [mapsShareIcon sbsShortcutIcon];

    SBSApplicationShortcutItem *mapsSearch = [%c(SBSApplicationShortcutItem) alloc];
    mapsSearch.localizedTitle = @"Search Nearby";
    mapsSearch.type = @"com.apple.Maps.search-nearby";
    mapsSearch.icon = [mapsSearchIcon sbsShortcutIcon];

    mapsApp.staticShortcutItems = [[NSArray alloc] initWithObjects:mapsHome, mapsMarkLocation, mapsShareLocation, mapsSearch, nil];   

    SBApplication *snapchatApp = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:@"com.toyopagroup.picaboo"];

    UIApplicationShortcutIcon *snapchatAddFriendsIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"quickaction_addfriends"];
    UIApplicationShortcutIcon *snapchatChatIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"quickaction_chat"];

    SBSApplicationShortcutItem *snapchatAddFriends = [%c(SBSApplicationShortcutItem) alloc];
    snapchatAddFriends.localizedTitle = @"Add Friends";
    snapchatAddFriends.type = @"com.snapchat.quick_action_type.add_friends";
    snapchatAddFriends.icon = [snapchatAddFriendsIcon sbsShortcutIcon];

    SBSApplicationShortcutItem *snapchatChat = [%c(SBSApplicationShortcutItem) alloc];
    snapchatChat.localizedTitle = @"Chat With...";
    snapchatChat.type = @"com.snapchat.quick_action_type.chat_with";
    snapchatChat.icon = [snapchatChatIcon sbsShortcutIcon];

    snapchatApp.staticShortcutItems = [[NSArray alloc] initWithObjects:snapchatAddFriends,snapchatChat, nil];

    [mapsSearch release];
    [mapsHome release];
    [mapsShareLocation release];
    [mapsMarkLocation release];

    [photoFavorites release];
    [photoRecent release];
    [photoYear release];
    [photoSearch release];

    [snapchatChat release];
    [snapchatAddFriends release];
}
%new
-(UIImage*)getLatestPhoto{
    PHImageManager *imgManager = [PHImageManager defaultManager];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.synchronous = TRUE;

    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = [[NSArray alloc] initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending: TRUE], nil];
    __block UIImage *finalImage = nil;

    if ([PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions]) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        if (fetchResult.count > 0) {
            [imgManager requestImageForAsset:[fetchResult objectAtIndex:(fetchResult.count-1)] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage *result, NSDictionary *info){
                    finalImage = result;
                }];
        }
    }

    return finalImage;
}
%end