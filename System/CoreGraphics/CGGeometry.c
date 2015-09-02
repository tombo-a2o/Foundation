/* Copyright 2010 Smartmobili SARL
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <CoreGraphics/CGGeometry.h>
#include <float.h>
#include <string.h>
#include "CGBasePriv.h"
#include "CGPathPriv.h"


const CGPoint	CGPointZero		= {0, 0};
const CGRect	CGRectZero		= {{0, 0}, {0, 0}};
const CGRect	CGRectNull		= {{FLT_MAX, FLT_MAX}, {0, 0}};
const CGRect	CGRectInfinite	= {{-FLT_MIN, -FLT_MIN}, {FLT_MAX, FLT_MAX}};
const CGSize    CGSizeZero      = {0, 0};

CGFloat CGRectGetHeight(CGRect rect)
{
	return (rect.size.height);
}

CGFloat CGRectGetWidth(CGRect rect)
{
	return (rect.size.width);
}

CGFloat CGRectGetMinX(CGRect rect)
{
	return (rect.origin.x);
}

CGFloat CGRectGetMinY(CGRect rect)
{
	return (rect.origin.y);
}

CGFloat CGRectGetMidX(CGRect rect)
{
	return (rect.origin.x + rect.size.width/2);
}

CGFloat CGRectGetMidY(CGRect rect)
{
	return (rect.origin.y + rect.size.height/2);
}

CGFloat CGRectGetMaxX(CGRect rect)
{
	return (rect.origin.x + rect.size.width);
}

CGFloat CGRectGetMaxY(CGRect rect)
{
	return (rect.origin.y + rect.size.height);
}

CGRect CGRectStandardize(CGRect rect){
    CGRect ret;
    ret.origin.x = floorf(rect.origin.x);
    ret.origin.y = floorf(rect.origin.y);
    ret.size.width  = ceilf(rect.size.width  + rect.origin.x - ret.origin.x);
    ret.size.height = ceilf(rect.size.height + rect.origin.y - ret.origin.y);
    return ret;
}

bool CGRectIsEmpty(CGRect rect){
    return (rect.size.width == 0.0 && rect.size.height == 0.0) || CGRectIsNull(rect);
}

bool CGRectIsNull(CGRect rect){
    return !memcmp(&rect, &CGRectNull, sizeof(rect)) ? TRUE : FALSE;
}

bool CGRectIsInfinite(CGRect rect){
    return !memcmp(&rect, &CGRectInfinite, sizeof(rect)) ? TRUE : FALSE;
}

CGRect CGRectInset(CGRect rect, CGFloat dx, CGFloat dy){
    CGRect ret = CGRectStandardize(rect);
    ret.origin.x += dx;
    ret.origin.y += dy;
    ret.size.width -= dx*2;
    ret.size.height -= dy*2;
    if(ret.size.width <= 0 || ret.size.height <= 0) {
        return CGRectNull;
    } else {
        return ret;
    }
}

CGRect CGRectIntegral(CGRect rect){
    if(CGRectIsNull(rect)) return CGRectNull;
    CGRect ret;
    ret.origin.x = floorf(rect.origin.x);
    ret.origin.y = floorf(rect.origin.y);
    ret.size.width = ceilf(rect.size.width);
    ret.size.height = ceilf(rect.size.height);
    return ret;
}

#define L(r) (r.origin.x)
#define B(r) (r.origin.y)
#define R(r) (r.origin.x+r.size.width)
#define T(r) (r.origin.y+r.size.height)
#define W(r) (r.size.width)
#define H(r) (r.size.height)

CGRect CGRectUnion(CGRect r1, CGRect r2){
    if(CGRectIsNull(r1)) return r2;
    if(CGRectIsNull(r2)) return r1;

    CGRect ret;
    ret.origin.x = MIN(L(r1), L(r2));
    ret.origin.y = MIN(B(r1), B(r2));
    ret.size.width = MAX(R(r1), R(r2)) - L(ret);
    ret.size.height = MAX(T(r1), T(r2)) - B(ret);
    return ret;
}

CGRect CGRectIntersection(CGRect r1, CGRect r2){
    CGRect ret;
    ret.origin.x = MAX(L(r1), L(r2));  
    ret.origin.x = MAX(L(r1), L(r2));  
    ret.size.width = MIN(R(r1), R(r2)) - L(ret);
    ret.size.height = MIN(T(r1), T(r2)) - B(ret);

    if(W(ret) <= 0 || W(ret) <= 0) {
        return CGRectNull;
    } else {
        return ret;
    }
}

CGRect CGRectOffset(CGRect rect, CGFloat dx, CGFloat dy){
    if(CGRectIsNull(rect)) return CGRectNull;

    CGRect ret = rect;
    ret.origin.x += dx;
    ret.origin.y += dy;
    return ret;
}

void CGRectDivide(CGRect rect, CGRect *slice, CGRect *remainder, CGFloat amount, CGRectEdge edge){
    if(CGRectIsNull(rect)) {
        *slice = CGRectNull;
        *remainder = CGRectNull;
        return;
    }

    if( ((edge == CGRectMinXEdge || edge == CGRectMaxXEdge) && rect.size.width  < amount)
     || ((edge == CGRectMinYEdge || edge == CGRectMaxYEdge) && rect.size.height < amount)) {
        *slice = rect;
        *remainder = CGRectNull;
        return;
    }

    switch(edge) {
    case CGRectMinXEdge:
        slice->origin.x = L(rect);
        remainder->origin.x = L(rect) + amount;

        slice->size.width = amount;
        remainder->size.width = W(rect) - amount;

        slice->origin.y = remainder->origin.y = B(rect);
        slice->size.height = remainder->size.height = H(rect);
        break;
    case CGRectMinYEdge:
        slice->origin.y = B(rect);
        remainder->origin.y = B(rect) + amount;

        slice->size.height = amount;
        remainder->size.height = H(rect) - amount;

        slice->origin.x = remainder->origin.x = L(rect);
        slice->size.width = remainder->size.width = W(rect);
        break;
    case CGRectMaxXEdge:
        slice->origin.x = R(rect) - amount;
        remainder->origin.x = L(rect);

        slice->size.width = amount;
        remainder->size.width = W(rect) - amount;

        slice->origin.y = remainder->origin.y = B(rect);
        slice->size.height = remainder->size.height = H(rect);
        break;
    case CGRectMaxYEdge:
        slice->origin.y = T(rect) - amount;
        remainder->origin.y = B(rect);

        slice->size.height = amount;
        remainder->size.height = H(rect) - amount;

        slice->origin.x = remainder->origin.x = L(rect);
        slice->size.width = remainder->size.width = W(rect);
        break;
    }
    return;
}

bool CGRectContainsPoint(CGRect rect, CGPoint point){
    return L(rect) <= point.x && point.x <= R(rect) && B(rect) <= point.y && point.y <= T(rect);

}

bool CGRectContainsRect(CGRect rect1, CGRect rect2){
    return CGRectEqualToRect(CGRectUnion(rect1, rect2), rect1);
}

bool CGRectIntersectsRect(CGRect rect1, CGRect rect2){
    return !CGRectIsNull(CGRectUnion(rect1, rect2));
}

/* not implemented
CFDictionaryRef CGPointCreateDictionaryRepresentation(CGPoint point){
}

bool CGPointMakeWithDictionaryRepresentation(CFDictionaryRef dict, CGPoint *point){
}

CFDictionaryRef CGSizeCreateDictionaryRepresentation(CGSize size){
}

bool CGSizeMakeWithDictionaryRepresentation(CFDictionaryRef dict, CGSize *size){
}

CFDictionaryRef CGRectCreateDictionaryRepresentation(CGRect){
}

bool CGRectMakeWithDictionaryRepresentation(CFDictionaryRef dict, CGRect *rect){
}
*/
