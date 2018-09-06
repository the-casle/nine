#include "headers.h"

#import <substrate.h>
#import "_UIBackdropViewSettingsNineLock.h"
#import <Cephei/HBPreferences.h>

static NSNumber *blurValueGeneral;
static NSNumber *darkeningValueGeneral;
static UIColor *lockscreenColoring;


//----------------------------------------------------------------
@implementation _UIBackdropViewSettingsNineLock

- (instancetype) init{
    if(self = [super init]){
        // load preferences
        HBPreferences *settings = [[HBPreferences alloc] initWithIdentifier:@"com.thecasle.nineprefs"];
        [settings registerDefaults:@{
                                     @"generalBlurValue": @12,
                                     @"generalDarkeningValue":@1,
                                     }];
        blurValueGeneral = [NSNumber numberWithDouble: [settings doubleForKey:@"generalBlurValue"]];
        darkeningValueGeneral = [NSNumber numberWithDouble: ([settings doubleForKey:@"generalDarkeningValue"] * .1)];
        lockscreenColoring = LCPParseColorString([settings objectForKey:@"lockscreenColors"], @"#000000");
        //lockscreenColoring = [UIColor blackColor];
        
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
    
    self.blurRadius = blurValueGeneral.doubleValue;
    self.blurQuality = @"default";
    
    self.darkeningTintBrightness = .64;
    self.darkeningTintHue = .619;
    self.darkeningTintSaturation = .2;
    self.darkeningTintAlpha = .2;
    self.usesDarkeningTintView = NO;
    
    self.grayscaleTintMaskAlpha = 1;
    
    self.usesColorTintView = YES;
    self.colorTint = lockscreenColoring;
    self.colorTintMaskAlpha = 1;
    self.colorTintAlpha = darkeningValueGeneral.doubleValue;
}
@end
