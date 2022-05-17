//
//  Eneko.x
//  Eneko
//
//  Created by Alexandra (@thatcluda)
//

#import "Eneko.h"

%group Lockscreen

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add the wallpaper to the lockscreen

    %orig;

    // player
    NSURL* url = [GcImagePickerUtils videoURLFromDefaults:@"love.litten.enekopreferences" withKey:@"lockscreenWallpaper"];
    if (!url) return;

    playerItemLS = [AVPlayerItem playerItemWithURL:url];

    playerLS = [AVQueuePlayer playerWithPlayerItem:playerItemLS];
    playerLS.volume = lockscreenVolumeValue;
    [playerLS setPreventsDisplaySleepDuringVideoPlayback:NO];
    if (lockscreenVolumeValue == 0.0) [playerLS setMuted:YES];
    else [playerLS setVolume:lockscreenVolumeValue];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

    playerLooperLS = [AVPlayerLooper playerLooperWithPlayer:playerLS templateItem:playerItemLS];

    playerLayerLS = [AVPlayerLayer playerLayerWithPlayer:playerLS];
    [playerLayerLS setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [playerLayerLS setFrame:[[[self view] layer] bounds]];
    [playerLayerLS setOpacity:lockscreenOpacityValue];
    [[[self view] layer] insertSublayer:playerLayerLS atIndex:0];


    // dim and blur superview
    if (!dimBlurViewLS && (lockscreenBlurAmountValue != 0.0 || lockscreenDimValue != 0.0)) {
        dimBlurViewLS = [[UIView alloc] initWithFrame:[[self view] bounds]];
        [dimBlurViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [[self view] insertSubview:dimBlurViewLS atIndex:1];
    }

    // blur
    if (!blurLS && lockscreenBlurAmountValue != 0.0) {
        if (lockscreenBlurModeValue == 0)
            blurLS = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        else if (lockscreenBlurModeValue == 1)
            blurLS = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

        blurViewLS = [[UIVisualEffectView alloc] initWithEffect:blurLS];
        [blurViewLS setFrame:[dimBlurViewLS bounds]];
        [blurViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [blurViewLS setClipsToBounds:YES];
        [blurViewLS setAlpha:lockscreenBlurAmountValue];
        [dimBlurViewLS addSubview:blurViewLS];
    }

    // dim
    if (!dimViewLS && lockscreenDimValue != 0.0) {
        dimViewLS = [[UIView alloc] initWithFrame:[[self view] bounds]];
        [dimViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [dimViewLS setBackgroundColor:[UIColor blackColor]];
        [dimViewLS setAlpha:lockscreenDimValue];
        [dimBlurViewLS addSubview:dimViewLS];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustFrame) name:@"enekoRotateNotification" object:nil];

}

- (void)viewWillAppear:(BOOL)animated { // play when the lockscreen appears

    %orig;

    isLockscreenVisible = YES;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    [self adjustFrame];
    [playerLS play];
    if (enableHomescreenWallpaperSwitch && isHomescreenVisible) [playerHS pause];

}

- (void)viewWillDisappear:(BOOL)animated { // pause when the lockscreen disappears

    %orig;

    isLockscreenVisible = NO;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    [playerLS pause];
    if (enableHomescreenWallpaperSwitch && isHomescreenVisible) [playerHS play];

}

%new
- (void)adjustFrame { // adjust the frame
    
    [playerLayerLS setFrame:[[[self view] layer] bounds]];

}

%end

%hook SBControlCenterController

- (void)_willPresent { // pause when the control center appears

    %orig;

    isControlCenterVisible = YES;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (isLockscreenVisible) [playerLS pause];

}

%end

%hook CCUIModularControlCenterOverlayViewController

- (void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 { // pause when the control center is being dismissed

    %orig;

    isControlCenterVisible = NO;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (isLockscreenVisible) [playerLS play];

}

%end

%end

%group Homescreen

%hook SBIconController

- (void)viewDidLoad { // add the wallpaper to the homescreen

    %orig;

    // player
    NSURL* url = [GcImagePickerUtils videoURLFromDefaults:@"love.litten.enekopreferences" withKey:@"homescreenWallpaper"];
    if (!url) return;

    playerItemHS = [AVPlayerItem playerItemWithURL:url];

    playerHS = [AVQueuePlayer playerWithPlayerItem:playerItemHS];
    playerHS.volume = homescreenVolumeValue;
    [playerHS setPreventsDisplaySleepDuringVideoPlayback:NO];
    if (homescreenVolumeValue == 0.0) [playerHS setMuted:YES];
    else [playerHS setVolume:homescreenVolumeValue];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    playerLooperHS = [AVPlayerLooper playerLooperWithPlayer:playerHS templateItem:playerItemHS];

    playerLayerHS = [AVPlayerLayer playerLayerWithPlayer:playerHS];
    [playerLayerHS setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [playerLayerHS setFrame:[[[self view] layer] bounds]];
    [playerLayerHS setTransform:CATransform3DMakeScale(1.15, 1.15, 2)];
    [playerLayerHS setOpacity:homescreenOpacityValue];
    [[[self view] layer] insertSublayer:playerLayerHS atIndex:0];


    // dim and blur superview
    if (!dimBlurViewHS && (homescreenBlurAmountValue != 0.0 || homescreenDimValue != 0.0)) {
        dimBlurViewHS = [[UIView alloc] initWithFrame:[[self view] bounds]];
        [[dimBlurViewHS layer] setTransform:CATransform3DMakeScale(1.15, 1.15, 2)];
        [dimBlurViewHS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [[self view] insertSubview:dimBlurViewHS atIndex:1];
    }

    // blur
    if (!blurHS && homescreenBlurAmountValue != 0.0) {
        if (homescreenBlurModeValue == 0)
            blurHS = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        else if (homescreenBlurModeValue == 1)
            blurHS = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

        blurViewHS = [[UIVisualEffectView alloc] initWithEffect:blurHS];
        [blurViewHS setFrame:[dimBlurViewHS bounds]];
        [blurViewHS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [blurViewHS setClipsToBounds:YES];
        [blurViewHS setAlpha:homescreenBlurAmountValue];
        [dimBlurViewHS addSubview:blurViewHS];
    }

    // dim
    if (!dimViewHS && homescreenDimValue != 0.0) {
        dimViewHS = [[UIView alloc] initWithFrame:[[self view] bounds]];
        [dimViewHS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [dimViewHS setBackgroundColor:[UIColor blackColor]];
        [dimViewHS setAlpha:homescreenDimValue];
        [dimBlurViewHS addSubview:dimViewHS];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustFrame) name:@"enekoRotateNotification" object:nil];

}

- (void)viewWillAppear:(BOOL)animated { // play when the homescreen appears

    %orig;

    isHomescreenVisible = YES;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    [self adjustFrame];
    [playerHS play];

}

- (void)viewWillDisappear:(BOOL)animated { // pause when the homescreen disappears

    %orig;

    isHomescreenVisible = NO;
    [playerHS pause];

}

%new
- (void)adjustFrame { // adjust the frame
    
    [playerLayerHS setFrame:[[[self view] layer] bounds]];

}

%end

%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated { // pause when the lockscreen appears

    %orig;

    isLockscreenVisible = YES;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (isHomescreenVisible) [playerHS pause];

}

- (void)viewWillDisappear:(BOOL)animated { // play when the lockscreen disappears

    %orig;

    isLockscreenVisible = NO;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (isHomescreenVisible) [playerHS play];

}

%end

%hook SBControlCenterController

- (void)_willPresent { // pause when the control center appears

    %orig;

    isControlCenterVisible = YES;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (isHomescreenVisible) [playerHS pause];

}

%end

%hook CCUIModularControlCenterOverlayViewController

- (void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 { // pause when control center is being dismissed

    %orig;

    isControlCenterVisible = NO;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (isHomescreenVisible) [playerHS play];

}

%end

%end

%group ControlCenter

%hook CCUIModularControlCenterOverlayViewController

- (void)viewDidLoad { // add wallpaper to the control center

    %orig;

    // player
    NSURL* url = [GcImagePickerUtils videoURLFromDefaults:@"love.litten.enekopreferences" withKey:@"controlCenterWallpaper"];
    if (!url) return;

    playerItemCC = [AVPlayerItem playerItemWithURL:url];

    playerCC = [AVQueuePlayer playerWithPlayerItem:playerItemCC];
    playerCC.volume = controlCenterVolumeValue;
    [playerCC setPreventsDisplaySleepDuringVideoPlayback:NO];
    if (controlCenterVolumeValue == 0.0) [playerCC setMuted:YES];
    else [playerCC setVolume:controlCenterVolumeValue];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

    playerLooperCC = [AVPlayerLooper playerLooperWithPlayer:playerCC templateItem:playerItemCC];

    playerLayerCC = [AVPlayerLayer playerLayerWithPlayer:playerCC];
    [playerLayerCC setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [playerLayerCC setFrame:[[[self view] layer] bounds]];
    [playerLayerCC setOpacity:controlCenterOpacityValue];
    [[[self view] layer] insertSublayer:playerLayerCC atIndex:1];


    // dim and blur superview
    if (!dimBlurViewCC && (controlCenterBlurAmountValue != 0.0 || controlCenterDimValue != 0.0)) {
        dimBlurViewCC = [[UIView alloc] initWithFrame:[[self view] bounds]];
        [dimBlurViewCC setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [[self view] insertSubview:dimBlurViewCC atIndex:2];
    }

    // blur
    if (!blurCC && controlCenterBlurAmountValue != 0.0) {
        if (controlCenterBlurModeValue == 0)
            blurCC = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        else if (controlCenterBlurModeValue == 1)
            blurCC = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

        blurViewCC = [[UIVisualEffectView alloc] initWithEffect:blurCC];
        [blurViewCC setFrame:[dimBlurViewCC bounds]];
        [blurViewCC setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [blurViewCC setClipsToBounds:YES];
        [blurViewCC setAlpha:controlCenterBlurAmountValue];
        [dimBlurViewCC addSubview:blurViewCC];
    }

    // dim
    if (!dimViewCC && controlCenterDimValue != 0.0) {
        dimViewCC = [[UIView alloc] initWithFrame:[[self view] bounds]];
        [dimViewCC setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [dimViewCC setBackgroundColor:[UIColor blackColor]];
        [dimViewCC setAlpha:controlCenterDimValue];
        [dimBlurViewCC addSubview:dimViewCC];
    }

}

- (void)viewWillAppear:(BOOL)animated { // adjust the frame when control center appears

    %orig;

    isControlCenterVisible = YES;
    [self adjustFrame];

}

- (void)viewWillDisappear:(BOOL)animated { // pause when device respringed, for some reason it would play otherwise

    %orig;

    isControlCenterVisible = NO;
    [playerLayerCC setHidden:YES];
    if (dimBlurViewCC) [dimBlurViewCC setHidden:YES];
    [playerCC pause];

}

- (void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 { // pause when the control center is being dismissed

    %orig;

    isControlCenterVisible = NO;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    [playerLayerCC setHidden:YES];
    if (dimBlurViewCC) [dimBlurViewCC setHidden:YES];
    [playerCC pause];
    if (isLockscreenVisible && !isHomescreenVisible) {
        if (enableLockscreenWallpaperSwitch) [playerLS play];
        if (enableHomescreenWallpaperSwitch) [playerHS pause];
    } else if (!isLockscreenVisible && isHomescreenVisible) {
        if (enableHomescreenWallpaperSwitch) [playerHS play];
        if (enableLockscreenWallpaperSwitch) [playerLS pause];
    }

}

%new
- (void)adjustFrame { // adjust the frame
    
    [playerLayerCC setFrame:[[[self view] layer] bounds]];

}

%end

%hook SBControlCenterController

- (void)_willPresent { // play when the control center appears

    %orig;

    isControlCenterVisible = YES;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    [playerCC play];
    [playerLayerCC setHidden:NO];
    if (dimBlurViewCC) [dimBlurViewCC setHidden:NO];
    if (enableLockscreenWallpaperSwitch && isLockscreenVisible) [playerLS pause];
    else if (enableHomescreenWallpaperSwitch && isHomescreenVisible) [playerHS pause];

}

%end

%end

%group Eneko

%hook SBBacklightController

- (void)turnOnScreenFullyWithBacklightSource:(long long)arg1 { // play when the screen turned on

    %orig;

    screenIsOn = YES;
    if (!isLockscreenVisible) return;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (enableLockscreenWallpaperSwitch) [playerLS play];
    if (enableHomescreenWallpaperSwitch) [playerHS pause];
    if (enableControlCenterWallpaperSwitch) [playerCC pause];

}

%end

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 { // pause when the device was locked

    %orig;

    isLockscreenVisible = YES;
    screenIsOn = NO;
    if (enableLockscreenWallpaperSwitch) [playerLS pause];
    if (enableHomescreenWallpaperSwitch) [playerHS pause];
    if (enableControlCenterWallpaperSwitch) [playerCC pause];

}

%end

%hook SpringBoard

- (void)noteInterfaceOrientationChanged:(long long)arg1 duration:(double)arg2 logMessage:(id)arg3 { // send a notification to change the frame when the device was rotated

    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enekoRotateNotification" object:nil];
    });

}

%end

%hook SBMediaController

- (BOOL)isPlaying { // mute when music is playing

    if (lockscreenVolumeValue == 0.0 && homescreenVolumeValue == 0.0 && controlCenterVolumeValue == 0.0) return %orig;

    BOOL orig = %orig;

    if (orig) {
        if (enableLockscreenWallpaperSwitch && lockscreenVolumeValue != 0.0 && muteWhenMusicPlaysSwitch) [playerLS setVolume:0.0];
        if (enableHomescreenWallpaperSwitch && homescreenVolumeValue != 0.0 && muteWhenMusicPlaysSwitch) [playerHS setVolume:0.0];
        if (enableControlCenterWallpaperSwitch && controlCenterVolumeValue != 0.0 && muteWhenMusicPlaysSwitch) [playerCC setVolume:0.0];
    } else {
        if (enableLockscreenWallpaperSwitch && lockscreenVolumeValue != 0.0 && muteWhenMusicPlaysSwitch) [playerLS setVolume:lockscreenVolumeValue];
        if (enableHomescreenWallpaperSwitch && homescreenVolumeValue != 0.0 && muteWhenMusicPlaysSwitch) [playerHS setVolume:homescreenVolumeValue];
        if (enableControlCenterWallpaperSwitch && controlCenterVolumeValue != 0.0 && muteWhenMusicPlaysSwitch) [playerCC setVolume:controlCenterVolumeValue];
    }

    return orig;

}

%end

%hook TUCall

- (int)status { // pause when the user is getting a call and play when the call ends

    if (hideWhenLowPowerSwitch && isOnLowPower) return %orig;

    int orig = %orig;

    if (orig != 6) { // the user is in a call
        isInCall = YES;
        if (enableLockscreenWallpaperSwitch) [playerLS pause];
        if (enableHomescreenWallpaperSwitch) [playerHS pause];
        if (enableControlCenterWallpaperSwitch) [playerCC pause];
    } else if (orig == 6) { // the user is not in a call
        isInCall = NO;
        if (isLockscreenVisible && !isHomescreenVisible) {
            if (enableLockscreenWallpaperSwitch && screenIsOn) [playerLS play];
            if (enableHomescreenWallpaperSwitch) [playerHS pause];
        } else if (!isLockscreenVisible && isHomescreenVisible) {
            if (enableHomescreenWallpaperSwitch) [playerHS play];
            if (enableLockscreenWallpaperSwitch) [playerLS pause];
        }
        [playerCC pause];
    }

    return orig;

}

%end

%hook SiriUIBackgroundBlurView

- (void)removeFromSuperview { // play when siri was dismissed

    %orig;

    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;

    if (enableLockscreenWallpaperSwitch && isLockscreenVisible && !isHomescreenVisible) [playerLS play];
    else if (enableHomescreenWallpaperSwitch && isHomescreenVisible && !isLockscreenVisible) [playerHS play];
    [playerCC pause];

}

%end

%hook SBDashBoardCameraPageViewController

- (void)viewWillAppear:(BOOL)animated { // pause when the lockscreen camera appears

    %orig;

    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (enableLockscreenWallpaperSwitch && isLockscreenVisible) [playerLS pause];
    isLockscreenVisible = NO;

}

- (void)viewWillDisappear:(BOOL)animated { // play when the lockscreen camera disappears

    isLockscreenVisible = YES;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (enableLockscreenWallpaperSwitch && isLockscreenVisible) [playerLS play];

}

%end

%hook CSModalButton

- (void)didMoveToWindow { // pause when a alarm/timer fires

    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (enableLockscreenWallpaperSwitch) [playerLS pause];
        if (enableHomescreenWallpaperSwitch) [playerHS pause];
        if (enableControlCenterWallpaperSwitch) [playerCC pause];
    });

}

- (void)removeFromSuperview { // pause when a alarm/timer was dismissed

    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (enableLockscreenWallpaperSwitch && screenIsOn) [playerLS play];
        if (enableHomescreenWallpaperSwitch) [playerHS pause];
        if (enableControlCenterWallpaperSwitch) [playerCC pause];
    });

}

%end

%hook SBLockScreenEmergencyCallViewController

- (void)viewWillAppear:(BOOL)animated { // pause when emergency call pad appears

    %orig;

    isLockscreenVisible = NO;
    if (enableLockscreenWallpaperSwitch) [playerLS pause];

}

- (void)viewWillDisappear:(BOOL)animated { // play when emergency call pad disappears

    %orig;

    isLockscreenVisible = YES;
    if ((hideWhenLowPowerSwitch && isOnLowPower) || isInCall) return;
    if (enableLockscreenWallpaperSwitch) [playerLS play];

}

%end

%hook NSProcessInfo

- (BOOL)isLowPowerModeEnabled { // hide when the device is on low power mode

    if (!hideWhenLowPowerSwitch) return %orig;
    
    if (!supportsLowPowerMode) {
        isOnLowPower = NO;
        return %orig;
    }

    isOnLowPower = %orig;
    
    if (isOnLowPower) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (enableLockscreenWallpaperSwitch) {
                [playerLayerLS setHidden:YES];
                if (dimBlurViewLS) [dimBlurViewLS setHidden:YES];
                [playerLS pause];
            }
            if (enableHomescreenWallpaperSwitch) {
                [playerLayerHS setHidden:YES];
                if (dimBlurViewHS) [dimBlurViewHS setHidden:YES];
                [playerHS pause];
            }
            if (enableControlCenterWallpaperSwitch) {
                [playerLayerCC setHidden:YES];
                if (dimBlurViewCC) [dimBlurViewCC setHidden:YES];
                [playerCC pause];
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (enableLockscreenWallpaperSwitch && isLockscreenVisible && !isControlCenterVisible) [playerLS play];
            else if (enableHomescreenWallpaperSwitch && isHomescreenVisible && !isControlCenterVisible) [playerHS play];
            else if (enableControlCenterWallpaperSwitch && isControlCenterVisible) [playerCC play];
            [playerLayerLS setHidden:NO];
            [playerLayerHS setHidden:NO];
            [playerLayerCC setHidden:NO];
            if (dimBlurViewLS) [dimBlurViewLS setHidden:NO];
            if (dimBlurViewHS) [dimBlurViewHS setHidden:NO];
        });
    }

    return isOnLowPower;

}

%end

%end

%ctor {

    preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.enekopreferences"];

    [preferences registerBool:&enabled default:YES forKey:@"enabled"];
    if (!enabled) return;

    // lockscreen
    [preferences registerBool:&enableLockscreenWallpaperSwitch default:NO forKey:@"enableLockscreenWallpaper"];
    if (enableLockscreenWallpaperSwitch) {
        [preferences registerDouble:&lockscreenVolumeValue default:0.0 forKey:@"lockscreenVolume"];
        [preferences registerDouble:&lockscreenBlurAmountValue default:0.0 forKey:@"lockscreenBlurAmount"];
        [preferences registerUnsignedInteger:&lockscreenBlurModeValue default:0 forKey:@"lockscreenBlurMode"];
        [preferences registerDouble:&lockscreenDimValue default:0.0 forKey:@"lockscreenDim"];
        [preferences registerDouble:&lockscreenOpacityValue default:1.0 forKey:@"lockscreenOpacity"];
    }

    // homescreen
    [preferences registerBool:&enableHomescreenWallpaperSwitch default:NO forKey:@"enableHomescreenWallpaper"];
    if (enableHomescreenWallpaperSwitch) {
        [preferences registerDouble:&homescreenVolumeValue default:0.0 forKey:@"homescreenVolume"];
        [preferences registerDouble:&homescreenBlurAmountValue default:0.0 forKey:@"homescreenBlurAmount"];
        [preferences registerUnsignedInteger:&homescreenBlurModeValue default:0 forKey:@"homescreenBlurMode"];
        [preferences registerDouble:&homescreenDimValue default:0.0 forKey:@"homescreenDim"];
        [preferences registerDouble:&homescreenOpacityValue default:1.0 forKey:@"homescreenOpacity"];
    }

    // control center
    [preferences registerBool:&enableControlCenterWallpaperSwitch default:NO forKey:@"enableControlCenterWallpaper"];
    if (enableControlCenterWallpaperSwitch) {
        [preferences registerDouble:&controlCenterVolumeValue default:0.0 forKey:@"controlCenterVolume"];
        [preferences registerDouble:&controlCenterBlurAmountValue default:0.0 forKey:@"controlCenterBlurAmount"];
        [preferences registerUnsignedInteger:&controlCenterBlurModeValue default:0 forKey:@"controlCenterBlurMode"];
        [preferences registerDouble:&controlCenterDimValue default:0.0 forKey:@"controlCenterDim"];
        [preferences registerDouble:&controlCenterOpacityValue default:1.0 forKey:@"controlCenterOpacity"];
    }

    // miscellaneous
    [preferences registerBool:&muteWhenMusicPlaysSwitch default:YES forKey:@"muteWhenMusicPlays"];
    [preferences registerBool:&hideWhenLowPowerSwitch default:YES forKey:@"hideWhenLowPower"];

    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceModel containsString:@"iPhone"]) supportsLowPowerMode = YES;

    if (enableLockscreenWallpaperSwitch) %init(Lockscreen);
    if (enableHomescreenWallpaperSwitch) %init(Homescreen);
    if (enableControlCenterWallpaperSwitch) %init(ControlCenter);
    if (enableLockscreenWallpaperSwitch || enableHomescreenWallpaperSwitch || enableControlCenterWallpaperSwitch) %init(Eneko);

}
