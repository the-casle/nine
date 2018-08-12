#include "headers.h"

#import <substrate.h>
#import "TCBackgroundViewController.h"
#import <Cephei/HBPreferences.h>

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
}

- (instancetype) init{
    if(self = [super init]){
        CGRect frame = UIScreen.mainScreen.bounds;
        frame.size.width = (frame.size.width > frame.size.height) ? frame.size.width : frame.size.height;
        frame.size.height = (frame.size.width > frame.size.height) ? frame.size.width : frame.size.height;
        //frame.origin.y = -100;

        CGRect screenFrame = UIScreen.mainScreen.bounds;

        _sbCont = [objc_getClass("SBUIController") sharedInstance];
        
        
        // load preferences
        HBPreferences *settings = [[HBPreferences alloc] initWithIdentifier:@"com.thecasle.nineprefs"];
        [settings registerDefaults:@{
                                     @"enableAlwaysBlur": @NO,
                                     @"historyBlurValue": @15,
                                     @"generalBlurValue": @12,
                                     @"generalDarkeningValue":@2,
                                     @"historyDarkeningValue":@6,
                                     }];
        alwaysBlurEnabled = [settings boolForKey:@"enableAlwaysBlur"];
        blurValueHistory = [NSNumber numberWithDouble: [settings doubleForKey:@"historyBlurValue"]];
        blurValueGeneral = [NSNumber numberWithDouble: [settings doubleForKey:@"generalBlurValue"]];
        darkeningValueHistory = [NSNumber numberWithDouble: ([settings doubleForKey:@"historyDarkeningValue"] * .1)];
        darkeningValueGeneral = [NSNumber numberWithDouble: ([settings doubleForKey:@"generalDarkeningValue"] * .1)];
        

        if(!self.view){
            self.view = [[UIView alloc] initWithFrame:screenFrame];
        }
        
        // Hold both of the blurs
        if(!self.blurView){
            self.blurView = [[UIView alloc] initWithFrame:frame];
            [self.view addSubview:self.blurView];
        }
        
        // NC blur
        if(!self.blurHistoryEffectView){
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:blurValueHistory.doubleValue];
            self.blurHistoryEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            self.blurHistoryEffectView.frame = frame;
            self.blurHistoryEffectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:darkeningValueHistory.doubleValue];
            
            self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [self.blurView addSubview:self.blurHistoryEffectView];
        }
        
        // lockscreen blur
        if(!self.blurEffectView){
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:blurValueGeneral.doubleValue];
            self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            self.blurEffectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:darkeningValueGeneral.doubleValue];
            self.blurEffectView.frame = frame;
            self.blurEffectView.alpha = 0;
            
            self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [self.view addSubview:self.blurEffectView];
        }
        
    }
    if (_instance == nil) _instance = self;
    return self;
}


+ (id) sharedInstance {
    if (!_instance) return [[TCBackgroundViewController alloc] init];
    return _instance;
}
-(void) updateSceenShot: (BOOL)content isRevealed: (BOOL)isHistoryRevealed {
    
    // forces the blur always enabled
    if(alwaysBlurEnabled || !isOnLockscreen()){
        content = YES;
    }
    if(isOnLockscreen()){
        isHistoryRevealed = NO;
    }

    if(content == YES && isHistoryRevealed == YES){
        [UIView animateWithDuration:.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{self.blurHistoryEffectView.alpha = 1;}
                         completion:nil];
        [UIView animateWithDuration:.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{self.blurEffectView.alpha = 0;}
                         completion:nil];
    } else if(content == YES && isHistoryRevealed == NO){
        [UIView animateWithDuration:1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{self.blurEffectView.alpha = 1;}
                         completion:nil];
        [UIView animateWithDuration:.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{self.blurHistoryEffectView.alpha = 0;}
                         completion:nil];
    } else {
        [UIView animateWithDuration:.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{self.blurHistoryEffectView.alpha = 0;}
                         completion:nil];
        [UIView animateWithDuration:.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{self.blurEffectView.alpha = 0;}
                         completion:nil];
    }
}
@end
