//
//  CallaTwitterCell.m
//  CallaTwitterCell
//
//  Created by Alexandra (@thatcluda)
//

#import "CallaTwitterCell.h"

@implementation CallaTwitterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];


    self.leftUserDisplayName = specifier.properties[@"leftUserDisplayName"];
    self.leftUserUsername = specifier.properties[@"leftUserUsername"];
    self.rightUserDisplayName = specifier.properties[@"rightUserDisplayName"];
    self.rightUserUsername = specifier.properties[@"rightUserUsername"];


    // separator
	self.separatorView = [UIView new];
	[[self separatorView] setBackgroundColor:[[UIColor labelColor] colorWithAlphaComponent:0.1]];
	[self addSubview:[self separatorView]];

	[[self separatorView] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.separatorView.topAnchor constraintEqualToAnchor:self.topAnchor],
		[self.separatorView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
		[self.separatorView.heightAnchor constraintEqualToConstant:48],
		[self.separatorView.widthAnchor constraintEqualToConstant:1]
	]];

    
    // left user avatar image view
    self.leftUserAvatarImageView = [UIImageView new];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
		UIImage* avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://unavatar.io/%@?fallback=false", [self leftUserUsername]]]]];	
        dispatch_async(dispatch_get_main_queue(), ^{
			[UIView transitionWithView:[self leftUserAvatarImageView] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
				[[self leftUserAvatarImageView] setImage:avatar];
			} completion:nil];
        });
    });

    [[self leftUserAvatarImageView] setContentMode:UIViewContentModeScaleAspectFill];
    [[self leftUserAvatarImageView] setClipsToBounds:YES];
    [[[self leftUserAvatarImageView] layer] setCornerRadius:21.5];
    [[[self leftUserAvatarImageView] layer] setBorderWidth:2];
    [[[self leftUserAvatarImageView] layer] setBorderColor:[[[UIColor labelColor] colorWithAlphaComponent:0.1] CGColor]];
    [self addSubview:[self leftUserAvatarImageView]];

    [[self leftUserAvatarImageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
        [self.leftUserAvatarImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
		[self.leftUserAvatarImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [self.leftUserAvatarImageView.widthAnchor constraintEqualToConstant:43],
        [self.leftUserAvatarImageView.heightAnchor constraintEqualToConstant:43]
	]];


    // left user display name
    self.leftUserDisplayNameLabel = [UILabel new];
    [[self leftUserDisplayNameLabel] setText:[self leftUserDisplayName]];
    [[self leftUserDisplayNameLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
    [[self leftUserDisplayNameLabel] setTextColor:[UIColor labelColor]];
    [self addSubview:[self leftUserDisplayNameLabel]];

    [[self leftUserDisplayNameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.leftUserDisplayNameLabel.topAnchor constraintEqualToAnchor:self.leftUserAvatarImageView.topAnchor constant:4],
		[self.leftUserDisplayNameLabel.leadingAnchor constraintEqualToAnchor:self.leftUserAvatarImageView.trailingAnchor constant:8],
        [self.leftUserDisplayNameLabel.trailingAnchor constraintEqualToAnchor:self.separatorView.leadingAnchor constant:-4]
	]];


    // left user username
    self.leftUserUsernameLabel = [UILabel new];
    [[self leftUserUsernameLabel] setText:[NSString stringWithFormat:@"@%@", [self leftUserUsername]]];
    [[self leftUserUsernameLabel] setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]];
    [[self leftUserUsernameLabel] setTextColor:[[UIColor labelColor] colorWithAlphaComponent:0.6]];
    [self addSubview:[self leftUserUsernameLabel]];

    [[self leftUserUsernameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.leftUserUsernameLabel.leadingAnchor constraintEqualToAnchor:self.leftUserAvatarImageView.trailingAnchor constant:8],
        [self.leftUserUsernameLabel.trailingAnchor constraintEqualToAnchor:self.separatorView.leadingAnchor constant:-4],
        [self.leftUserUsernameLabel.bottomAnchor constraintEqualToAnchor:self.leftUserAvatarImageView.bottomAnchor constant:-4]
    ]];


    // left user tap view
    self.leftUserTapRecognizerView = [UIView new];
    [self addSubview:[self leftUserTapRecognizerView]];

    [[self leftUserTapRecognizerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.leftUserTapRecognizerView.topAnchor constraintEqualToAnchor:self.topAnchor],
		[self.leftUserTapRecognizerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.leftUserTapRecognizerView.trailingAnchor constraintEqualToAnchor:self.separatorView.leadingAnchor],
        [self.leftUserTapRecognizerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
	]];


    // left user tap
    self.leftUserTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visitLeftUserProfile)];
	[[self leftUserTapRecognizerView] addGestureRecognizer:[self leftUserTap]];


    // right user avatar image view
    self.rightUserAvatarImageView = [UIImageView new];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
		UIImage* avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://unavatar.io/%@?fallback=false", [self rightUserUsername]]]]];	
        dispatch_async(dispatch_get_main_queue(), ^{
			[UIView transitionWithView:[self rightUserAvatarImageView] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
				[[self rightUserAvatarImageView] setImage:avatar];
			} completion:nil];
        });
    });

    [[self leftUserAvatarImageView] setContentMode:UIViewContentModeScaleAspectFill];

    [[self rightUserAvatarImageView] setClipsToBounds:YES];
    [[[self rightUserAvatarImageView] layer] setCornerRadius:21.5];
    [[[self rightUserAvatarImageView] layer] setBorderWidth:2];
    [[[self rightUserAvatarImageView] layer] setBorderColor:[[[UIColor labelColor] colorWithAlphaComponent:0.1] CGColor]];
    [self addSubview:[self rightUserAvatarImageView]];

    [[self rightUserAvatarImageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
        [self.rightUserAvatarImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
		[self.rightUserAvatarImageView.leadingAnchor constraintEqualToAnchor:self.separatorView.leadingAnchor constant:16],
        [self.rightUserAvatarImageView.widthAnchor constraintEqualToConstant:43],
        [self.rightUserAvatarImageView.heightAnchor constraintEqualToConstant:43]
	]];

    // right user display name
    self.rightUserDisplayNameLabel = [UILabel new];
    [[self rightUserDisplayNameLabel] setText:[self rightUserDisplayName]];
    [[self rightUserDisplayNameLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
    [[self rightUserDisplayNameLabel] setTextColor:[UIColor labelColor]];
    [self addSubview:[self rightUserDisplayNameLabel]];

    [[self rightUserDisplayNameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.rightUserDisplayNameLabel.topAnchor constraintEqualToAnchor:self.leftUserAvatarImageView.topAnchor constant:4],
		[self.rightUserDisplayNameLabel.leadingAnchor constraintEqualToAnchor:self.rightUserAvatarImageView.trailingAnchor constant:8],
        [self.rightUserDisplayNameLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-4]
	]];


    // right user username
    self.rightUserUsernameLabel = [UILabel new];
    [[self rightUserUsernameLabel] setText:[NSString stringWithFormat:@"@%@", [self rightUserUsername]]];
    [[self rightUserUsernameLabel] setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]];
    [[self rightUserUsernameLabel] setTextColor:[[UIColor labelColor] colorWithAlphaComponent:0.6]];
    [self addSubview:[self rightUserUsernameLabel]];

    [[self rightUserUsernameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.rightUserUsernameLabel.leadingAnchor constraintEqualToAnchor:self.rightUserAvatarImageView.trailingAnchor constant:8],
        [self.rightUserUsernameLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-4],
        [self.rightUserUsernameLabel.bottomAnchor constraintEqualToAnchor:self.rightUserAvatarImageView.bottomAnchor constant:-4]
    ]];


    // right user tap view
    self.rightUserTapRecognizerView = [UIView new];
    [self addSubview:[self rightUserTapRecognizerView]];

    [[self rightUserTapRecognizerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.rightUserTapRecognizerView.topAnchor constraintEqualToAnchor:self.topAnchor],
		[self.rightUserTapRecognizerView.leadingAnchor constraintEqualToAnchor:self.separatorView.trailingAnchor],
        [self.rightUserTapRecognizerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.rightUserTapRecognizerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
	]];


    // right user tap
    self.rightUserTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visitRightUserProfile)];
	[[self rightUserTapRecognizerView] addGestureRecognizer:[self rightUserTap]];


	return self;

}

- (void)visitLeftUserProfile {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", [self leftUserUsername]]] options:@{} completionHandler:nil];

}

- (void)visitRightUserProfile {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", [self rightUserUsername]]] options:@{} completionHandler:nil];

}

@end
