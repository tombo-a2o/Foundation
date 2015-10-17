#import <Foundation/NSGeometry.h>
#import <CoreGraphics/CGGeometry.h>

/*
void NSDivideRect(NSRect aRect, NSRect *slice, NSRect *remainder, CGFloat amount, NSRectEdge edge) {
}
*/

NSRect NSIntegralRect(NSRect aRect) {
    return CGRectIntegral(aRect);
}

BOOL NSEqualRects(NSRect aRect, NSRect bRect) {
    return CGRectEqualToRect(aRect, bRect);
}

BOOL NSEqualSizes(NSSize aSize, NSSize bSize) {
    return CGSizeEqualToSize(aSize, bSize);
}

BOOL NSEqualPoints(NSPoint aPoint, NSPoint bPoint) {
    return CGPointEqualToPoint(aPoint, bPoint);
}
