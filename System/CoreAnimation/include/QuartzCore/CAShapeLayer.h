#import <QuartzCore/CALayer.h>

extern NSString *const kCAFillRuleNonZero;
extern NSString *const kCAFillRuleEvenOdd;
extern NSString *const kCALineJoinMiter;
extern NSString *const kCALineJoinRound;
extern NSString *const kCALineJoinBevel;
extern NSString *const kCALineCapButt;
extern NSString *const kCALineCapRound;
extern NSString *const kCALineCapSquare;

@interface CAShapeLayer : CALayer
@property CGPathRef path;
@property CGColorRef fillColor;
@property(copy) NSString *fillRule;
@property(copy) NSString *lineCap;
@property(copy) NSArray *lineDashPattern;
@property CGFloat lineDashPhase;
@property(copy) NSString *lineJoin;
@property CGFloat lineWidth;
@property CGFloat miterLimit;
@property CGColorRef strokeColor;
@property CGFloat strokeStart;
@property CGFloat strokeEnd;
@end
