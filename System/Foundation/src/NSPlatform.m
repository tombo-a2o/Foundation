/*
 *  NSPlatform.m
 *  Foundation
 *
 *  Copyright (c) 2014 Apportable. All rights reserved.
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License, version 2.1.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301  USA
 */

#import <CoreFoundation/CFBundle.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSException.h>
#import <objc/runtime.h>
#import <emscripten/trace.h>
//#import "wrap.h"

extern void __CFInitialize(void);
extern char ***_NSGetArgv(void);

static void _enumerationMutationHandler(id object)
{
    [NSException raise:NSGenericException format:@"Illegal mutation while fast enumerating %@", object];
}

void NSPlatformInitialize() __attribute__((constructor(1040)));
void NSPlatformInitialize()
{
    emscripten_trace_enter_context("NSPlatformInitialize");
    __CFInitialize();
    @autoreleasepool {
        NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleExecutableKey];
#warning FIXME
        //__printf_tag = strdup([appName UTF8String]);
        //char ***argv = _NSGetArgv();
        //snprintf((*argv)[0], PATH_MAX, "%s/%s", __virtual_prefix(virtual_bundle), __printf_tag);

        objc_setEnumerationMutationHandler(_enumerationMutationHandler);
    }
    emscripten_trace_exit_context();
}
