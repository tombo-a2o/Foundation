/*
 *  NSStreamInternal.h
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

#import <Foundation/NSStream.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSObjectInternal.h>
#import <Foundation/NSInternal.h>

extern CFErrorRef _CFErrorFromStreamError(CFAllocatorRef alloc, CFStreamError *streamError);
CF_EXPORT void *_CFReadStreamGetClient(CFReadStreamRef readStream);
CF_EXPORT void *_CFWriteStreamGetClient(CFWriteStreamRef writeStream);
CF_EXPORT CFReadStreamRef CFReadStreamCreateWithData(CFAllocatorRef alloc, CFDataRef data);

@interface NSStream (CoreFoundation)
- (CFStreamError)_cfStreamError;
@end

CF_PRIVATE
@interface __NSCFInputStream : NSInputStream

+ (id)allocWithZone:(NSZone *)zone;
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key;
- (void)_unscheduleFromCFRunLoop:(CFRunLoopRef)runLoop forMode:(CFStringRef)mode;
- (void)_scheduleInCFRunLoop:(CFRunLoopRef)runLoop forMode:(CFStringRef)mode;
- (BOOL)_setCFClientFlags:(CFOptionFlags)flags callback:(CFReadStreamClientCallBack)callback context:(CFStreamClientContext *)context;
- (BOOL)hasBytesAvailable;
- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len;
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len;
- (NSError *)streamError;
- (NSStreamStatus)streamStatus;
- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
- (id)propertyForKey:(NSString *)key;
- (BOOL)setProperty:(id)property forKey:(NSString *)key;
- (id <NSStreamDelegate>)delegate;
- (void)setDelegate:(id <NSStreamDelegate>)delegate;
- (void)close;
- (void)open;
- (id)initWithURL:(NSURL *)url;
- (id)initWithFileAtPath:(NSString *)path;
- (id)initWithData:(NSData *)data;
- (NSUInteger)retainCount;
- (BOOL)_isDeallocating;
- (BOOL)_tryRetain;
- (oneway void)release;
- (id)retain;
- (NSUInteger)hash;
- (BOOL)isEqual:(id)other;

@end

CF_PRIVATE
@interface __NSCFOutputStream : NSOutputStream

+ (id)allocWithZone:(NSZone *)zone;
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key;
- (void)_unscheduleFromCFRunLoop:(CFRunLoopRef)runLoop forMode:(CFStringRef)mode;
- (void)_scheduleInCFRunLoop:(CFRunLoopRef)runLoop forMode:(CFStringRef)mode;
- (BOOL)_setCFClientFlags:(CFOptionFlags)flags callback:(CFWriteStreamClientCallBack)callback context:(CFStreamClientContext *)context;
- (BOOL)hasSpaceAvailable;
- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len;
- (NSError *)streamError;
- (NSStreamStatus)streamStatus;
- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
- (id)propertyForKey:(NSString *)key;
- (BOOL)setProperty:(id)property forKey:(NSString *)key;
- (id <NSStreamDelegate>)delegate;
- (void)setDelegate:(id <NSStreamDelegate>)delegate;
- (void)close;
- (void)open;
- (id)initWithURL:(NSURL *)url append:(BOOL)shouldAppend;
- (id)initToFileAtPath:(NSString *)path append:(BOOL)shouldAppend;
- (id)initToBuffer:(uint8_t *)buffer capacity:(NSUInteger)capacity;
- (id)initToMemory;
- (NSUInteger)retainCount;
- (BOOL)_isDeallocating;
- (BOOL)_tryRetain;
- (oneway void)release;
- (id)retain;
- (NSUInteger)hash;
- (BOOL)isEqual:(id)other;

@end
