//
//  ZooZ.h
// 
//
//  Created by Ronen Morecki on 6/16/11.
//  Copyright 2011 ZooZ.com. All rights reserved.
//

#import  <UIKit/UIKit.h>
#import "ZooZPaymentRequest.h"
#import "ZooZPaymentResponse.h"


@protocol ZooZPaymentCallbackDelegate<NSObject>

@required
// the payment finished successfully call back to dialog is on background thread, no need to auto release pool, as this been taken care of. (The dialog is still open since v1.3.2). You shouldn't update your UI on this, just process the payment data
- (void)paymentSuccessWithResponse:(ZooZPaymentResponse *)response; 

//Dialog is closed after payment finished successfully (see paymentSuccessWithResponse:) - this is where you should update your UI on success transaction
- (void)paymentSuccessDialogClosed; 

//User closed the dialog without paying
- (void)paymentCanceled; 

//some error occured in calling ZooZ to open the payment request
- (void)openPaymentRequestFailed:(ZooZPaymentRequest *)request withErrorCode:(int)errorCode andErrorMessage:(NSString *)errorMessage;

@optional
//Return YES or NO if to show alert message or not
-(BOOL)serviceErrorOccuredWithCode:(int)errorCode andMessage:(NSString *)msg;
@end


@interface ZooZ : NSObject <UIAlertViewDelegate>

+(ZooZ *)sharedInstance;

-(BOOL)isZooZAppInstalled;//Internal use - no need to call this

//Create here the payment meta data.  The returned object is needed later for opening the Payment dialog.
-(ZooZPaymentRequest *)createPaymentRequestWithTotal:(float)amount invoiceRefNumber:(NSString *)invNum delegate:(id<ZooZPaymentCallbackDelegate>)del;

//Opens the payment dialog
-(void)openPayment:(ZooZPaymentRequest *)request forAppKey:(NSString *)appKey;

-(void)cancelPaymentDialog;


@property (nonatomic) BOOL sandbox; //flag if to process real payments or test mode.
@property (nonatomic, retain) UIColor *tintColor; //tintColor for the ZooZ dialog NavBar
@property (nonatomic, retain) UIColor *barButtonTintColor; //tintColor for the ZooZ dialog NavBar buttons
@property (assign) UIView *rootView; //used for iPad only if special window structure is applied.
@property (nonatomic, readonly) ZooZPaymentRequest * currentRequest;

@end
