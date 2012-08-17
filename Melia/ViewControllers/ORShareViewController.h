//
//  ORShareViewController.h
//  Melia
//
//  Created by orta therox on 16/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORShareViewController : UIViewController

@property (strong, nonatomic) NSArray* photos;

- (IBAction)shareFacebook:(id)sender;
- (IBAction)shareTwitter:(id)sender;
- (IBAction)shareEmail:(id)sender;

@end
