#include "headers.h"
#import "TCBackgroundViewController.h"
#import <Cephei/HBPreferences.h>


static BOOL enableBanners;
static BOOL enableHeaders;
static BOOL enableExtend;
static BOOL enableGrabber;
static BOOL enableIconRemove;
static BOOL enableColorCube;
static BOOL enableBannerSection;
static BOOL enableClearBackground;
static BOOL enableSeparators;

// palette
static BOOL paletteEnabled;


// Data required for the isOnLockscreen() function
BOOL isUILocked() {
    long count = [[[%c(SBFPasscodeLockTrackerForPreventLockAssertions) sharedInstance] valueForKey:@"_assertions"] count];
    if (count == 0) return YES; // array is empty
    if (count == 1) {
        if ([[[[[[%c(SBFPasscodeLockTrackerForPreventLockAssertions) sharedInstance] valueForKey:@"_assertions"] allObjects] objectAtIndex:0] identifier] isEqualToString:@"UI unlocked"]) return NO; // either device is unlocked or an app is opened (from the ones allowed on lockscreen). Luckily system gives us enough info so we can tell what happened
        else return YES; // if there are more than one should be safe enough to assume device is unlocked
    }
    else return NO;
}

static BOOL isOnCoverSheet; // the data that needs to be analyzed

BOOL isOnLockscreen() {
    //NSLog(@"nine_TWEAK | %d", isOnCoverSheet);
    if(isUILocked()){
        isOnCoverSheet = YES; // This is used to catch an exception where it was locked, but it the isOnCoverSheet didnt update to reflect.
        return YES;
    }
    else if(!isUILocked() && isOnCoverSheet == YES) return YES;
    else if(!isUILocked() && isOnCoverSheet == NO) return NO;
    else return NO;
}

static id _instance;
static id _instanceController;
static id _lockGlyph;
static id _container;
//static id _envWindow = nil;

%hook SBFPasscodeLockTrackerForPreventLockAssertions
- (id) init {
    if (_instance == nil) _instance = %orig;
    else %orig; // just in case it needs more than one instance
    return _instance;
}

%new
// add a shared instance so we can use it later
+ (id) sharedInstance {
    if (!_instance) return [[%c(SBFPasscodeLockTrackerForPreventLockAssertions) alloc] init];
    return _instance;
}
%end

// Setting isOnCoverSheet properly, actually works perfectly
%hook SBCoverSheetSlidingViewController
- (void)_finishTransitionToPresented:(_Bool)arg1 animated:(_Bool)arg2 withCompletion:(id)arg3 {
    if((arg1 == 0) && ([self dismissalSlidingMode] == 1)){
        if(!isUILocked()) isOnCoverSheet = NO;
    } else if ((arg1 == 1) && ([self dismissalSlidingMode] == 1)){
        if(isUILocked()) isOnCoverSheet = YES;
    }
    %orig;
}
%end
// end of data required for the isOnLockscreen() function

%group ClearBackground
%hook SBCoverSheetUnlockedEnvironmentHostingWindow
// makes the cover sheet transparent
/*
-(id) init{
    if((self = %orig)){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideCoverSheetNotification:) name:@"SBCoverSheetWillDismissNotification" object:nil];
    }
    return self;
}
 */
-(void)setHidden:(BOOL)arg1 {
    if (isOnLockscreen()) %orig;
    else %orig(NO);
        //NSLog(@"nine_TWEAK setting hidden");
}
/*
-(BOOL)hidden {
    return (isOnLockscreen()) ? %orig : NO;
}
*/
-(void)layoutSubviews {
    %orig;
    //if (!_envWindow) _envWindow = self; // save instance
    //self.hidden = (isOnLockscreen()) ? NO : YES;
}
/*
%new
-(void) willHideCoverSheetNotification: (NSNotification *)notification {
    if (_envWindow){
        ((UIWindow*)_envWindow).hidden = NO;
    }

}
*/
%end

