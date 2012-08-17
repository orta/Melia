//
//  ORBuyViewController.h
//  Melia
//
//  Created by orta therox on 16/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZooZSDK/ZooZ.h>

@interface ORBuyViewController : UIViewController <ZooZPaymentCallbackDelegate>

- (IBAction)buyArtwork:(id)sender;

@property (strong, nonatomic) NSArray* photos;
@property (weak) UIPopoverController *containerPopover;
@end
