//
//  ZooZUser.h
//  ZooZSDK
//
//  Created by Ronen Morecki on 12/15/11.
//  Copyright (c) 2011 ZooZ.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZooZUserAddress.h"

@interface ZooZUser : NSObject{
@private
	NSString *firstName;
	NSString *lastName;
	NSString *phoneNumber;
	NSString *email;
	NSString *zoozId;
	NSString *additionalInfo;
	ZooZUserAddress *address;
}

@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;
@property(nonatomic, retain) NSString *phoneNumber;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *zoozId; 
@property(nonatomic, retain) NSString *additionalInfo;
@property(nonatomic, readonly) ZooZUserAddress *address;


@end
