/*
 *  NSCalendar.m
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

#import <Foundation/NSCalendarInternal.h>
#import <Foundation/NSObjectInternal.h>
#import <Foundation/NSNotification.h>

@implementation NSCalendar (NSCalendar)

OBJC_PROTOCOL_IMPL_PUSH
+ (id)autoupdatingCurrentCalendar
{
    return [[[NSAutoCalendar alloc] init] autorelease];
}
OBJC_PROTOCOL_IMPL_POP

@end


@implementation NSAutoCalendar {
    NSCalendar *cal;
    NSLocale *changedLocale;
    NSTimeZone *changedTimeZone;
    NSUInteger changedFirstWeekday;
    NSUInteger changedMinimumDaysinFirstWeek;
    NSDate *changedGregorianStartDate;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        cal = [[NSCalendar currentCalendar] retain];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(_update:) name:(NSString *)kCFLocaleCurrentLocaleDidChangeNotification object:nil];
        [center addObserver:self selector:@selector(_update:) name:(NSString *)kCFTimeZoneSystemTimeZoneDidChangeNotification object:nil];
    }
    return self;
}

- (id)initWithCalendarIdentifier:(NSString *)ident
{
    return [self init];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [cal release];
    [super dealloc];
}

- (NSString *)calendarIdentifier
{
    return [cal calendarIdentifier];
}

- (void)setLocale:(NSLocale *)locale
{
    [cal setLocale:locale];
}

- (NSLocale *)locale
{
    return [cal locale];
}

- (void)setTimeZone:(NSTimeZone *)tz
{
    [cal setTimeZone:tz];
}

- (NSTimeZone *)timeZone
{
    return [cal timeZone];
}

- (void)setFirstWeekday:(NSUInteger)weekday
{
    [cal setFirstWeekday:weekday];
}

- (NSUInteger)firstWeekday
{
    return [cal firstWeekday];
}

- (void)setMinimumDaysInFirstWeek:(NSUInteger)mdw
{
    [cal setMinimumDaysInFirstWeek:mdw];
}

- (NSUInteger)minimumDaysInFirstWeek
{
    return [cal minimumDaysInFirstWeek];
}

- (NSRange)minimumRangeOfUnit:(NSCalendarUnit)unit
{
    return [cal minimumRangeOfUnit:unit];
}

- (NSRange)maximumRangeOfUnit:(NSCalendarUnit)unit
{
    return [cal maximumRangeOfUnit:unit];
}

- (NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date
{
    return [cal rangeOfUnit:smaller inUnit:larger forDate:date];
}

- (NSUInteger)ordinalityOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date
{
    return [cal ordinalityOfUnit:smaller inUnit:larger forDate:date];
}

- (BOOL)rangeOfUnit:(NSCalendarUnit)unit startDate:(NSDate **)datep interval:(NSTimeInterval *)tip forDate:(NSDate *)date
{
    return [cal rangeOfUnit:unit startDate:datep interval:tip forDate:date];
}

- (NSDate *)dateFromComponents:(NSDateComponents *)comps
{
    return [cal dateFromComponents:comps];
}

- (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)date
{
    return [cal components:unitFlags fromDate:date];
}

- (NSDate *)dateByAddingComponents:(NSDateComponents *)comps toDate:(NSDate *)date options:(NSUInteger)opts
{
    return [cal dateByAddingComponents:comps toDate:date options:opts];
}

- (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate options:(NSUInteger)opts
{
    return [cal components:unitFlags fromDate:startingDate toDate:resultDate options:opts];
}

- (void)_update:(NSNotification *)notif
{
    [cal release];
    cal = [[NSCalendar currentCalendar] retain];
}

@end