%hook SBCoverSheetSlidingViewController
- (long long)dismissalSlidingMode {
    if(isUILocked())[[objc_getClass("SBWallpaperController") sharedInstance] setVariant:0];
    if(!isOnLockscreen())[[%c(SBWallpaperController) sharedInstance] setVariant:1];
    
    //NSLog(@"nine_TWEAK | updating info %i with %i", isOnLockscreen(), isOnCoverSheet);
    if(isOnLockscreen()){
        ((UIView*)[%c(SBCoverSheetPanelBackgroundContainerView) sharedInstance]).alpha = 1;
        if([[%c(SBCoverSheetUnlockedEnvironmentHostingViewController) sharedInstance] respondsToSelector:@selector(maskingView)])((SBCoverSheetUnlockedEnvironmentHostingViewController *)[%c(SBCoverSheetUnlockedEnvironmentHostingViewController) sharedInstance]).maskingView.hidden = NO; /*This is 11.1 only I believe*/
    } else if(!isOnLockscreen()){
        [UIView animateWithDuration:.2
                              delay:.3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{((UIView*)[%c(SBCoverSheetPanelBackgroundContainerView) sharedInstance]).alpha = 0;}
                         completion:^(BOOL finished){
                             if([[%c(SBCoverSheetUnlockedEnvironmentHostingViewController) sharedInstance] respondsToSelector:@selector(maskingView)])((SBCoverSheetUnlockedEnvironmentHostingViewController *)[%c(SBCoverSheetUnlockedEnvironmentHostingViewController) sharedInstance]).maskingView.hidden = YES; /*This is 11.1 only I believe*/
                         }];
    }
    return %orig;
}
%end

%hook SBCoverSheetPanelBackgroundContainerView
// removes the animation when opening cover sheet
-(id) init{
    if (_container == nil) _container = %orig;
        else %orig; // just in case it needs more than one instance
    return _container;
}
%new
// add a shared instance so we can use it later
+ (id) sharedInstance {
    if (!_container) return [[%c(SBCoverSheetUnlockedEnvironmentHostingViewController) alloc] init];
    return _container;
}
%end

%hook SBWallpaperController
-(void)setVariant:(long long) arg1 {
    //NSLog(@"nine_TWEAK %d", (int)isOnLockscreen());
    if(!isOnLockscreen()) {
        %orig(1);
    } else {
        %orig;
    }
}
%end

// The controller for the window
%hook SBCoverSheetUnlockedEnvironmentHostingViewController
-(id) init{
    if (_instanceController == nil) _instanceController = self;
        else %orig; // just in case it needs more than one instance
    return _instanceController;
}

%new
// add a shared instance so we can use it later
+ (id) sharedInstance {
    if (!_instanceController) return [[%c(SBCoverSheetUnlockedEnvironmentHostingViewController) alloc] init];
    return _instanceController;
}
%end
%end // end ClearBackground group

%hook NCNotificationListSectionRevealHintView
// bigger "No Older Notifications" text
-(void)layoutSubviews {
    %orig;
    MSHookIvar<UILabel *>(self, "_revealHintTitle").font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
}
%end

// Hiding the dumb action buttons when in nc
%hook SBDashBoardQuickActionsViewController
-(void) _updateState {
    %orig;
    if(!isOnLockscreen()) ((UIView *)self.view).hidden = YES;
    else ((UIView *)self.view).hidden = NO;
}
%end


%hook NCNotificationListCollectionView
-(void) setMinimumContentOffset:(NSPoint) insets {
    /*
    if(!isOnLockscreen()){
        insets.y = -205;
        %orig(insets);
    } else %orig;*/
}
%end

%hook SBFLockScreenDateView
// hide clock && lockglyph && update wallpaper && update envwindow
-(void)layoutSubviews {
    %orig;
    //NSLog(@"nine_TWEAK active: %i visible: %i",[[%c(SBLockScreenManager) sharedInstance] isLockScreenActive], [[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible]);
    if (!isOnLockscreen()) {
        /*[UIView animateWithDuration:.5
                              delay:.2
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{((UIView*)self).alpha = 0;}
                         completion:nil];*/
        //((UIView*)self).hidden = YES; // maybe make this optional?
        //if (_lockGlyph) ((UIView*)_lockGlyph).hidden = YES;
        /*
        if (_envWindow){
            ((UIWindow*)_envWindow).hidden = NO;
            
        }
        */
    }
    else {
        ((UIView*)self).alpha = 1;
        //[[%c(SBWallpaperController) sharedInstance] setVariant:0];
        //if (_lockGlyph) ((UIView*)_lockGlyph).hidden = NO;
        
    }
}
%end

