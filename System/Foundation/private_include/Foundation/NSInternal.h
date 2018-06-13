/*
 *  NSInternal.h
 *  Foundation
 *
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

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/NSString.h>

CF_EXPORT void _CFRuntimeBridgeClasses(CFTypeID type, const char *name);
CF_EXPORT CFTypeRef _CFTryRetain(CFTypeRef cf);
CF_EXPORT Boolean _CFIsDeallocating(CFTypeRef cf);
CF_EXPORT CFHashCode CFHashBytes(UInt8 *bytes, CFIndex length);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

static const void * _NSCFCopy(CFAllocatorRef allocator, const void *value)
{
    return [(NSObject *)value copy];
}

static const void * _NSCFRetain2(CFAllocatorRef allocator, const void *value)
{
    return [(NSObject *)value retain];
}

static void _NSCFRelease2(CFAllocatorRef allocator, const void *value)
{
    [(NSObject *)value release];
}

static const void * _NSCFRetain(const void *info)
{
    return (void *)[(NSObject *)info retain];
}

static void _NSCFRelease(const void *info)
{
    [(NSObject *)info release];
}

static CFStringRef _NSCFCopyDescription(const void *value)
{
    return (CFStringRef)[[(NSObject *)value description] copy];
}

static CFStringRef _NSCFCopyDescription2(void *value, const void *formatOpts)
{
    return (CFStringRef)[[(NSObject *)value description] copy];
}

static Boolean _NSCFEqual(const void *value1, const void *value2)
{
    if (value1 == value2) {
        return true;
    }
    return [(NSObject *)value1 isEqual:(NSObject *)value2];
}

static CFHashCode _NSCFHash(const void *value)
{
    return [(NSObject *)value hash];
}

#pragma clang diagnostic pop
