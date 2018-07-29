// https://stackoverflow.com/questions/9537573/ios-frame-change-one-property-eg-width/14116702


@interface UIView (TCSetFrame)
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;
@property (nonatomic) CGSize frameSize;
@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;
@property (nonatomic) CGPoint frameOrigin;
@end

@interface UIVisualEffectView (TCSetFrame)
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;
@property (nonatomic) CGSize frameSize;
@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;
@property (nonatomic) CGPoint frameOrigin;
@end

CGRect CGRectSetWidth(CGRect rect, CGFloat width);
CGRect CGRectSetHeight(CGRect rect, CGFloat height);
CGRect CGRectSetSize(CGRect rect, CGSize size);
CGRect CGRectSetX(CGRect rect, CGFloat x);
CGRect CGRectSetY(CGRect rect, CGFloat y);
CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);
