#include "headers.h"

#import <substrate.h>
#import "_UIBackdropViewSettingsNineLock.h"

#ifndef SIMULATOR
#import <Cephei/HBPreferences.h>
#endif

static NSNumber *blurValueGeneral;
static NSNumber *darkeningValueGeneral;
static NSNumber *saturationValueGeneral;
static UIColor *lockscreenColoring;

static NSString *lockHex;

//----------------------------------------------------------------
@implementation _UIBackdropViewSettingsNineLock

- (instancetype) init{
    if(self = [super init]){
        // load preferences
        
        #ifndef SIMULATOR
        HBPreferences *settings = [[HBPreferences alloc] initWithIdentifier:@"com.thecasle.nineprefs"];
        [settings registerDefaults:@{
                                     @"generalBlurValue": @12,
                                     @"generalDarkeningValue":@1,
                                     @"generalSaturationValue":@12,
                                     }];
        [settings registerObject:&lockHex default:@"#000000" forKey: @"lockscreenColors"];
        
        lockscreenColoring = LCPParseColorString(lockHex, @"#000000");
        
        blurValueGeneral = [NSNumber numberWithDouble: [settings doubleForKey:@"generalBlurValue"]];
        darkeningValueGeneral = [NSNumber numberWithDouble: ([settings doubleForKey:@"generalDarkeningValue"] * .1)];
        saturationValueGeneral = [NSNumber numberWithDouble: ([settings doubleForKey:@"generalSaturationValue"] * .1)];
        
        #else
        lockHex = nil;
        lockscreenColoring = [UIColor blackColor];
        blurValueGeneral = [NSNumber numberWithDouble:12];
        darkeningValueGeneral = [NSNumber numberWithDouble:.1];
        saturationValueGeneral = [NSNumber numberWithDouble: 1.2];
        #endif
        
        //self = [[objc_getClass("_UIBackdropViewSettingsBlur") alloc] init];
        
        [self setDefaultValues];
        //self = [objc_getClass("_UIBackdropViewSettingsNone") settingsForPrivateStyle:1];
    }
    return self;
}
-(void)setDefaultValues{
    
    self.appliesTintAndBlurSettings = YES;
    self.scale = (saturationValueGeneral.doubleValue >= 5) ? .25 : 1;
    self.usesBackdropEffectView = YES;
    self.backdropVisible = YES;
    self.filterMaskAlpha = 1;
    self.legibleColor = [UIColor whiteColor];
    self.enabled = YES;
    self.usesContentView = YES;
    self.saturationDeltaFactor = saturationValueGeneral.doubleValue;
    
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
