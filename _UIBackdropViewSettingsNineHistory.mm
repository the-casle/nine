#include "headers.h"

#import <substrate.h>
#import "_UIBackdropViewSettingsNineHistory.h"

#ifndef SIMULATOR
#import <Cephei/HBPreferences.h>
#endif

static NSNumber *blurValueHistory;
static NSNumber *darkeningValueHistory;
static NSNumber *saturationValueHistory;
static UIColor *notificationCenterColoring;

static NSString *notifHex;

//----------------------------------------------------------------
@implementation _UIBackdropViewSettingsNineHistory

- (instancetype) init{
    if(self = [super init]){
        
        #ifndef SIMULATOR
        // load preferences
        HBPreferences *settings = [[HBPreferences alloc] initWithIdentifier:@"com.thecasle.nineprefs"];
        [settings registerDefaults:@{
                                     @"historyBlurValue": @20,
                                     @"historyDarkeningValue":@4,
                                     @"historySaturationValue":@12,
                                     }];
        
        [settings registerObject:&notifHex default:@"#000000" forKey: @"notificationCenterColors"];
        notificationCenterColoring = LCPParseColorString(notifHex, @"#000000");
        
        blurValueHistory = [NSNumber numberWithDouble: [settings doubleForKey:@"historyBlurValue"]];
        darkeningValueHistory = [NSNumber numberWithDouble: ([settings doubleForKey:@"historyDarkeningValue"] * .1)];
        saturationValueHistory = [NSNumber numberWithDouble: ([settings doubleForKey:@"historySaturationValue"] * .1)];
        #else
        notifHex = nil;
        notificationCenterColoring = [UIColor blackColor];
        blurValueHistory = [NSNumber numberWithDouble:20];
        darkeningValueHistory = [NSNumber numberWithDouble:.4];
        saturationValueHistory = [NSNumber numberWithDouble:1.2];
        #endif
        
        //self = [[objc_getClass("_UIBackdropViewSettingsBlur") alloc] init];
        
        [self setDefaultValues];
        //self = [objc_getClass("_UIBackdropViewSettingsNone") settingsForPrivateStyle:1];
    }
    return self;
}
-(void)setDefaultValues{
    
    self.appliesTintAndBlurSettings = YES;
    self.scale = (saturationValueHistory.doubleValue >= 5) ? .25 : 1;
    self.usesBackdropEffectView = YES;
    self.backdropVisible = YES;
    self.filterMaskAlpha = 1;
    self.legibleColor = [UIColor whiteColor];
    self.enabled = YES;
    self.usesContentView = YES;
    self.saturationDeltaFactor = saturationValueHistory.doubleValue;
    
    self.blurRadius = blurValueHistory.doubleValue;
    self.blurQuality = @"default";
    
    self.darkeningTintBrightness = .64;
    self.darkeningTintHue = .619;
    self.darkeningTintSaturation = .2;
    self.darkeningTintAlpha = .2;
    self.usesDarkeningTintView = YES;
    
    self.grayscaleTintMaskAlpha = 1;
    
    self.usesColorTintView = YES;
    self.colorTint = notificationCenterColoring;
    self.colorTintMaskAlpha = 1;
    self.colorTintAlpha = darkeningValueHistory.doubleValue;
}
@end