%hook PKFingerprintGlyphView
// keep an instance of lockglpyh and hide it later in a method that gets called when it shows
-(id)init {
    if (!_lockGlyph) {
        _lockGlyph = %orig;
        return _lockGlyph;
    }
    return %orig;
}
%end

%hook SBDashBoardWallpaperEffectView
// removes the wallpaper view when opening camera
// checks if the blur is visible when applying the new animation
-(void)layoutSubviews {
    %orig;
    if (((SBDashBoardViewController *)((UIView *)self).superview/* some touch thingy */.superview/* SBDashBoardView */._viewDelegate/* SBDashBoardViewController */).backgroundCont/* TCBackgroundController */.blurEffectView.alpha != 0 || ((SBDashBoardViewController *)((UIView *)self).superview/* some touch thingy */.superview/* SBDashBoardView */._viewDelegate/* SBDashBoardViewController */).backgroundCont/* TCBackgroundController */.blurHistoryEffectView.alpha != 0) ((UIView*)self).hidden = YES;
    else ((UIView*)self).hidden = NO;
}
%end

%hook NCNotificationCombinedListViewController
-(BOOL)hasContent{
    BOOL content = %orig;
    // Sending values to the background controller
    [[TCBackgroundViewController sharedInstance] updateSceenShot: content isRevealed: ((!isOnLockscreen()) ? YES : self.isShowingNotificationsHistory)]; // NC is never set to lock
    return content;

}
%end
/*
%hook WGWidgetHostingViewController
-(id)widgetInfo{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    //if(alphaOfBackground != vale){
        NSDictionary* userInfo = @{@"content": @(self.activeDisplayMode)};
        [nc postNotificationName:@"alphaReceived" object:self userInfo:userInfo];
        NSLog(@"nine_TWEAK posting content notification");
        
    //}
    
    return %orig;
}
%end

%hook WGWidgetPlatterView
-(void) layoutSubviews{
    %orig;
    MSHookIvar<MTMaterialView *>(self, "_backgroundView").hidden = true;
    MSHookIvar<MTMaterialView *>(self, "_mainOverlayView").hidden = true;
}
%end
*/
/*
%hook SBPagedScrollView
-(void) setFrame:(CGRect) frame{
    frame.origin.y = -175;
    frame.size.height += 175;
    %orig(frame);
}
%end

%hook NCNotificationListCollectionView
-(void) setFrame:(CGRect) frame{
    frame.size.height += 175;
    %orig(frame);
}
%end
*/
%hook SBDashBoardViewController
%property (nonatomic, retain) TCBackgroundViewController *backgroundCont;
-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2{
    if((self = %orig)){
        self.backgroundCont = [TCBackgroundViewController sharedInstance];
    }
    return self;
}
-(void)loadView{
    %orig;
    [((SBDashBoardView *)self.view).backgroundView addSubview: self.backgroundCont.view];
    //NSLog(@"nine_TWEAK | %@",self.backgroundCont);
}
%end
/*
%hook SBCoverSheetPositionView
-(void) layoutSubviews {
    %orig;
    [self contentView].clipsToBounds = NO;
}
%end

%hook SBUIBackgroundView
-(void) setFrame:(CGRect) rect {
    rect.origin.y -= 40;
    rect.size.height += 40;
    %orig(rect);
    
}
%end
*/


 // Used to prevent spam;
%hook NCNotificationCombinedListViewController
-(void) _updatePrioritySectionLowestPosition{
    static NSNumber *priorityQuickCheck;
    %orig;
    if(priorityQuickCheck.doubleValue != self.prioritySectionLowestPosition && enableSeparators){
        for(NCNotificationListCell *cell in self.collectionView.visibleCells){
            NCNotificationShortLookView *shortView = ((NCNotificationShortLookView *)((_NCNotificationViewControllerView *)cell.contentViewController.view).contentView);
            if([shortView isKindOfClass:%c(NCNotificationShortLookView)] && [shortView respondsToSelector:@selector(tcUpdateTopLine)]){
                [shortView tcUpdateTopLine];
            }
            
        }
        priorityQuickCheck = [NSNumber numberWithDouble:self.prioritySectionLowestPosition];
    }
}
%end

%hook NCNotificationShortLookView
%property (nonatomic, retain) _UITableViewCellSeparatorView *singleLine;
%property (nonatomic, retain) _UITableViewCellSeparatorView *topLine;
%property (nonatomic, retain) UIVisualEffectView *notifEffectView;

