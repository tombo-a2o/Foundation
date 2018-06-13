/*
 *  NSDate.m
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

#import <Foundation/NSDate.h>

#import "NSExternals.h"
#import <Foundation/NSObjectInternal.h>

#import <Foundation/NSCoder.h>

@implementation NSDate (NSDate)

- (Class)classForCoder
{
    return [NSDate self];
}

OBJC_PROTOCOL_IMPL_PUSH
- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSTimeInterval timeInterval = 0.0;
    if ([aDecoder allowsKeyedCoding])
    {
        timeInterval = [aDecoder decodeDoubleForKey:NS_time];
    }
    else
    {
        [aDecoder decodeValueOfObjCType:@encode(NSTimeInterval) at:&timeInterval];
    }
    return [self initWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate];
    if ([aCoder allowsKeyedCoding])
    {
        [aCoder encodeDouble:timeInterval forKey:NS_time];
    }
    else
    {
        [aCoder encodeValueOfObjCType:@encode(NSTimeInterval) at:&timeInterval];
    }
}
OBJC_PROTOCOL_IMPL_POP

@end

@interface NSCalendarDate : NSDate
@end

@implementation NSCalendarDate

- (id)allocWithZone:(NSZone *)zone
{
#warning TODO implement NSCalendarDate
    DEBUG_BREAK();
    return nil;
}

@end
