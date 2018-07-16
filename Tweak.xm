#include "headers.h"
#import "TCBackgroundViewController.h"
#import <Cephei/HBPreferences.h>


static BOOL enableBanners;
static BOOL enableHeaders;
static BOOL enableExtend;
static BOOL enableGrabber;
static BOOL enableIconRemove;


%hook NCNotificationCombinedListViewController
-(BOOL)hasContent{
    BOOL content = %orig;
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    
    BOOL initialUpdated = NO;
    if(initialUpdated == NO){
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        NSDictionary* userInfo = @{@"content": @(content)};
        [nc postNotificationName:@"alphaReceived" object:self userInfo:userInfo];
        initialUpdated = YES;
    }
    if(alphaOfBackground != content){
        NSDictionary* userInfo = @{@"content": @(content)};
        [nc postNotificationName:@"alphaReceived" object:self userInfo:userInfo];
        //NSLog(@"nine_TWEAK posting content notification");
        
    }
    BOOL tempBool = self.isShowingNotificationsHistory;
    //NSLog(@"nine_TWEAK | posting %d",tempBool);
    NSDictionary* userInfo = @{@"content": @(content), @"history": @(tempBool)};
    [nc postNotificationName:@"updateTCBackgroundBlur" object:self userInfo:userInfo];
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
%hook SBDashBoardViewController
%property (nonatomic, retain) TCBackgroundViewController *backgroundCont;
-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2{
    if((self = %orig)){
        self.backgroundCont = [[TCBackgroundViewController alloc] init];
    }
    return self;
}
-(void)loadView{
    %orig;
    [((SBDashBoardView *)self.view).backgroundView addSubview: self.backgroundCont.view];
    //NSLog(@"nine_TWEAK | %@",self.backgroundCont);
}

%end

%hook NCNotificationShortLookViewController
-(void) viewDidLoad{
    
    %orig;
    
    // constraints
    //UIView *superview = self.view;
}
%end

%hook NCNotificationShortLookView
%property (nonatomic, retain) _UITableViewCellSeparatorView *singleLine;
%property (nonatomic, retain) UIVisualEffectView *notifEffectView;
%property (nonatomic, retain) UIView *pullTab;

-(void) layoutSubviews{
    %orig;
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
    
    // banner check, took a while to get right
    if([[[self _viewControllerForAncestor] view].superview isKindOfClass:%c(UITransitionView)]){
        CGRect frame = self.frame;
        frame.size.width = UIScreen.mainScreen.bounds.size.width;
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIDeviceOrientationIsPortrait(interfaceOrientation)) {
            if(enableBanners && frame.origin.y != 0){
                frame.size.height += 32;
            }
        }
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        
        frame.origin.y = 0;
        self.frame = frame;
        CGPoint notifCenter = self.center;
        notifCenter.x = self.superview.center.x;
        self.center = notifCenter;
    
        if(!self.notifEffectView){
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:17];
            self.notifEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            self.notifEffectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.55];
            CGRect newFrame = self.bounds;
            newFrame.origin.x = 0;
            newFrame.size.width = UIScreen.mainScreen.bounds.size.width;
            
            self.notifEffectView.frame = newFrame;
            
            self.notifEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [self addSubview:self.notifEffectView];
            [self sendSubviewToBack:self.notifEffectView];
        }
        
        if(!self.pullTab && enableGrabber == YES){
            CGRect pullFrame = self.notifEffectView.frame;
            pullFrame.size.height = 4;
            pullFrame.size.width = 34;
            pullFrame.origin.x = (UIScreen.mainScreen.bounds.size.width / 2) - (pullFrame.size.width / 2);
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            if(enableBanners){
                
                if (UIDeviceOrientationIsPortrait(interfaceOrientation))
                {
                    pullFrame.origin.y = self.notifEffectView.bounds.size.height + 23;
                } else {
                    pullFrame.origin.y = self.notifEffectView.bounds.size.height - 9;
                }
            } else {
                pullFrame.origin.y = self.notifEffectView.bounds.size.height - 9;
            }
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
            self.pullTab = [[UIView alloc] initWithFrame:pullFrame];
            self.pullTab.backgroundColor = [UIColor whiteColor];
            [self.pullTab _setCornerRadius:2];
            [self addSubview:self.pullTab];
        }
        self.singleLine.hidden = YES;
        
        if(enableIconRemove == YES){
            MTPlatterHeaderContentView *header = [self _headerContentView];
            header.iconButton.hidden = YES;
            CGRect headerFrame = ((UILabel *)[header _titleLabel]).frame;
            headerFrame.origin.x = -13;
            ((UILabel *)[header _titleLabel]).frame = headerFrame;
            
        }
        
    } else {
    // not a banner
        
        BOOL rotationCheckLandscape = NO;
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

        if (UIDeviceOrientationIsLandscape(interfaceOrientation))
        {
            rotationCheckLandscape = YES;
        }
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        
        CGRect notifFrame = self.frame;
        if(!enableExtend || rotationCheckLandscape == YES){
            notifFrame.size.width = self.superview.frame.size.width - .5;
        } else {
            notifFrame.size.width = UIScreen.mainScreen.bounds.size.width - ((UIScreen.mainScreen.bounds.size.width - self.superview.frame.size.width) / 2);
        }
        
        self.frame = notifFrame;
        
        CGRect lineFrame = self.frame;
        lineFrame.size.height = .5;
        lineFrame.origin.x = 12;
        
        if(!enableExtend || rotationCheckLandscape == YES){
            lineFrame.size.width = self.frame.size.width - 17;
        } else {
            lineFrame.size.width = self.frame.size.width - 12;
        }
        
        lineFrame.origin.y = 2 * self.center.y;
        if(!self.singleLine){
            
            self.singleLine.drawsWithVibrantLightMode = NO;
            self.singleLine = [[%c(_UITableViewCellSeparatorView) alloc] initWithFrame:lineFrame];
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVibrancyEffect *vibEffect = [UIVibrancyEffect effectForBlurEffect:effect];
            [self.singleLine setSeparatorEffect:vibEffect];
            self.singleLine.alpha = .45;

            //self.singleLine.frame = lineFrame;
            [self addSubview:self.singleLine];
            
        }
        self.singleLine.frame = lineFrame;
    }
    %orig;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsPortrait(interfaceOrientation))
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
%end

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
    self.headerEffectView.frame = self.bounds;
    
    CGPoint center = self.titleLabel.center;
    center.y = self.bounds.size.height/2;
    self.titleLabel.center = center;
    CGPoint center2 = self.clearButton.center;
    center2.y = self.bounds.size.height/2;
    self.clearButton.center = center2;
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
    if(self.frame.origin.y != 0){
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }
    %orig;
}
%end
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
/*
// Posting all notifications :)


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
                                 }];
    BOOL tweakEnabled = [settings boolForKey:@"tweakEnabled"];
    enableBanners = [settings boolForKey:@"bannersEnabled"];
    enableHeaders = [settings boolForKey:@"shadedEnabled"];
    enableExtend = [settings boolForKey:@"extendEnabled"];
    enableGrabber = [settings boolForKey:@"grabberEnabled"];
    enableIconRemove = [settings boolForKey:@"iconRemoveEnabled"];
    
    if(tweakEnabled) {
        %init;
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
