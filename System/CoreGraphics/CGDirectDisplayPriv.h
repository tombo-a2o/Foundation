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
#ifndef CGDIRECTDISPLAYPRIV_H_
#define CGDIRECTDISPLAYPRIV_H_

#include <CoreFoundation/CFRuntime.h>
#include <CoreGraphics/CGDirectDisplay.h>

#include "CGMacros.h"




typedef int     CGSConnection;
typedef int     CGSWindow;
typedef int		CGSWorkspace;
typedef int     CGSValue;

CG_EXTERN CGContextRef CGDisplayGetDrawingContext (CGDirectDisplayID display);

CG_EXTERN CGContextRef CGWindowContextCreate(CGSConnection cid, CGSWindow wid, CFDictionaryRef theDict);


#endif	/* CGDIRECTDISPLAY_H_ */
