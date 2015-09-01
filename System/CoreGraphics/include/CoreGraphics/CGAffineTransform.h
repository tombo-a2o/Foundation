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

#ifndef CGAFFINETRANSFORM_H_
#define CGAFFINETRANSFORM_H_

typedef struct CGAffineTransform CGAffineTransform;

#include <CoreGraphics/CGBase.h>
#include <CoreGraphics/CGGeometry.h>

struct CGAffineTransform {
  CGFloat a, b, c, d;
  CGFloat tx, ty;
};

/* constants */
CG_EXTERN const CGAffineTransform CGAffineTransformIdentity;

/* functions */
CG_EXTERN CGAffineTransform CGAffineTransformMake (
	CGFloat a, CGFloat b,
	CGFloat c, CGFloat d, CGFloat tx, CGFloat ty);

CG_EXTERN CGAffineTransform CGAffineTransformMakeRotation(CGFloat angle);

CG_EXTERN CGAffineTransform CGAffineTransformMakeScale(CGFloat sx, CGFloat sy);

CG_EXTERN CGAffineTransform CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty);

/* Modifying Affine Transformations */ 
CG_EXTERN CGAffineTransform CGAffineTransformTranslate(CGAffineTransform t, 
CGFloat tx, CGFloat ty);

CG_EXTERN CGAffineTransform CGAffineTransformScale(CGAffineTransform t,
  CGFloat sx, CGFloat sy);

CG_EXTERN CGAffineTransform CGAffineTransformRotate(CGAffineTransform t,
  CGFloat angle);

CG_EXTERN CGAffineTransform CGAffineTransformInvert(CGAffineTransform t);

CG_EXTERN CGAffineTransform CGAffineTransformConcat(CGAffineTransform t1,
  CGAffineTransform t2);
  
/* Applying Affine Transformations */

CG_EXTERN bool CGAffineTransformEqualToTransform(CGAffineTransform t1,
  CGAffineTransform t2);


CG_EXTERN CGPoint CGPointApplyAffineTransform(CGPoint point,
  CGAffineTransform t);


CG_EXTERN CGSize CGSizeApplyAffineTransform(CGSize size, CGAffineTransform t);


CG_EXTERN CGRect CGRectApplyAffineTransform(CGRect rect, CGAffineTransform t);

/* Evaluating Affine Transforms */

CG_EXTERN bool CGAffineTransformIsIdentity(CGAffineTransform t);

/* inline functions */
CG_INLINE CGAffineTransform __CGAffineTransformMake(CGFloat a, CGFloat b, 
 CGFloat c, CGFloat d, CGFloat tx, CGFloat ty)
{
  CGAffineTransform at;
  at.a = a; at.b = b; at.c = c; at.d = d; 
  at.tx = tx; at.ty = ty;
  return at;
}
#define CGAffineTransformMake __CGAffineTransformMake

CG_INLINE CGPoint
__CGPointApplyAffineTransform(CGPoint point, CGAffineTransform t)
{
  CGPoint p;
  p.x = (CGFloat)((double)t.a * point.x + (double)t.c * point.y + t.tx);
  p.y = (CGFloat)((double)t.b * point.x + (double)t.d * point.y + t.ty);
  return p;
}
#define CGPointApplyAffineTransform __CGPointApplyAffineTransform

CG_INLINE CGSize
__CGSizeApplyAffineTransform(CGSize size, CGAffineTransform t)
{
  CGSize s;
  s.width  = (CGFloat)((double)t.a * size.width + (double)t.c * size.height);
  s.height = (CGFloat)((double)t.b * size.width + (double)t.d * size.height);
  return s;
}
#define CGSizeApplyAffineTransform __CGSizeApplyAffineTransform

CG_INLINE CGRect
__CGRectApplyAffineTransform(CGRect rect, CGAffineTransform t)
{
  CGRect r;

  double x1 = (double)t.a * rect.size.width;
  double x2 = (double)t.c * rect.size.height;
  double y1 = (double)t.b * rect.size.width;
  double y2 = (double)t.d * rect.size.height;
  // left = min(0, x1, x2, x1+x2) = min(x1,0) + min(x2,0)
  // bottom = min(0, y1, y2, y1+y2) = min(y1,0) + min(y2,0)

#define _min(x,y) (x>y ? y : x)
#define _min4(x1,x2) (_min(x1,0)+_min(x2,0))
#define _abs(x) (x>=0 ? x : -x)

  r.origin.x = (CGFloat)((double)t.a * rect.origin.x + (double)t.c * rect.origin.y + t.tx + _min4(x1,x2));
  r.origin.y = (CGFloat)((double)t.b * rect.origin.x + (double)t.d * rect.origin.y + t.ty + _min4(y1,y2));
  r.size.width = (CGFloat)(_abs(x1) + _abs(x2));
  r.size.height = (CGFloat)(_abs(y1) + _abs(y2));

#undef _min
#undef _min4
#undef _abs

  return r;
}
#define CGRectApplyAffineTransform __CGRectApplyAffineTransform

#endif /* CGAFFINETRANSFORM_H_ */