-(void) layoutSubviews{
    %orig;
    // banner check, took a while to get right
    
    //if([[[self _viewControllerForAncestor] view].superview isKindOfClass:%c(UITransitionView)]){
    if(![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]){
        return;
    }
    
    NCNotificationGrabberView *grabberView = MSHookIvar<NCNotificationGrabberView *>(self, "_grabberView"); // Grabber used for later;
    
    if([[[self _viewControllerForAncestor] delegate] isKindOfClass:%c(SBNotificationBannerDestination)]){
        // is a banner
        if(enableBannerSection){
            
            MSHookIvar<UIImageView *>(self, "_shadowView").hidden = YES;
            
            //Sets all text to white color
            [[self _headerContentView] setTintColor:[UIColor whiteColor]];
            [[[[self _headerContentView] _dateLabel] _layer] setFilters:nil];
            [[[[self _headerContentView] _titleLabel] _layer] setFilters:nil];
            for(id object in self.allSubviews){
                if([object isKindOfClass:%c(NCNotificationContentView)]){
                    [[object _secondaryTextView] setTextColor:[UIColor whiteColor]];
                    [[object _primaryLabel] setTextColor:[UIColor whiteColor]];
                    [[object _primarySubtitleLabel] setTextColor:[UIColor whiteColor]];
                }
            }
            
            [[self backgroundMaterialView] setHidden:YES];
            MSHookIvar<MTMaterialView *>(self, "_mainOverlayView").hidden = true;
            
            self.frameWidth = UIScreen.mainScreen.bounds.size.width;
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            
            //
            if (UIDeviceOrientationIsPortrait(interfaceOrientation)) {
                if(enableBanners && self.frameY != -.5){
                    self.frameHeight += 32;
                }
            }
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
            self.frameY = -.5;
            
            CGPoint notifCenter = self.center;
            notifCenter.x = self.superview.center.x;
            self.center = notifCenter;
            
            
            if(!self.notifEffectView){
                UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:17];
                self.notifEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                
                // tint color
                if(enableColorCube){
                    CCColorCube *colorCube = [[CCColorCube alloc] init];
                    UIImage *img = (UIImage *)[[self _headerContentView] icon];
                    UIColor *rgbWhite = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
                    NSArray *imgColors = [colorCube extractBrightColorsFromImage:img avoidColor:rgbWhite count:4];
                    UIColor *uicolor = [imgColors[0] retain];
                    CGColorRef color = [uicolor CGColor];
                    UIColor *darkenedImgColor = nil;
                    
                    int numComponents = CGColorGetNumberOfComponents(color);
                    
                    if (numComponents == 4)
                    {
                        const CGFloat *components = CGColorGetComponents(color);
                        CGFloat red = components[0];
                        CGFloat green = components[1];
                        CGFloat blue = components[2];
                        //CGFloat alpha = components[3];
                        darkenedImgColor = [UIColor colorWithRed: red - .2 green: green - .2 blue: blue - .2 alpha:1];
                    }
                    
                    [uicolor release];
                    
                    
                    self.notifEffectView.backgroundColor = [darkenedImgColor colorWithAlphaComponent:.65];
                } else {
                    // Palette banners
                    if(paletteEnabled && self.backgroundView){
                        self.notifEffectView.backgroundColor = [UIColor clearColor];
                        self.backgroundView.frame = self.bounds;
                        [self.backgroundView _setCornerRadius: 0];
                        for(id object in self.backgroundView.subviews){
                            ((UIView *)object).frame = self.bounds;
                            for(id layer in ((UIView *)object).layer.sublayers){
                                ((CALayer *)layer).frame = self.bounds;
                            }
                        }
                    }
                    else self.notifEffectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.55];
                }
                
                
                self.notifEffectView.frame = self.bounds;
                self.notifEffectView.frameX = 0;
                self.notifEffectView.frameWidth = UIScreen.mainScreen.bounds.size.width;
                
                self.notifEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                [self addSubview:self.notifEffectView];
                [self sendSubviewToBack:self.notifEffectView];
            }
            
            // enable built in grabber and coloring
            if(enableGrabber == YES){
                grabberView.pill.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
            }
            grabberView.hidden = enableGrabber ? NO : YES;
            
            self.singleLine.hidden = YES;
            
            if(enableIconRemove == YES){
                MTPlatterHeaderContentView *header = [self _headerContentView];
                header.iconButton.hidden = YES;
                CGRect headerFrame = ((UILabel *)[header _titleLabel]).frame;
                headerFrame.origin.x = -13;
                ((UILabel *)[header _titleLabel]).frame = headerFrame;
                
            }
        }
    } else {
        // not a banner
        /*
        UIColor *bottomColor = [[UIColor blueColor] colorWithAlphaComponent:.4];
        
        // Create the gradient
        if([self respondsToSelector:@selector(backgroundView)]){
            CALayer *maskView = [[CALayer alloc] init];
            maskView.frame = self.backgroundView.bounds;
            
            CAGradientLayer *theVertGradient = [CAGradientLayer layer];
            theVertGradient.colors = [NSArray arrayWithObjects: [UIColor clearColor], (id)bottomColor.CGColor, (id)bottomColor.CGColor, [UIColor clearColor], nil];
            theVertGradient.locations = [NSArray arrayWithObjects: [NSNumber numberWithDouble: .000], [NSNumber numberWithDouble: 0.3], [NSNumber numberWithDouble: 0.7],[NSNumber numberWithDouble: 1], [NSNumber numberWithDouble: 1], nil];
            theVertGradient.startPoint = CGPointMake(0.5, 0.0);
            theVertGradient.endPoint = CGPointMake(0.5, 1.0);
            theVertGradient.frame = self.backgroundView.bounds;
            /*
            CAGradientLayer *theHorzGradient = [CAGradientLayer layer];
            theHorzGradient.colors = [NSArray arrayWithObjects: [UIColor clearColor], (id)bottomColor.CGColor, [UIColor clearColor], nil];
            theHorzGradient.locations = [NSArray arrayWithObjects: [NSNumber numberWithDouble: .005], [NSNumber numberWithDouble: 0.75], [NSNumber numberWithDouble: 1], [NSNumber numberWithDouble: 1], nil];
            theHorzGradient.startPoint = CGPointMake(0.0, 0.5);
            theHorzGradient.endPoint = CGPointMake(1.0, 0.5);
            theHorzGradient.frame = self.backgroundView.bounds;
            */
            //[maskView addSublayer:theVertGradient];
            //[maskView addSublayer:theHorzGradient];
            /*
            UIGraphicsBeginImageContextWithOptions(maskView.bounds.size, NO, 0.0);
            [maskView renderInContext: UIGraphicsGetCurrentContext()];
            UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            maskView.contents = (id) layerImage.CGImage;
            maskView.sublayers = nil;
            */
            /*
            //Add gradient to view
            self.backgroundView.layer.mask = theVertGradient;
            self.backgroundView.alpha = 1;
        }
        */
        
        if(self.backgroundView){
            self.backgroundView.hidden = YES;
        }
        
        MSHookIvar<UIImageView *>(self, "_shadowView").hidden = YES;
        
        //Sets all text to white color
        [[self _headerContentView] setTintColor:[UIColor whiteColor]];
        [[[[self _headerContentView] _dateLabel] _layer] setFilters:nil];
        [[[[self _headerContentView] _titleLabel] _layer] setFilters:nil];
        for(id object in self.allSubviews){
            if([object isKindOfClass:%c(NCNotificationContentView)]){
                [[object _secondaryTextView] setTextColor:[UIColor whiteColor]];
                [[object _primaryLabel] setTextColor:[UIColor whiteColor]];
                [[object _primarySubtitleLabel] setTextColor:[UIColor whiteColor]];
            }
        }
        
        [[self backgroundMaterialView] setHidden:YES];
        MSHookIvar<MTMaterialView *>(self, "_mainOverlayView").hidden = true;
        
        BOOL rotationCheckLandscape = NO;
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (UIDeviceOrientationIsLandscape(interfaceOrientation))
        {
            rotationCheckLandscape = YES;
        }
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        if(!enableExtend || rotationCheckLandscape == YES){
            self.frameWidth = self.superview.frame.size.width - .5;
        } else {
            self.frameWidth = UIScreen.mainScreen.bounds.size.width - ((UIScreen.mainScreen.bounds.size.width - self.superview.frame.size.width) / 2);
        }
        
        grabberView.hidden = YES;
        if(enableSeparators){
            if(!self.topLine){
                
                self.topLine.drawsWithVibrantLightMode = NO;
                self.topLine = [[%c(_UITableViewCellSeparatorView) alloc] initWithFrame:self.frame];
                UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                UIVibrancyEffect *vibEffect = [UIVibrancyEffect effectForBlurEffect:effect];
                [self.topLine setSeparatorEffect:vibEffect];
                self.topLine.alpha = .45;
                
                [self addSubview:self.topLine];
                
            }
            self.topLine.frameHeight = .5;
            self.topLine.frameX = 12;
            
            if(!enableExtend || rotationCheckLandscape == YES){
                self.topLine.frameWidth = self.frame.size.width - 17;
            } else {
                self.topLine.frameWidth = self.frame.size.width - 12;
            }
            self.topLine.frameY = -7;
            
            [self tcUpdateTopLine];
            
            if(!self.singleLine){
                
                self.singleLine.drawsWithVibrantLightMode = NO;
                self.singleLine = [[%c(_UITableViewCellSeparatorView) alloc] initWithFrame:self.frame];
                UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                UIVibrancyEffect *vibEffect = [UIVibrancyEffect effectForBlurEffect:effect];
                [self.singleLine setSeparatorEffect:vibEffect];
                self.singleLine.alpha = .45;
                
                [self addSubview:self.singleLine];
                
            }
            self.singleLine.frameHeight = .5;
            self.singleLine.frameX = 12;
            
            if(!enableExtend || rotationCheckLandscape == YES){
                self.singleLine.frameWidth = self.frame.size.width - 17;
            } else {
                self.singleLine.frameWidth = self.frame.size.width - 12;
            }
            self.singleLine.frameY = 2 * self.center.y;
        }
    }
    %orig;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsPortrait(interfaceOrientation) && enableBannerSection)
    {
        if([[[self _viewControllerForAncestor] view].superview isKindOfClass:%c(UITransitionView)]){
            for(id object in self.allSubviews){
                if([object isKindOfClass:%c(MTPlatterCustomContentView)] || [object isKindOfClass:%c(MTPlatterHeaderContentView)]){
                    if([object frame].origin.y != 32 && enableBanners){
                        CGRect contentFrame = [object frame];
                        contentFrame.origin.y = 32;
                        [object setFrame:contentFrame];
                    }
                }
            }
        }
    }
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
}

