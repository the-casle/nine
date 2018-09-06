#include "headers.h"

#import <substrate.h>
#import "_UIBackdropViewSettingsNineHistory.h"
#import <Cephei/HBPreferences.h>

static NSNumber *blurValueHistory;
static NSNumber *darkeningValueHistory;
static UIColor *notificationCenterColoring;


//----------------------------------------------------------------
@implementation _UIBackdropViewSettingsNineHistory

- (instancetype) init{
    if(self = [super init]){
        // load preferences
        HBPreferences *settings = [[HBPreferences alloc] initWithIdentifier:@"com.thecasle.nineprefs"];
        HBPreferences *colorSettings = [[HBPreferences alloc] initWithIdentifier:@"com.thecasle.nineprefs.color"];
        [settings registerDefaults:@{
                                     @"historyBlurValue": @20,
                                     @"historyDarkeningValue":@4,
                                     }];
        blurValueHistory = [NSNumber numberWithDouble: [settings doubleForKey:@"historyBlurValue"]];
        darkeningValueHistory = [NSNumber numberWithDouble: ([settings doubleForKey:@"historyDarkeningValue"] * .1)];

        notificationCenterColoring = LCPParseColorString([colorSettings objectForKey:@"notificationCenterColors"], @"#000000");
        NSLog(@"nine_TWEAK | %@ and %@", notificationCenterColoring, [colorSettings objectForKey:@"notificationCenterColors"]);
        //notificationCenterColoring = [UIColor blackColor];
        
        //self = [[objc_getClass("_UIBackdropViewSettingsBlur") alloc] init];
        
        [self setDefaultValues];
        //self = [objc_getClass("_UIBackdropViewSettingsNone") settingsForPrivateStyle:1];
    }
    return self;
}
-(void)setDefaultValues{
    
    self.appliesTintAndBlurSettings = YES;
    self.scale = .25;
    self.usesBackdropEffectView = YES;
    self.backdropVisible = YES;
    self.filterMaskAlpha = 1;
    self.legibleColor = [UIColor whiteColor];
    self.enabled = YES;
    self.usesContentView = YES;
    self.saturationDeltaFactor = 1.25;
    
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
