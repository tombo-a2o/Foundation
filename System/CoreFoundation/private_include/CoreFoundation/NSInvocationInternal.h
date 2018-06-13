/*
 *  NSInvocationInternal.h
 *  CoreFoundation
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <objc/message.h>

// By grabbing at least 4 words for retSize, we can blindly copy r0-r3
// into retdata when returning from an invocation.
#define RET_SIZE_ARGS (4 * sizeof(int))

void __invoke__(void *send, void *retdata, marg_list args, size_t len, const char *rettype);

extern void _CF_forwarding_prep_0();
extern void _CF_forwarding_prep_1();