%new
-(void) tcUpdateTopLine{
    if([self._viewControllerForAncestor respondsToSelector:@selector(delegate)]){
        if([((NCNotificationCombinedListViewController *)((NCNotificationShortLookViewController *)self._viewControllerForAncestor).delegate).notificationPriorityList.requests firstObject] == ((NCNotificationShortLookViewController *)self._viewControllerForAncestor).notificationRequest){
            self.topLine.alpha = 0;
            self.topLine.hidden = NO;
            [UIView animateWithDuration:.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{self.topLine.alpha = .45;}
                             completion:nil];
        } else {
            self.topLine.hidden = YES;
        }
    }
}

-(BOOL)_shouldShowGrabber {
    return enableBannerSection ? YES : %orig;
}
%end

/*
%hook _NCNotificationViewControllerView
-(void) setContentView{
    %orig;
    NCNotificationShortLookView *shortView = (NCNotificationShortLookView *)self.contentView;
    
    if(!shortView.notifEffectView){
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:17];
        shortView.notifEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        // tint color
        if(enableColorCube){
            CCColorCube *colorCube = [[CCColorCube alloc] init];
            UIImage *img = (UIImage *)[[shortView _headerContentView] icon];
            UIColor *rgbWhite = [UIColor colorWithRed:1 green:1 blue:.8 alpha:1];
            NSArray *imgColors = [colorCube extractBrightColorsFromImage:img avoidColor:rgbWhite count:4];
            //UIColor *darkenedImgColor = imgColors[0];
            
            shortView.notifEffectView.backgroundColor = [imgColors[0] colorWithAlphaComponent:.65];
        } else {
            shortView.notifEffectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.55];
        }
        
        
        shortView.notifEffectView.frame = shortView.bounds;
        shortView.notifEffectView.frameX = 0;
        shortView.notifEffectView.frameWidth = UIScreen.mainScreen.bounds.size.width;
        
        shortView.notifEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [shortView addSubview:shortView.notifEffectView];
        [shortView sendSubviewToBack:shortView.notifEffectView];
    }
    
    if(!shortView.pullTab && enableGrabber == YES){
        shortView.pullTab = [[UIView alloc] initWithFrame:shortView.notifEffectView.frame];
        
        shortView.pullTab.frameHeight = 4;
        shortView.pullTab.frameWidth = 34;
        shortView.pullTab.frameX = (UIScreen.mainScreen.bounds.size.width / 2) - (shortView.pullTab.frameWidth / 2);
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(enableBanners){
            if (UIDeviceOrientationIsPortrait(interfaceOrientation))
            {
                shortView.pullTab.frameY = shortView.notifEffectView.bounds.size.height + 23;
            } else {
                shortView.pullTab.frameY = shortView.notifEffectView.bounds.size.height - 9;
            }
        } else {
            shortView.pullTab.frameY = shortView.notifEffectView.bounds.size.height - 9;
        }
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        
        
        shortView.pullTab.backgroundColor = [UIColor whiteColor];
        [shortView.pullTab _setCornerRadius:2];
        [shortView addSubview:shortView.pullTab];
    }
    
}
%end
*/

