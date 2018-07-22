// https://stackoverflow.com/questions/9537573/ios-frame-change-one-property-eg-width/14116702


@interface UIView (TCSetFrame)
- (void) setFrameWidth:(CGFloat)width;
- (CGFloat) frameWidth;
- (void) setFrameHeight:(CGFloat)height;
- (CGFloat) frameHeight;
- (void) setFrameSize:(CGSize)size;
- (CGSize) frameSize;
- (void) setFrameX:(CGFloat)x;
- (CGFloat) frameX;
- (void) setFrameY:(CGFloat) y;
- (CGFloat) frameY;
- (void) setFrameOrigin:(CGPoint) origin;
- (CGPoint) frameOrigin;
@end

CGRect CGRectSetWidth(CGRect rect, CGFloat width);
CGRect CGRectSetHeight(CGRect rect, CGFloat height);
CGRect CGRectSetSize(CGRect rect, CGSize size);
CGRect CGRectSetX(CGRect rect, CGFloat x);
CGRect CGRectSetY(CGRect rect, CGFloat y);
CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);
