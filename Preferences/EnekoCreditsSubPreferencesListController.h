//
//  EnekoCreditsSubPreferencesListController.h
//  Eneko
//
//  Created by Alexandra (@thatcluda)
//

#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

@interface EnekoAppearanceSettings : HBAppearanceSettings
@end

@interface EnekoCreditsSubPreferencesListController : HBListController
@property(nonatomic, retain)EnekoAppearanceSettings* appearanceSettings;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@end
