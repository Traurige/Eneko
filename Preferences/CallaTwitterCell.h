//
//  CallaTwitterCell.h
//  CallaTwitterCell
//
//  Created by Alexandra (@thatcluda)
//

#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>

@interface CallaTwitterCell : PSTableCell
@property(nonatomic, retain)UIImageView* leftUserAvatarImageView;
@property(nonatomic, retain)UILabel* leftUserDisplayNameLabel;
@property(nonatomic, retain)UILabel* leftUserUsernameLabel;
@property(nonatomic, retain)UIView* leftUserTapRecognizerView;
@property(nonatomic, retain)UITapGestureRecognizer* leftUserTap;
@property(nonatomic, retain)UIView* separatorView;
@property(nonatomic, retain)UIImageView* rightUserAvatarImageView;
@property(nonatomic, retain)UILabel* rightUserDisplayNameLabel;
@property(nonatomic, retain)UILabel* rightUserUsernameLabel;
@property(nonatomic, retain)UIView* rightUserTapRecognizerView;
@property(nonatomic, retain)UITapGestureRecognizer* rightUserTap;
@property(nonatomic, retain)NSString* leftUserDisplayName;
@property(nonatomic, retain)NSString* leftUserUsername;
@property(nonatomic, retain)NSString* rightUserDisplayName;
@property(nonatomic, retain)NSString* rightUserUsername;
- (void)visitLeftUserProfile;
- (void)visitRightUserProfile;
@end