%hook NCNotificationListSectionHeaderView
%property (nonatomic, retain) UIVisualEffectView *headerEffectView;
-(void) layoutSubviews{
    if(!self.headerEffectView && enableHeaders){
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:3];
        self.headerEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.headerEffectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
        self.headerEffectView.frame = self.bounds;
        
        [self addSubview:self.headerEffectView];
        [self sendSubviewToBack:self.headerEffectView];
    }
    %orig;
    
    if(enableHeaders){
        self.headerEffectView.frame = self.bounds;
        self.headerEffectView.frameHeight = self.bounds.size.height - 10;
        
        // changing size
        self.titleLabel.font = [UIFont fontWithName:@".SFUIDisplay" size:22.0];
        CGPoint center = self.titleLabel.center;
        center.y = self.headerEffectView.frameHeight/2;
        self.titleLabel.center = center;
        CGPoint center2 = self.clearButton.center;
        center2.y = self.headerEffectView.frameHeight/2;
        self.clearButton.center = center2;
    }
}
%end

%hook NCNotificationListCellActionButton
-(void) layoutSubviews{
    %orig;
    MTMaterialView *materialView = MSHookIvar<MTMaterialView *>(self, "_backgroundView");
    MSHookIvar<MTMaterialView *>(materialView, "_backdropView").hidden = true;
    MSHookIvar<MTMaterialView *>(self, "_backgroundOverlayView").hidden = true;
    
    UILabel *label = MSHookIvar<UILabel *>(self, "_titleLabel");
    [label setTextColor:[UIColor whiteColor]];
    [[label _layer] setFilters:nil];
    MSHookIvar<UIView *>(self, "_backgroundHighlightView").alpha = 0;
}
%end

