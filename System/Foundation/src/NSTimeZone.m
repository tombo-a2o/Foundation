/*
 *  NSTimeZone.m
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

#import <Foundation/NSTimeZone.h>

#import <Foundation/NSObjectInternal.h>

@implementation NSTimeZone (NSTimeZone)

OBJC_PROTOCOL_IMPL_PUSH
- (id)initWithCoder:(NSCoder *)coder
{
    NSRequestConcreteImplementation();
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    NSRequestConcreteImplementation();
}
OBJC_PROTOCOL_IMPL_POP

- (Class)classForCoder
{
    return [NSTimeZone self];
}

@end
