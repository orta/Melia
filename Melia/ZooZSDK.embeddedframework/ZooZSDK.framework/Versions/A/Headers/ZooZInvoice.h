//
//  ZooZInvoice.h
//  ZooZSDK
//
//  Created by Ronen Morecki on 3/15/12.
//  Copyright (c) 2012 ZooZ.com All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZooZInvoiceItem : NSObject{
@private
	NSString *name;
	NSString *itemId;
	float price;
	float quantity;
}

-(id)initWithPrice:(float)priceValue quantity:(float)itemQuantity name:(NSString *)itemName;

+ (ZooZInvoiceItem *)invoiceItem:(float)priceValue quantity:(float)itemQuantity name:(NSString *)itemName;

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *itemId;
@property(nonatomic) float price;
@property(nonatomic) float quantity;

@end



@interface ZooZInvoice : NSObject{
@private
	NSString *invoiceNumber;
	NSMutableArray *invoiceItems;
	NSString *additionalDetails; //free text for custom description on the trasnaction (200 chars)
}


-(id)initWithRefNumber:(NSString *)invNum;

//Add item to the invoice.
-(void)addItem:(ZooZInvoiceItem *)item;

-(NSArray *)getItems;


@property(nonatomic, retain) NSString *invoiceNumber;
@property(nonatomic, retain) NSString *additionalDetails;

@end
