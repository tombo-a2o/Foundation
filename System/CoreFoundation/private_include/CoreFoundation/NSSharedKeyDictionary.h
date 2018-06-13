/*
 *  NSSharedKeyDictionary.h
 *  CoreFoundation
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSDictionary.h>
#import <CoreFoundation/NSSharedKeySet.h>

@interface NSSharedKeyDictionary : NSMutableDictionary {
    NSSharedKeySet *_keyMap;
    NSUInteger _count;
    id *_values;
    NSUInteger (*_ifkIMP)(id,SEL,id);
    NSMutableDictionary *_sideDic;
    NSUInteger _mutations;
}

+ (id)sharedKeyDictionaryWithKeySet:(NSSharedKeySet *)keySet;
- (id)initWithKeySet:(NSSharedKeySet *)keySet;
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;
- (Class)classForCoder;
- (id)mutableCopyWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (void)dealloc;
- (NSSharedKeySet *)keySet;
- (void)removeObjectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
- (NSEnumerator *)keyEnumerator;
- (void)getObjects:(id *)objects andKeys:(id *)keys count:(NSUInteger)count;
- (id)objectForKey:(id)key;
- (NSUInteger)count;

@end
