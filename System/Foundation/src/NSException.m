/*
 *  NSException.m
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

#import <Foundation/NSException.h>
#import <Foundation/NSObjectInternal.h>

#import <Foundation/NSString.h>

#import <dispatch/dispatch.h>
#import <objc/runtime.h>
//#import <libv/libv.h>
#import <unistd.h>
#import <objc/objc-exception.h>

static NSUncaughtExceptionHandler *handler = nil;
BOOL NSHangOnUncaughtException = NO;

NSUncaughtExceptionHandler *NSGetUncaughtExceptionHandler(void)
{
    return handler;
}

static void _NSExceptionHandler(id exception, void *context)
{
    if (handler != NULL)
    {
        //while (!__is_being_debugged__ && NSHangOnUncaughtException)
        while (NSHangOnUncaughtException)
        {
            usleep(100);
        }
        handler(exception);
    }
}

void NSSetUncaughtExceptionHandler(NSUncaughtExceptionHandler *h)
{
    handler = h;
    if (handler != NULL)
    {
        objc_setUncaughtExceptionHandler(&_NSExceptionHandler);
    }
    else
    {
        objc_setUncaughtExceptionHandler(NULL);
    }
}

NSString *_NSFullMethodName(id object, SEL selector)
{
    Class c = NSClassFromObject(object);
    const char *className = c ? class_getName(c) : "nil";

    return [NSString stringWithFormat:@"%c[%s %s]", (c == object ? '+' : '-'), className, sel_getName(selector)];
}

NSString *_NSMethodExceptionProem(id object, SEL selector)
{
    Class c = NSClassFromObject(object);
    const char *className = c ? class_getName(c) : "nil";

    return [NSString stringWithFormat:@"*** %c[%s %s]", (c == object ? '+' : '-'), className, sel_getName(selector)];
}

@implementation NSAssertionHandler

+ (NSAssertionHandler *)currentHandler
{
    static NSAssertionHandler *current = nil;
    static dispatch_once_t once = 0L;
    dispatch_once(&once, ^{
        current = [[NSAssertionHandler alloc] init];
    });
    return current;
}

- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format,...
{
    Class cls = [object class];
    const char *className = class_getName(cls);
    BOOL instance = YES;
    if (class_isMetaClass(cls))
    {
        instance = NO;
    }
    RELEASE_LOG("*** Assertion failure in %c[%s %s], %s:%ld", instance ? '-' : '+', className, sel_getName(selector), [fileName UTF8String], (long)line);
    va_list args;
    va_start(args, format);
    [NSException raise:NSInternalInconsistencyException format:format arguments:args];
    va_end(args);
}

- (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format,...
{
    RELEASE_LOG("*** Assertion failure in %s, %s:%ld", [functionName UTF8String], [fileName UTF8String], (long)line);
    va_list args;
    va_start(args, format);
    [NSException raise:NSInternalInconsistencyException format:format arguments:args];
    va_end(args);
}

@end
