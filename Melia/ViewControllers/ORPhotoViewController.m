//
//  ORPhotoViewController.m
//  Melia
//
//  Created by orta therox on 16/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORPhotoViewController.h"
#import "ORBuyViewController.h"
#import "ORShareViewController.h"

@interface ORPhotoViewController (){
    UIPopoverController *_popover;

}
@end

@implementation ORPhotoViewController

- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *buyButton = [[UIBarButtonItem alloc] initWithTitle:@"Buy" style:UIBarButtonItemStyleBordered target:self action:@selector(buyTapped:)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(shareTapped:)];
    self.navigationItem.rightBarButtonItems = @[buyButton, shareButton];

    [super viewWillAppear:YES];
}

- (void)buyTapped:(id)sender {
    [_popover dismissPopoverAnimated:NO];
    
    UINavigationController *navigationVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"buyView"];
    ORBuyViewController *buyVC = (ORBuyViewController *)navigationVC.topViewController;
    _popover = [[UIPopoverController alloc] initWithContentViewController:navigationVC];
    buyVC.containerPopover = _popover;
    [_popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)shareTapped:(id)sender {
    [_popover dismissPopoverAnimated:NO];

    ORShareViewController *sharedVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"shareView"];
    sharedVC.photoPaths = @[[self currentPath]];
    
    _popover = [[UIPopoverController alloc] initWithContentViewController:sharedVC];
    [_popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (NSString *)currentPath {
    return _photoPaths[self.slideshow.currentSlideIndex];
}

@end
