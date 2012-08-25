//
//  ZooZPaymentRequest.h
//  iMenu
//
//  Created by Ronen Morecki on 6/16/11.
//  Copyright 2011 ZooZ.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZooZUser.h"
#import "ZooZInvoice.h"

@interface ZooZPaymentRequest : NSObject 

-(id)initWithAmount:(float)value andInvoiceReference:(NSString *)invNumber;
-(void)addItem:(ZooZInvoiceItem *)item;

//private properties for ZooZ use
@property (nonatomic, retain) NSString * selectedFundSourceId;
@property (nonatomic, retain) NSString * fundTypes;
@property (nonatomic, retain) NSString * currencyCode;

//Properties that can be changed
@property (nonatomic, assign) id delegate;
@property (nonatomic) BOOL requireAddress; //Controls if user will be asked for zip code or not.
@property (nonatomic) BOOL requireName; //Not supported in this version
@property (nonatomic) BOOL requireEmail; //Not supported in this version
@property (nonatomic) float amount;
@property (nonatomic) BOOL rememberUser; //Not supported in this version
@property (nonatomic, readonly) ZooZUser * payerDetails; 
@property (nonatomic, readonly) ZooZInvoice * invoice;


@end
