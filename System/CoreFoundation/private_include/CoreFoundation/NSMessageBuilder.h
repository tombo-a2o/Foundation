/*
 *  NSMessageBuilder.h
 *  CoreFoundation
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSInvocation.h>
#import <Foundation/NSMethodSignature.h>

extern id _NSMessageBuilder(id proxy, NSInvocation **inv, SEL _cmd, void *arg);

NS_ROOT_CLASS
@interface __NSMessageBuilder
{
@public
    Class isa;
    id _target;
    id *_addr;
}

+ (void)initialize;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel;
- (void)forwardInvocation:(NSInvocation *)inv;

@end
