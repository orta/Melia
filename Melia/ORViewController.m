//
//  ORViewController.m
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORViewController.h"
#import "ORAlbumSyncViewController.h"
#import "ORAlbumFinderViewController.h"

@interface ORViewController ()

@end

@implementation ORViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    ORAlbumFinderViewController *loginVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"loginView"];
    loginVC.delegate = self;
    [self presentModalViewController:loginVC animated:YES];
}

- (void)albumFinder:(ORAlbumFinderViewController *)finder didFindAlbumWithName:(NSString *)name andURLs:(NSSet *)urls {
    [self dismissViewControllerAnimated:YES completion:^{
        ORAlbumSyncViewController *sync = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"syncView"];
        sync.name = name;
        sync.urls = urls;
        [self presentModalViewController:sync animated:YES];
    }];
}

- (void)albumSyncDidFinish:(ORAlbumSyncViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^{}];

    
}


@end
