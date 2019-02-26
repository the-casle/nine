#import <Foundation/Foundation.h>
#import "TCBackgroundViewController.h"
#import "_UIBackdropViewSettingsNineHistory.h"
#import "_UIBackdropViewSettingsNineLock.h"
#import <notify.h>
#include <objc/runtime.h>
#import <substrate.h>
#import "CustomWorks/TCSetFrame/TCSetFrame.h"
#import "CustomWorks/ColorCube/CCColorCube.h"

//extern "C" CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);
extern "C" UIColor *LCPParseColorString(NSString *colorStringFromPrefs, NSString *colorStringFallback);


@interface UIView (copy)
-(void)_setCornerRadius:(double)arg1;
-(CGRect) bounds;
-(void) addSubview:(id)subview;
-(void) sendSubviewToBack:(id)subview;
-(void) setHidden:(BOOL)number;
-(void) setClipsToBounds:(BOOL) value;
-(id) _viewDelegate;
@property (nonatomic) CGRect frame;
@property (nonatomic) CGFloat _cornerRadius;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSArray *allSubviews;
@property (nonatomic, strong) UIView *_ui_superview;
@property (nonatomic, strong) UIColor *debugHighlight;
+(void) animateWithDuration:(CGFloat)arg1 animations:(id)arg2;
- (id)_viewControllerForAncestor;
-(id) createSnapshotWithRect:(CGRect)rect;

@end

@interface SpringBoard
-(int)nowPlayingProcessPID;
@end

@interface BSUIEmojiLabelView : UILabel
@property (nonatomic, retain) UILabel *contentLabel;
@end

@interface PLPlatterView : UIView
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic) CGFloat overlayAlpha;
@property (nonatomic) BOOL hasStackingShadow;
@end

@interface NCNotificationContentView : NSObject
-(id) _secondaryTextView;
-(id) _primaryLabel;
-(id) _primarySubtitleLabel;
-(id)_summaryLabel;
-(id)_secondaryLabel;
@end

@interface MTPlatterHeaderContentView
-(id) _dateLabel;
-(id) _titleLabel;
-(id) _primarySubtitleLabel;
@property (nonatomic, retain) UIButton *iconButton;
@end

@interface SBUIBackgroundView : UIView
@property (nonatomic, retain) UIVisualEffectView *blurEffectView;
@property (nonatomic, retain) UIImageView *blurImgView;
-(void) recieveAdjustAlpha:(NSNotification*)notification;
@end

@interface _UITableViewCellSeparatorView : UIView
@property (nonatomic) BOOL drawsWithVibrantLightMode;
-(void)setSeparatorEffect:(UIVisualEffect *)arg1 ;
@end

@interface NCNotificationShortLookView : UIView
-(id) backgroundMaterialView;
-(id) _headerContentView;
-(id) _customContentView;
@property (nonatomic, retain) UIView *backgroundView;
@property (getter=_notificationContentView,nonatomic,readonly) NCNotificationContentView * notificationContentView;

@property (nonatomic, getter=isNineBanner) BOOL nineBanner;
@property (nonatomic, retain) _UITableViewCellSeparatorView *singleLine;
@property (nonatomic, retain) _UITableViewCellSeparatorView *topLine;
@property (nonatomic, retain) UIVisualEffectView *notifEffectView;
@property (nonatomic, retain) UIView *extendedView;

-(void) tcUpdateTopLine;
@end

@interface SBUILegibilityLabel : UIView
@property (nonatomic, retain) UIFont *font;
@end

@interface NCNotificationListClearButton : UIView
@end

@interface NCNotificationListHeaderTitleView : UIView
@property (nonatomic,retain) SBUILegibilityLabel * titleLabel;
@end

@interface NCNotificationListSectionHeaderView : UIView
@property (nonatomic, retain) UIVisualEffectView *headerEffectView;
@property (nonatomic,retain) NCNotificationListHeaderTitleView * headerTitleView;
@property (nonatomic, retain) NCNotificationListClearButton *clearButton;
@end

@interface UILabel (Class)
-(id) _layer;
@end

@interface _UILabelLayer
-(void)setFilters:(id) arg1;
@end

@interface MTMaterialView : UIView
@end

