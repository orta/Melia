//
//  ORFacebookSharer.m
//  Melia
//
//  Created by orta therox on 25/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORFacebookSharer.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ORFacebookSharer (){}

@end

@implementation ORFacebookSharer

NSString * const FBAccessTokenDefault = @"FBAccessTokenKey";
NSString * const FBExpiryDateDefault = @"FBExpirationDateKey";

+ (ORFacebookSharer *)sharedInstance {
    static ORFacebookSharer *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (!self) return nil;

    return self;
}

//- (BOOL)authorized {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *accessToken = [defaults valueForKey:FBAccessTokenDefault];
//    NSDate *expirationDate = [defaults valueForKey:FBExpiryDateDefault];
//    if (accessToken!=nil && expirationDate!=nil) {
//        [_faceBook setAccessToken:accessToken];
//        [_faceBook setExpirationDate:expirationDate];
//    }
//
//    return [_facebook isSessionValid];
//}


@end
