//
//  ZooZResponse.h
//  iMenu
//
//  Created by Ronen Morecki on 6/22/11.
//  Copyright 2011 ZooZ.comAll rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZooZPaymentResponse : NSObject {
	NSString *cardType;
	NSString *cardDisplayString;
	NSString *transactionId;
	NSString *paymentToken;
	float paidAmount;
}

@property(nonatomic, retain) NSString *cardType;
@property(nonatomic, retain) NSString *cardDisplayString;
@property(nonatomic, retain) NSString *transactionId;
@property(nonatomic, retain) NSString *paymentToken;
@property(nonatomic) float paidAmount;
@end
