//
//  ORSlidingPhotoViewController.m
//  Melia
//
//  Created by orta therox on 29/09/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORSlidingPhotoViewController.h"
#import "ORBuyViewController.h"
#import "ORShareViewController.h"

@interface ORSlidingPhotoViewController (){
    SwipeView *_swipeView;
     UIPopoverController *_popover;
}

@end

@implementation ORSlidingPhotoViewController

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
//    sharedVC.photoPaths = @[[self currentPath]];

    _popover = [[UIPopoverController alloc] initWithContentViewController:sharedVC];
    [_popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)viewDidLoad {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), self);
    
    [super viewDidLoad];
    //configure swipe view
    _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    _swipeView.pagingEnabled = YES;
    _swipeView.wrapEnabled = NO;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
    _swipeView.dataSource = self;

    [self.view addSubview:_swipeView];
    [_swipeView reloadData];
    
    _swipeView.backgroundColor = [UIColor blueColor];
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    NSLog(@" %i", _photos.count );
    return 2;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return CGSizeMake(200, 200);
}


- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIImageView *imageView = (UIImageView *)view;
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), self);
    //create or reuse view
    if (view == nil) {
        imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    UIImage *image = [UIImage imageWithContentsOfFile:_photos[index]];
    imageView.image = image;
    view = imageView;
    return view;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"Selected item at index %i", index);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
