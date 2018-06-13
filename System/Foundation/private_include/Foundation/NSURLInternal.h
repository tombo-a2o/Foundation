/*
 *  NSURLInternal.h
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

#import <Foundation/NSURL.h>
#import <CoreFoundation/CFPriv.h>
#import <CoreFoundation/CFURL.h>

CF_EXPORT CFURLRef _CFURLAlloc(CFAllocatorRef allocator);
CF_EXPORT void _CFURLInitWithString(CFURLRef url, CFStringRef string, CFURLRef baseURL);
CF_EXPORT void _CFURLInitFSPath(CFURLRef url, CFStringRef path);
CF_EXPORT Boolean _CFStringIsLegalURLString(CFStringRef string);
CF_EXPORT void *__CFURLReservedPtr(CFURLRef  url);
CF_EXPORT void __CFURLSetReservedPtr(CFURLRef  url, void *ptr);
CF_EXPORT CFStringEncoding _CFURLGetEncoding(CFURLRef url);
CF_EXPORT Boolean _CFURLIsFileReferenceURL(CFURLRef url);
CF_EXPORT Boolean _CFURLCopyComponents(CFURLRef url, CFURLComponentDecomposition decompositionType, void *components);
CF_EXPORT Boolean _CFURLIsFileURL(CFURLRef url);
CF_EXPORT void *__CFURLResourceInfoPtr(CFURLRef url);
CF_EXPORT void __CFURLSetResourceInfoPtr(CFURLRef url, void *ptr);
@interface NSURL (Internal)
- (CFURLRef)_cfurl;
@end
