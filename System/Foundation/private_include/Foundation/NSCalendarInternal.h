/*
 *  NSCalendarInternal.h
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

#import <Foundation/NSCalendar.h>
#import <CoreFoundation/ForFoundationOnly.h>

CF_PRIVATE
@interface __NSCFCalendar : NSCalendar

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key;
- (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate options:(NSUInteger)opts;
- (NSDate *)dateByAddingComponents:(NSDateComponents *)comps toDate:(NSDate *)date options:(NSUInteger)opts;
- (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)date;
- (NSDate *)dateFromComponents:(NSDateComponents *)comps;
- (BOOL)rangeOfUnit:(NSCalendarUnit)unit startDate:(NSDate **)datep interval:(NSTimeInterval *)tip forDate:(NSDate *)date;
- (NSUInteger)ordinalityOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
- (NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
- (NSRange)minimumRangeOfUnit:(NSCalendarUnit)unit;
- (NSRange)maximumRangeOfUnit:(NSCalendarUnit)unit;
- (NSDate *)gregorianStartDate;
- (void)setGregorianStartDate:(NSDate *)date;
- (void)setMinimumDaysInFirstWeek:(NSUInteger)mdw;
- (NSUInteger)minimumDaysInFirstWeek;
- (void)setFirstWeekday:(NSUInteger)weekday;
- (NSUInteger)firstWeekday;
- (void)setTimeZone:(NSTimeZone *)tz;
- (NSTimeZone *)timeZone;
- (void)setLocale:(NSLocale *)locale;
- (NSLocale *)locale;
- (id)initWithCalendarIdentifier:(NSString *)ident;
- (NSString *)calendarIdentifier;
- (id)copyWithZone:(NSZone *)zone;
- (NSUInteger)retainCount;
- (BOOL)_isDeallocating;
- (BOOL)_tryRetain;
- (oneway void)release;
- (id)retain;
- (NSUInteger)hash;
- (BOOL)isEqual:(id)other;

@end

@class NSNotification;

CF_PRIVATE
@interface NSAutoCalendar : NSCalendar

- (id)init;
- (id)initWithCalendarIdentifier:(NSString *)ident;
- (void)dealloc;
- (NSString *)calendarIdentifier;
- (void)setLocale:(NSLocale *)locale;
- (NSLocale *)locale;
- (void)setTimeZone:(NSTimeZone *)tz;
- (NSTimeZone *)timeZone;
- (void)setFirstWeekday:(NSUInteger)weekday;
- (NSUInteger)firstWeekday;
- (void)setMinimumDaysInFirstWeek:(NSUInteger)mdw;
- (NSUInteger)minimumDaysInFirstWeek;
- (NSRange)minimumRangeOfUnit:(NSCalendarUnit)unit;
- (NSRange)maximumRangeOfUnit:(NSCalendarUnit)unit;
- (NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
- (NSUInteger)ordinalityOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
- (BOOL)rangeOfUnit:(NSCalendarUnit)unit startDate:(NSDate **)datep interval:(NSTimeInterval *)tip forDate:(NSDate *)date;
- (NSDate *)dateFromComponents:(NSDateComponents *)comps;
- (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)date;
- (NSDate *)dateByAddingComponents:(NSDateComponents *)comps toDate:(NSDate *)date options:(NSUInteger)opts;
- (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate options:(NSUInteger)opts;
- (void)_update:(NSNotification *)notif;

@end

@interface NSDateComponents (Internal)

- (NSInteger)nanosecond;
- (void)setNanosecond:(NSInteger)nsec;

@end

Boolean _CFCalendarComposeAbsoluteTimeV(CFCalendarRef calendar, /* out */ CFAbsoluteTime *atp, const char *componentDesc, int *vector, int count);
Boolean _CFCalendarAddComponentsV(CFCalendarRef calendar, /* inout */ CFAbsoluteTime *atp, CFOptionFlags options, const char *componentDesc, int *vector, int count);