@interface UIBlurEffect (nine)
@property (nonatomic,readonly) BOOL _canProvideVibrancyEffect;
+(id)effectWithBlurRadius:(CGFloat) value;
+(id)_effectWithStyle:(long long)arg1 tintColor:(id)arg2 invertAutomaticStyle:(BOOL)arg3 ;
+(id)_effectWithStyle:(long long)arg1 invertAutomaticStyle:(BOOL)arg2;
@end

@interface UIVibrancyEffect (nine)
+(id) widgetPrimaryVibrancyEffect;
@end

@interface NCNotificationListCollectionView : UICollectionView
@property (nonatomic, retain) NSArray *visibleCells;
@end

@interface SBDashBoardCombinedListViewController : UIViewController
@end


@interface NCNotificationListViewController : UICollectionViewController
@end

@interface NCNotificationPriorityList
@property (nonatomic,retain) NSArray * allNotificationRequests;
@end

@interface NCNotificationCombinedListViewController : NCNotificationListViewController
@property (assign,nonatomic) double prioritySectionLowestPosition;
@property (assign,getter=isShowingNotificationsHistory,nonatomic) BOOL showingNotificationsHistory;
@property (nonatomic,retain) NCNotificationPriorityList * notificationPriorityList;
@property (nonatomic, retain) NCNotificationListCollectionView *collectionView;
-(void)forceNotificationHistoryRevealed:(BOOL)arg1 animated:(BOOL)arg2;
- (NCNotificationListCollectionView *)_scrollView;
-(BOOL) hasContent;
-(void)nz9_scrollToTop;
-(void)_performRevealAnimationForSectionHeaders;

@end



@interface NCNotificationRequest

@end


@interface NCNotificationShortLookViewController : UIViewController
-(id) delegate;
//@property (nonatomic, retain) NCNotificationListCell *associatedView;
@property (nonatomic, retain) NCNotificationCombinedListViewController *_parentViewController;
@property (nonatomic, retain) NCNotificationRequest *notificationRequest;
@end

@interface NCNotificationListCell : UIView
@property (nonatomic, retain) NCNotificationShortLookViewController *contentViewController;
@end


@interface NCNotificationGrabberView : UIView
@property (nonatomic, retain) UIView *pill;
@end


@interface _NCNotificationViewControllerView : UIView
@property (nonatomic, retain) UIView *contentView;
@end

@interface NCNotificationViewControllerView : UIView // ios 12
@property (nonatomic, retain) UIView *contentView;
@end

@interface SBFTouchPassThroughView : UIView
@end

@interface SBCoverSheetUnlockedEnvironmentHostingViewController : UIViewController
@end

@interface SBDashBoardView : UIView
@property (nonatomic, retain) SBUIBackgroundView *backgroundView;
@end

@interface SBDashBoardViewController : UIViewController
@property (nonatomic, retain) TCBackgroundViewController *backgroundCont;
@end


@interface SBWallpaperStyleInfo
@property (nonatomic, retain) NSString *description;
@end

@interface SBLockScreenManager
+(id)sharedInstance;
@property (readonly) BOOL isLockScreenActive;
@property (readonly) BOOL isLockScreenVisible;
@property (readonly) BOOL isUILocked;
-(BOOL)isUIUnlocking;
-(BOOL)hasUIEverBeenLocked;
@end

@interface SBFWallpaperView : UIView

@end

@interface SBFWallpaperConfiguration

@end

@interface SBFWallpaperConfigurationManager
@property (nonatomic,copy,readonly) SBFWallpaperConfiguration * homeScreenWallpaperConfiguration;
@end


@interface SBWallpaperController
+(id)sharedInstance;
@property (nonatomic, retain) SBWallpaperStyleInfo *homescreenStyleInfo;
@property (assign,nonatomic) long long variant;
@property (nonatomic,retain) SBFWallpaperView * homescreenWallpaperView;
@property (nonatomic,retain) SBFWallpaperView *lockscreenWallpaperView;
-(id)_wallpaperViewForVariant:(long long)arg1 ;
-()_window;
@property (nonatomic) CGFloat windowLevel;
@property (nonatomic,retain) SBFWallpaperView * sharedWallpaperView;
@property (nonatomic,readonly) SBFWallpaperConfigurationManager * wallpaperConfigurationManager;

-(id)_makeAndInsertWallpaperViewWithConfiguration:(id)arg1 forVariant:(long long)arg2 shared:(BOOL)arg3 options:(unsigned long long)arg4;

