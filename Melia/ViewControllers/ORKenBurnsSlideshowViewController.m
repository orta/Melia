//
//  ORKenBurnsSlideshowViewController.m
//  Melia
//
//  Created by orta therox on 28/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORKenBurnsView.h"
#import "ORKenBurnsSlideshowViewController.h"
#import "ORAppDelegate.h"

@implementation ORKenBurnsSlideshowViewController

- (id)initWithImagePaths:(NSArray *)imagePaths {
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        ORKenBurnsView *burnsView = [[ORKenBurnsView alloc] initWithFrame:self.view.frame];
        [burnsView animateWithImagePaths:imagePaths];
        self.view = burnsView;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self.view addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)viewTapped:(UITapGestureRecognizer *)gesture {
    ORAppDelegate *appDelegate = (ORAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[[appDelegate window] rootViewController] dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
