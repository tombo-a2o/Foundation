/*
 *  NSArchiver.m
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

#import <Foundation/NSArchiver.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>
#import <CoreFoundation/CFDictionary.h>
#import <CoreFoundation/CFSet.h>
#import <dispatch/dispatch.h>

@implementation NSObject (NSArchiverCallBack)

- (id)replacementObjectForArchiver:(NSArchiver *)archiver
{
    return self;
}

- (Class)classForArchiver
{
    return [self classForCoder];
}

@end

@implementation NSArchiver {
    NSMutableData *mdata;
    void *ids;
    NSMutableDictionary *map;
    CFMutableDictionaryRef replacementTable;
}

+ (BOOL)archiveRootObject:(id)object toFile:(NSString *)path
{
    NSData *data = [self archivedDataWithRootObject:object];
    return [data writeToFile:path atomically:YES];
}

+ (id)archivedDataWithRootObject:(id)object
{
    NSMutableData *data = [NSMutableData data];
    @autoreleasepool {
        NSArchiver *archiver = [[[self alloc] initForWritingWithMutableData:data] autorelease];
        [archiver encodeRootObject:object];
    }
    return data;
}

static dispatch_once_t encodedClassNamesOnce = 0L;
static NSMutableDictionary *encodedClassNames = nil;

+ (NSString *)classNameEncodedForTrueClassName:(NSString *)name
{
    dispatch_once(&encodedClassNamesOnce, ^{
        encodedClassNames = [[NSMutableDictionary alloc] init];
    });
    return [encodedClassNames objectForKey:name];
}

+ (void)encodeClassName:(NSString *)name intoClassName:(NSString *)encoded
{
    dispatch_once(&encodedClassNamesOnce, ^{
        encodedClassNames = [[NSMutableDictionary alloc] init];
    });
    [encodedClassNames setObject:encoded forKey:name];
}

+ (void)initialize
{
    // I am surprised this is the only one that hits...
    [NSArchiver encodeClassName:@"__NSLocalTimeZone" intoClassName:@"NSLocalTimeZone"];
}

- (NSString *)classNameEncodedForTrueClassName:(NSString *)name
{
    if (map == nil)
    {
        map = [[NSMutableDictionary alloc] init];
    }
    NSString *encodedName = [map objectForKey:name];
    if (encodedName == nil)
    {
        encodedName = [NSArchiver classNameEncodedForTrueClassName:name];
    }
    if (encodedName == nil)
    {
        encodedName = name;
    }
    return encodedName;
}

- (void)encodeClassName:(NSString *)name intoClassName:(NSString *)encoded
{
    if (map == nil)
    {
        map = [[NSMutableDictionary alloc] init];
    }
    [map setObject:encoded forKey:name];
}

- (void)encodeConditionalObject:(id)object
{
    if (mdata != NULL)
    {
        if (ids == NULL)
        {
            // fault; throw exception here for requiring encodeRootObject:
        }
        id replacement = nil;
        if (replacementTable == NULL)
        {
            replacementTable = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
        }
        if (!CFDictionaryGetValueIfPresent(replacementTable, object, (const void **)&replacement))
        {
            replacement = [object replacementObjectForArchiver:self];
            CFDictionarySetValue(replacementTable, object, replacement);
        }

        // CFSetGetValue(ids, replacement) ?

        if (replacement != nil)
        {
            [self encodeObject:object];
        }
    }
}

- (void)encodeRootObject:(id)object
{

}

- (void)encodeDataObject:(NSData *)object
{
    int len = [object length];
    const void *bytes = [object bytes];
    [self encodeValueOfObjCType:@encode(int) at:&len];
    [self encodeArrayOfObjCType:@encode(char) count:len at:bytes];
}

- (id)initForWritingWithMutableData:(NSMutableData *)data
{
    self = [super init];
    if (self)
    {
        mdata = [data retain];
    }
    return self;
}

@end

@implementation NSUnarchiver  {
}

@end

