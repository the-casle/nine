#include "headers.h"

#import <substrate.h>
#import "TCBackgroundViewController.h"
#import <Cephei/HBPreferences.h>

NSUInteger alphaOfBackground = 0;


static BOOL enabledLockBackground;
static BOOL disableBlurIcons;
static BOOL alwaysBlurEnabled;
static NSNumber *blurValueHistory;
static NSNumber *blurValueGeneral;
static NSNumber *darkeningValueHistory;
static NSNumber *darkeningValueGeneral;

//----------------------------------------------------------------

extern BOOL isOnLockscreen();
extern BOOL isUILocked();
static id _instance;

@implementation TCBackgroundViewController {
    SBUIController *_sbCont;
    SBWallpaperController *_sbWallCont;
    SBIconContentView *_iconContentView;
}

- (instancetype) init{
    if(self = [super init]){
        CGRect frame = UIScreen.mainScreen.bounds;
        frame.size.width = (frame.size.width > frame.size.height) ? frame.size.width : frame.size.height;
        frame.size.height = (frame.size.width > frame.size.height) ? frame.size.width : frame.size.height;
        //frame.origin.y = -100;

        CGRect screenFrame = UIScreen.mainScreen.bounds;

        _sbCont = [objc_getClass("SBUIController") sharedInstance];
        _sbWallCont = [objc_getClass("SBWallpaperController") sharedInstance];
        
        
        // load preferences
        HBPreferences *settings = [[HBPreferences alloc] initWithIdentifier:@"com.thecasle.nineprefs"];
        [settings registerDefaults:@{
                                     @"lockBackgroundEnabled": @NO,
                                     @"iconBackgroundDisabled": @NO,
                                     @"enableAlwaysBlur": @NO,
                                     @"historyBlurValue": @20,
                                     @"generalBlurValue": @20,
                                     @"generalDarkeningValue":@1,
                                     @"historyDarkeningValue":@3,
                                     }];
        enabledLockBackground = [settings boolForKey:@"lockBackgroundEnabled"];
        disableBlurIcons = [settings boolForKey:@"iconBackgroundDisabled"];
        alwaysBlurEnabled = [settings boolForKey:@"enableAlwaysBlur"];
        blurValueHistory = [NSNumber numberWithDouble: [settings doubleForKey:@"historyBlurValue"]];
        blurValueGeneral = [NSNumber numberWithDouble: [settings doubleForKey:@"generalBlurValue"]];
        darkeningValueHistory = [NSNumber numberWithDouble: ([settings doubleForKey:@"historyDarkeningValue"] * .1)];
        darkeningValueGeneral = [NSNumber numberWithDouble: ([settings doubleForKey:@"generalDarkeningValue"] * .1)];
        
        
        
        if(!self.view){
            self.view = [[UIView alloc] initWithFrame:screenFrame];
        }
        
        if(!self.blurView){
            self.blurView = [[UIView alloc] initWithFrame:frame];
            [self.view addSubview:self.blurView];
        }
        if(!self.blurImgView){
            self.blurImgView = [[UIImageView alloc] initWithFrame:frame];
            [self.blurView addSubview:self.blurImgView];
        }
        if(!self.iconImgView){
            self.iconImgView = [[UIImageView alloc] initWithFrame:frame];
            [self.blurView addSubview:self.iconImgView];
        }
        
        if(!self.blurHistoryEffectView){
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:blurValueHistory.doubleValue];
            self.blurHistoryEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            self.blurHistoryEffectView.frame = frame;
            self.blurHistoryEffectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:darkeningValueHistory.doubleValue];
            
            self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [self.blurView addSubview:self.blurHistoryEffectView];
        }
        
        
        if(!self.blurEffectView){
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:blurValueGeneral.doubleValue];
            self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            self.blurEffectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:darkeningValueGeneral.doubleValue];
            self.blurEffectView.frame = frame;
            self.blurEffectView.alpha = 0;
            
            self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [self.view addSubview:self.blurEffectView];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveAdjustAlpha:) name:@"alphaReceived" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSceenShot:) name:@"updateTCBackgroundBlur" object:nil];
        
    }
    if (_instance == nil) _instance = self;
    return self;
}


+ (id) sharedInstance {
    if (!_instance) return [[TCBackgroundViewController alloc] init];
    return _instance;
}

-(void) updateSceenShot: (NSNotification *)notification {
    NSDictionary* userInfo = notification.userInfo;
    NSNumber* content = (NSNumber*)userInfo[@"content"];
    NSNumber *isHistoryRevealed = userInfo[@"history"];
    
    if(content.intValue > 0 && [isHistoryRevealed boolValue] == 1){
        if(self.blurView.alpha == 0){
            [UIView animateWithDuration:.5
                                  delay:.2
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{self.blurView.alpha = 1;}
                             completion:nil];
        } else {
            self.blurView.alpha = 1;
        }
    } else {
        if(self.blurView.alpha == 1){
            [UIView animateWithDuration:.4
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{self.blurView.alpha = 0;}
                             completion:nil];
        } else {
            self.blurView.alpha = 0;
        }
    }
    if(content.intValue > 0 && [isHistoryRevealed boolValue] == 1){
        if(self.iconImgView.alpha == 0){
            [UIView animateWithDuration:.5
                                  delay:.2
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{self.iconImgView.alpha = 1;}
                             completion:nil];
        } else {
            self.iconImgView.alpha = 1;
        }
    } else {
        if(self.iconImgView.alpha == 1){
            [UIView animateWithDuration:.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{self.iconImgView.alpha = 0;}
                             completion:nil];
        } else {
            self.iconImgView.alpha = 0;
        }
    }
    if(![_sbCont isIconListViewTornDown] && [_sbWallCont.homescreenStyleInfo.description containsString:@"Normal"]){
        if(disableBlurIcons == NO){
            UIImage *iconImg = [MSHookIvar<SBIconContentView *>(_sbCont, "_iconsView") sb_snapshotImage];
            self.iconImgView.image = iconImg;
        }
    }
}

-(void) recieveAdjustAlpha:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;
    NSNumber* content = (NSNumber*)userInfo[@"content"];
    NSLog(@"nine_TWEAK recieveAdjustAlpha, with content: %d", content.intValue);
    
    if(alwaysBlurEnabled || !isOnLockscreen()){
        content = [NSNumber numberWithInt:1];
    }
    
    if(content.intValue > 0){
        if(self.blurEffectView.alpha == 0){
            [UIView animateWithDuration:0.5 animations:^{
                self.blurEffectView.alpha = 1;
            }];
        } else {
            self.blurEffectView.alpha = 1;
        }
    } else {
        if(self.blurEffectView.alpha == 1){
            [UIView animateWithDuration:0.5 animations:^{
                self.blurEffectView.alpha = 0;
            }];
        } else {
            self.blurEffectView.alpha = 0;
        }
    }
    alphaOfBackground = self.blurEffectView.alpha;
    if([_sbWallCont.homescreenStyleInfo.description containsString:@"Normal"]){
        if(enabledLockBackground == YES){
            self.blurImgView.hidden = YES;
        }
    }
}
@end
