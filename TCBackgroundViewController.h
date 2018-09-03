#import <Foundation/Foundation.h>
@interface BSUIBackdropView : UIView
@end
@interface TCBackgroundViewController : UIViewController
@property (nonatomic, retain) BSUIBackdropView *blurEffectView;
@property (nonatomic, retain) BSUIBackdropView *blurHistoryEffectView;
@property (nonatomic, retain) UIView *blurView;
-(void) updateSceenShot: (BOOL)content isRevealed: (BOOL)isHistoryRevealed;
+ (id) sharedInstance;
@end
