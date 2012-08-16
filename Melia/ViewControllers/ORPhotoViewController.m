//
//  ORPhotoViewController.m
//  Melia
//
//  Created by orta therox on 16/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORPhotoViewController.h"

@interface ORPhotoViewController ()

@end

@implementation ORPhotoViewController


- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *buyButton = [[UIBarButtonItem alloc] initWithTitle:@"Buy" style:UIBarButtonItemStyleBordered target:self action:@selector(buyTapped)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(shareTapped)];
    self.navigationItem.rightBarButtonItems = @[buyButton, shareButton];

    [super viewWillAppear:YES];
}


@end
