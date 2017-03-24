//
//  NSURLCredentialStorage.m
//  Foundation
//
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/NSURLCredentialStorage.h>

NSString *const NSURLCredentialStorageChangedNotification = @"NSURLCredentialStorageChangedNotification";

@implementation NSURLCredentialStorage

+ (NSURLCredentialStorage *)sharedCredentialStorage
{
    static NSURLCredentialStorage *sharedStorage = nil;
    static dispatch_once_t once = 0L;
    dispatch_once(&once, ^{
        sharedStorage = [[NSURLCredentialStorage alloc] init];
    });
    return sharedStorage;
}

- (NSDictionary *)credentialsForProtectionSpace:(NSURLProtectionSpace *)space
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (NSDictionary *)allCredentials
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)setCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)removeCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (NSURLCredential *)defaultCredentialForProtectionSpace:(NSURLProtectionSpace *)space
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)setDefaultCredential:(NSURLCredential *)credential forProtectionSpace:(NSURLProtectionSpace *)space
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
