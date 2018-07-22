CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
    return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}

CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}

CGRect CGRectSetSize(CGRect rect, CGSize size) {
    return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}

CGRect CGRectSetX(CGRect rect, CGFloat x) {
    return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectSetY(CGRect rect, CGFloat y) {
    return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}

CGRect CGRectSetOrigin(CGRect rect, CGPoint origin) {
    return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}

@implementation UIView (TCSetFrame)

// width
- (void) setFrameWidth:(CGFloat)width {
    self.frame = CGRectSetWidth(self.frame, width); // You could also use a full CGRectMake() function here, if you'd rather.
}
- (CGFloat) frameWidth {
    return self.frame.size.width;
}

// height
- (void) setFrameHeight:(CGFloat)height {
    self.frame = CGRectSetHeight(self.frame, height); // You could also use a full CGRectMake() function here, if you'd rather.
}
- (CGFloat) frameHeight {
    return self.frame.size.height;
}

// size
- (void) setFrameSize:(CGSize)size {
    self.frame = CGRectSetSize(self.frame, size); // You could also use a full CGRectMake() function here, if you'd rather.
}
- (CGSize) frameSize {
    return self.frame.size;
}

// x origin
- (void) setFrameX:(CGFloat)x {
    self.frame = CGRectSetX(self.frame, x); // You could also use a full CGRectMake() function here, if you'd rather.
}
- (CGFloat) frameX {
    return self.frame.origin.x;
}

// y origin
- (void) setFrameY:(CGFloat) y {
    self.frame = CGRectSetY(self.frame, y); // You could also use a full CGRectMake() function here, if you'd rather.
}
- (CGFloat) frameY {
    return self.frame.origin.y;
}

// origin
- (void) setFrameOrigin:(CGPoint) origin {
    self.frame = CGRectSetOrigin(self.frame, origin); // You could also use a full CGRectMake() function here, if you'd rather.
}
- (CGPoint) frameOrigin {
    return self.frame.origin;
}
@end

