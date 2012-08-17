//
//  ORBuyViewController.m
//  Melia
//
//  Created by orta therox on 16/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORBuyViewController.h"
#import "APP_SETUP.h"

@interface ORBuyViewController (){
    BOOL _isShowingZOOZ;
}

@end

@implementation ORBuyViewController

- (IBAction)buyArtwork:(id)sender {

	ZooZ * zooz = [ZooZ sharedInstance];
    zooz.sandbox = YES;
    zooz.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    zooz.barButtonTintColor = [UIColor darkGrayColor];
//    zooz.rootView = self.view;

    ZooZPaymentRequest * req = [zooz createPaymentRequestWithTotal:12.1 invoiceRefNumber:@"test invoice ref-1234" delegate:self];
    
    req.currencyCode = @"GBP";

    req.payerDetails.firstName = @"Some";
    req.payerDetails.email = @"test@zooz.com";
    req.payerDetails.address.zip = @"01234";
    req.requireAddress = NO;


    ZooZInvoiceItem * item = [ZooZInvoiceItem invoiceItem:12.1 quantity:1 name:@"T-Shirt"];
    item.itemId = @"refId-12345678"; // optional
    [req addItem:item];
    req.invoice.additionalDetails = @"Custom invoice description text";
    [zooz openPayment:req forAppKey: ZOOSDK_API_KEY];
    [_containerPopover dismissPopoverAnimated:YES];
    _isShowingZOOZ = YES;
}



- (void)openPaymentRequestFailed:(ZooZPaymentRequest *)request withErrorCode:(int)errorCode andErrorMessage:(NSString *)errorMessage{
	NSLog(@"failed: %@", errorMessage);
    //this is a network / integration failure, not a payment processing failure.

}

//Called in the background thread - before user closes the payment dialog
//Do not refresh UI at this callback - see paymentSuccessDialogClosed
- (void)paymentSuccessWithResponse:(ZooZPaymentResponse *)response{
    _isShowingZOOZ = NO;
	NSLog(@"payment success with payment Id: %@, %@, %@, %f %@", response.transactionId, response.cardType, response.cardDisplayString, response.paidAmount, response.paymentToken);
}

//called after successful payment and after the user closed the payment dialog
-(void)paymentSuccessDialogClosed{
    _isShowingZOOZ = NO;
    NSLog(@"Payment dialog closed after success");
}

- (void)paymentCanceled{
    _isShowingZOOZ = NO;
	NSLog(@"payment cancelled");
    //dialog closed without payment completed
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return !_isShowingZOOZ;
}




@end
