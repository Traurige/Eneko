//
//  Eneko.h
//  Eneko
//
//  Created by Alexandra (@thatcluda)
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "GcUniversal/GcImagePickerUtils.h"
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;

BOOL enabled = YES;

BOOL isLockscreenVisible = NO;
BOOL isHomescreenVisible = NO;
BOOL isControlCenterVisible = NO;
BOOL isInCall = NO;
BOOL screenIsOn = YES;
BOOL isOnLowPower = NO;
BOOL supportsLowPowerMode = NO;

AVQueuePlayer* playerLS = nil;
AVPlayerItem* playerItemLS = nil;
AVPlayerLooper* playerLooperLS = nil;
AVPlayerLayer* playerLayerLS = nil;
UIView* dimBlurViewLS = nil;
UIVisualEffectView* blurViewLS = nil;
UIBlurEffect* blurLS = nil;
UIView* dimViewLS = nil;

AVQueuePlayer* playerHS = nil;
AVPlayerItem* playerItemHS = nil;
AVPlayerLooper* playerLooperHS = nil;
AVPlayerLayer* playerLayerHS = nil;
UIView* dimBlurViewHS = nil;
UIVisualEffectView* blurViewHS = nil;
UIBlurEffect* blurHS = nil;
UIView* dimViewHS = nil;

AVQueuePlayer* playerCC = nil;
AVPlayerItem* playerItemCC = nil;
AVPlayerLooper* playerLooperCC = nil;
AVPlayerLayer* playerLayerCC = nil;
UIView* dimBlurViewCC = nil;
UIVisualEffectView* blurViewCC = nil;
UIBlurEffect* blurCC = nil;
UIView* dimViewCC = nil;

// lockscreen
BOOL enableLockscreenWallpaperSwitch = NO;
double lockscreenVolumeValue = 0.0;
double lockscreenBlurAmountValue = 0.0;
NSUInteger lockscreenBlurModeValue = 0;
double lockscreenDimValue = 0.0;
double lockscreenOpacityValue = 1.0;

// homescreen
BOOL enableHomescreenWallpaperSwitch = NO;
double homescreenVolumeValue = 0.0;
double homescreenBlurAmountValue = 0.0;
NSUInteger homescreenBlurModeValue = 0;
double homescreenDimValue = 0.0;
double homescreenOpacityValue = 1.0;

// control center
BOOL enableControlCenterWallpaperSwitch = NO;
double controlCenterVolumeValue = 0.0;
double controlCenterBlurAmountValue = 0.0;
NSUInteger controlCenterBlurModeValue = 0;
double controlCenterDimValue = 0.0;
double controlCenterOpacityValue = 1.0;

// miscellaneous
BOOL muteWhenMusicPlaysSwitch = YES;
BOOL hideWhenLowPowerSwitch = YES;

@interface CSCoverSheetViewController : UIViewController
- (void)adjustFrame;
@end

@interface SBIconController : UIViewController
- (void)adjustFrame;
@end

@interface CCUIModularControlCenterOverlayViewController : UIViewController
- (void)adjustFrame;
@end
