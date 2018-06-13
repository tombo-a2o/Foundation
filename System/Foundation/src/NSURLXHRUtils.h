/*
 *  NSURLXHRUtils.h
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

#import <Foundation/NSObjCRuntime.h>

@class NSURLRequest, NSHTTPURLResponse, NSData;

FOUNDATION_EXPORT int __nsurl_xhrCreateAndOpen(NSURLRequest *request, BOOL async);
FOUNDATION_EXPORT NSHTTPURLResponse *__nsurl_createResponseFromXhr(int xhr, NSURLRequest *request);
FOUNDATION_EXPORT NSData *__nsurl_createDataFromXhr(int xhr);