@end

@interface AVAudioSession
+(id) sharedInstance;
@property (nonatomic) BOOL otherAudioPlaying;
@end

@interface WGWidgetHostingViewController
@property (nonatomic) NSInteger activeDisplayMode;
@end

@interface SBIconContentView : UIView
-(id)sb_snapshotImage;
@end

@interface SBFStaticWallpaperView : SBFWallpaperView
- (UIImage *)wallpaperImage;
@end

@interface SBMediaController
-(BOOL) isPlaying;
@end

@interface MediaControlsHeaderView : UIView
@property (nonatomic, retain) UILabel *secondaryLabel;
@end

@interface WGWidgetPlatterView : UIView

@end


@interface SBUIController{
    SBIconContentView *_iconsView;
}
+(id)sharedInstance;
-(id)valueForKey:(id)arg1;
-(void)_resetHomeScreenBlurredContentSnapshotImage;
-(id)homeScreenBlurredContentSnapshotImage;
-(BOOL) isIconListViewTornDown;
@property (nonatomic, retain) UIImageView* _homeScreenBlurredContentSnapshotImageView;

@end

@interface SBCoverSheetUnlockedEnvironmentHostingWindow : UIView
@end

@interface SBCoverSheetUnlockedEnvironmentHostingViewController (nine)
@property (nonatomic,retain) UIView *maskingView;
@end

@interface SBCoverSheetUnlockedEnvironmentHoster
@property (nonatomic,retain) SBCoverSheetUnlockedEnvironmentHostingViewController *viewController;
@property (nonatomic,retain) UIWindow * hostingWindow;
@end

@interface SBCoverSheetPanelBackgroundContainerView : UIView
@end

@interface SBCoverSheetSlidingViewController
- (long long)dismissalSlidingMode;
@end

@interface SBDashBoardQuickActionsViewController : UIViewController
@end

@interface SBCoverSheetPrimarySlidingViewController
@property (nonatomic,retain) SBCoverSheetPanelBackgroundContainerView * panelBackgroundContainerView;
@end

@interface _UIBackdropViewSettings (nine)
@property (assign,nonatomic) double blurRadius;
-(id) init;
+(id)settingsForPrivateStyle:(long long)arg1 ;
@property (assign,getter=isBackdropVisible,nonatomic) BOOL backdropVisible;
@property (assign,nonatomic) double grayscaleTintLevel;
@property (assign,nonatomic) BOOL usesBackdropEffectView;
@property (nonatomic,copy) NSString * blurQuality;
@property (assign,nonatomic) double scale;
@property (assign,nonatomic) BOOL appliesTintAndBlurSettings;
@property (assign,nonatomic) double grayscaleTintMaskAlpha;
@property (assign,nonatomic) double colorTintMaskAlpha;
@property (assign,nonatomic) double filterMaskAlpha;
@property (assign,nonatomic) BOOL usesColorTintView;
@property (assign,nonatomic) double colorTintAlpha;
@property (nonatomic,retain) UIColor * colorTint; 
@property (assign,nonatomic) BOOL usesDarkeningTintView;
@property (nonatomic,retain) UIColor * legibleColor;
@property (assign,getter=isEnabled,nonatomic) BOOL enabled;
@property (assign,nonatomic) BOOL usesContentView;
@property (assign,nonatomic) double darkeningTintAlpha;
@property (assign,nonatomic) double saturationDeltaFactor;
@property (assign,nonatomic) double darkeningTintBrightness;
@property (assign,nonatomic) double darkeningTintHue;
@property (assign,nonatomic) double darkeningTintSaturation;
@end

@interface _UIBackdropViewSettingsBlur : _UIBackdropViewSettings
@end

@interface BSUIBackdropView (nine)
-(id) initWithSettings:(id) settings;
@end

@interface _UIBackdropView : NSObject
- (id)initWithStyle:(long long)arg1;
- (void)setBlurQuality:(id)arg1;
- (void)setSaturationDeltaFactor:(double)arg1;
- (void)setBlurRadius:(double)arg1;
- (void)setBlurRadiusSetOnce:(bool)arg1;
@end

@interface PLPlatterHeaderContentView : UIView
@property (nonatomic, retain) NSArray *iconButtons;
-(id)_titleLabel;
@end
