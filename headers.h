#import <foundation/foundation.h>
#import "TCBackgroundViewController.h"
#import <notify.h>
#include <objc/runtime.h>
#import <substrate.h>


//extern "C" CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);

extern "C" NSUInteger alphaOfBackground;

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
+(void) animateWithDuration:(CGFloat)arg1 animations:(id)arg2;
- (id)_viewControllerForAncestor;
@end


@interface NCNotificationContentView
-(id) _secondaryTextView;
-(id) _primaryLabel;
-(id) _primarySubtitleLabel;
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

@property (nonatomic, retain) _UITableViewCellSeparatorView *singleLine;
@property (nonatomic, retain) UIVisualEffectView *notifEffectView;
@property (nonatomic, retain) UIView *pullTab;
@end

@interface SBUILegibilityLabel : UIView
@end

@interface NCNotificationListClearButton : UIView
@end

@interface NCNotificationListSectionHeaderView : UIView
@property (nonatomic, retain) UIVisualEffectView *headerEffectView;
@property (nonatomic, retain) SBUILegibilityLabel *titleLabel;
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

@interface NCNotificationCombinedListViewController : UIViewController
@property (assign,nonatomic) double prioritySectionLowestPosition;
@property (assign,getter=isShowingNotificationsHistory,nonatomic) BOOL showingNotificationsHistory;
-(BOOL) hasContent;
@end

@interface NCNotificationListCell : UIView

@end

@interface NCNotificationShortLookViewController : UIViewController
-(id) delegate;
@property (nonatomic, retain) NCNotificationListCell *associatedView;
@end

@interface _NCNotificationViewControllerView : UIView
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
@property (readonly) BOOL isLockScreenVisible;
@end

@interface SBFWallpaperView : UIView

@end

@interface SBWallpaperController
+(id)sharedInstance;
@property (nonatomic, retain) SBWallpaperStyleInfo *homescreenStyleInfo;
@property (assign,nonatomic) long long variant;
@property (nonatomic,retain) SBFWallpaperView * homescreenWallpaperView;
-(id)_wallpaperViewForVariant:(long long)arg1 ;
@property (nonatomic,retain) SBFWallpaperView * sharedWallpaperView;
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