%hook _NCNotificationViewControllerView
-(void) layoutSubviews{
    if(![[self.contentView _viewControllerForAncestor] respondsToSelector:@selector(delegate)] || !enableBannerSection){
        %orig;
        return;
    }
    if([[[self.contentView _viewControllerForAncestor] delegate] isKindOfClass:%c(SBNotificationBannerDestination)]){
    //if(self.frame.origin.y != 0){
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }
    %orig;
}
%end
/*
%hook SBCoverSheetUnlockedEnvironmentHoster
-(void)setUnlockedEnvironmentWindowsHidden:(BOOL)arg1{
    %orig;
    self.hostingWindow.hidden = NO;
 
    UIImage *tempBackgroundImage = [UIImage imageWithCGImage:(CGImage *)[self.hostingWindow createSnapshotWithRect:self.hostingWindow.frame]];
    NSLog(@"nine_TWEAK %@", tempBackgroundImage);
    CCColorCube *colorCube = [[CCColorCube alloc] init];
    UIImage *img = tempBackgroundImage;
    NSArray *imgColors = [colorCube extractColorsFromImage:img flags:CCOrderByBrightness count:4];
    NSLog(@"nine_TWEAK %@", imgColors[0]);
    self.hostingWindow.debugHighlight = imgColors[0];
 
    @try {
        
    } @catch (NSException *exception) {
        // log the exception as you wish
        // you can then throw the exception up
        NSLog(@"nine_TWEAK exception: %@", exception);
        @throw exception;
    }
 

}
%end
*/


