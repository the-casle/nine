#import <Foundation/Foundation.h>

@interface TCBackgroundViewController : UIViewController
@property (nonatomic, retain) UIVisualEffectView *blurEffectView;
@property (nonatomic, retain) UIVisualEffectView *blurHistoryEffectView;
@property (nonatomic, retain) UIView *blurView;
-(void) updateSceenShot: (BOOL)content isRevealed: (BOOL)isHistoryRevealed;
+ (id) sharedInstance;
@end
