/*
 *  NSTimeZoneInternal.h
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

#import <Foundation/NSTimeZone.h>
#import <Foundation/NSInternal.h>

CF_PRIVATE
@interface __NSPlaceholderTimeZone : NSTimeZone

+ (id)immutablePlaceholder;
+ (void)initialize;
- (NSDate *)nextDaylightSavingTimeTransitionAfterDate:(NSDate *)aDate;
- (NSTimeInterval)daylightSavingTimeOffsetForDate:(NSDate *)aDate;
- (BOOL)isDaylightSavingTimeForDate:(NSDate *)aDate;
- (NSString *)abbreviationForDate:(NSDate *)aDate;
- (NSInteger)secondsFromGMTForDate:(NSDate *)aDate;
- (NSData *)data;
- (NSString *)name;
- (void)dealloc;
- (NSUInteger)retainCount;
- (oneway void)release;
- (id)retain;
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)__initWithName:(NSString *)name cache:(BOOL)shouldCache;
- (id)initWithName:(NSString *)name data:(NSData *)data;
- (id)__initWithName:(NSString *)name data:(NSData *)data cache:(BOOL)shouldCache;

@end

CF_PRIVATE
@interface __NSTimeZone : NSTimeZone

+ (id)allocWithZone:(NSZone *)zone;
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key;
+ (id)__new:(CFStringRef)name cache:(BOOL)shouldCache;
+ (id)__new:(CFStringRef)name data:(CFDataRef)data;
- (void)dealloc;
- (NSString *)localizedName:(NSTimeZoneNameStyle)style locale:(NSLocale *)locale;
- (NSDate *)nextDaylightSavingTimeTransitionAfterDate:(NSDate *)aDate;
- (NSTimeInterval)daylightSavingTimeOffsetForDate:(NSDate *)aDate;
- (BOOL)isDaylightSavingTimeForDate:(NSDate *)aDate;
- (NSString *)abbreviationForDate:(NSDate *)aDate;
- (NSInteger)secondsFromGMTForDate:(NSDate *)aDate;
- (NSData *)data;
- (NSString *)name;

@end