/*

// Media controller
%hook MediaControlsHeaderView
-(id) secondaryLabel {
    UILabel *secondaryLabel;
    NSLog(@"nine_TWEAK return type: %@",%orig);
    if((secondaryLabel = %orig)){
        [secondaryLabel setTextColor:[UIColor whiteColor]];
    }
    return secondaryLabel;
}
-(void) setSecondaryLabel {
    [self.secondaryLabel setTextColor:[UIColor whiteColor]];
}
%end
*/

// Posting all notifications :)

/*
%hookf(uint32_t, notify_post, const char *name) {
    uint32_t r = %orig;
    //if (strstr(name, "notification")) {
        NSLog(@"NOTI_MON: %s", name);
    //}
        return r;
}

%hookf(void, CFNotificationCenterPostNotification, CFNotificationCenterRef center, CFNotificationName name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately) {
            %orig;
            NSString *notiName = (__bridge NSString *)name;
            //if ([notiName containsString:@"notification"]) {
                NSLog(@"NOTI_MON: %@", notiName);
            //}
}
 */
/*
%ctor{
 [[NSNotificationCenter defaultCenter] addObserverForName:NULL object:NULL queue:NULL usingBlock:^(NSNotification *note) {
 if ([note.name containsString:@"UIViewAnimationDidCommitNotification"] || [note.name containsString:@"UIViewAnimationDidStopNotification"] || [note.name containsString:@"UIScreenBrightnessDidChangeNotification"]){
 } else {
 NSLog(@"UNIQUE: %@", note.name);
 }
 }];
}
*/

/* // debugging
 @try {
 [superview addConstraints:@[ contentViewLeadingConstraint,
 contentViewTrailingConstraint, contentViewHeightConstraint, contentViewYConstraint]];
 } @catch (NSException *exception) {
 NSLog(@"nine_TWEAK %@",exception);
 @throw exception;
 }
 */

// loading up that palette
static void loadPrefs() {
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/ch.mdaus.palette.plist"];
    paletteEnabled = [settings objectForKey:@"bannersEnabled"] ? [[settings objectForKey:@"bannersEnabled"] boolValue] : NO;
}

%ctor {
    // Fix rejailbreak bug
    if (![NSBundle.mainBundle.bundleURL.lastPathComponent.pathExtension isEqualToString:@"app"]) {
        return;
    }
    HBPreferences *settings = [[HBPreferences alloc] initWithIdentifier:@"com.thecasle.nineprefs"];
    [settings registerDefaults:@{
                                 @"tweakEnabled": @YES,
                                 @"bannersEnabled": @NO,
                                 @"shadedEnabled": @YES,
                                 @"extendEnabled": @YES,
                                 @"grabberEnabled": @YES,
                                 @"iconRemoveEnabled": @NO,
                                 @"colorEnabled": @NO,
                                 @"bannerSectionEnabled": @YES,
                                 @"clearBackgroundEnabled": @YES,
                                 @"separatorsEnabled": @YES,
                                 }];
    BOOL tweakEnabled = [settings boolForKey:@"tweakEnabled"];
    enableBanners = [settings boolForKey:@"bannersEnabled"];
    enableHeaders = [settings boolForKey:@"shadedEnabled"];
    enableExtend = [settings boolForKey:@"extendEnabled"];
    enableGrabber = [settings boolForKey:@"grabberEnabled"];
    enableIconRemove = [settings boolForKey:@"iconRemoveEnabled"];
    enableColorCube = [settings boolForKey:@"colorEnabled"];
    enableBannerSection = [settings boolForKey:@"bannerSectionEnabled"];
    enableClearBackground = [settings boolForKey:@"clearBackgroundEnabled"];
    enableSeparators = [settings boolForKey:@"separatorsEnabled"];
    
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("ch.mdaus.palette"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    

    if(tweakEnabled) {
        %init;
        if(enableClearBackground) {
            %init(ClearBackground);
        }
    }
    /*
    [[NSNotificationCenter defaultCenter] addObserverForName:NULL object:NULL queue:NULL usingBlock:^(NSNotification *note) {
        if ([note.name containsString:@"UIViewAnimationDidCommitNotification"] || [note.name containsString:@"UIViewAnimationDidStopNotification"] || [note.name containsString:@"UIScreenBrightnessDidChangeNotification"]){
        } else {
            NSLog(@"UNIQUE: %@", note.name);
        }
    }];
    */
}

