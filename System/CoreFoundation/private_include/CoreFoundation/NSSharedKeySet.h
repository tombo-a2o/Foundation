/*
 *  NSSharedKeySet.h
 *  CoreFoundation
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSArray.h>

@class NSString;

@interface NSSharedKeySet : NSObject <NSFastEnumeration, NSCopying, NSCoding>
{
    NSUInteger _numKey;
    id *_keys;
    NSSharedKeySet *_subSharedKeySet;
}

+ (id)keySetWithKeys:(NSArray *)keys;
- (NSUInteger)keySetCount;
- (void)dealloc;
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
- (id)keyAtIndex:(NSUInteger)index;
- (NSUInteger)indexForKey:(id)key;
- (NSArray *)allKeys;
- (NSUInteger)maximumIndex;
- (BOOL)isEmpty;
- (NSUInteger)count;
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)copyWithZone:(NSZone *)zone;
- (id)init;
- (id)initWithKeys:(id *)keys count:(NSUInteger)count;
- (void)createSubclassCode:(NSString *)subclassName interface:(CFStringRef *)interface implementation:(CFStringRef *)implementation;

@end
