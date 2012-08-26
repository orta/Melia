//
//  ORShareViewController.m
//  Melia
//
//  Created by orta therox on 16/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORShareViewController.h"
#import <Twitter/Twitter.h>
#import "APP_SETUP.h"

@interface ORShareViewController ()
@end

NSString *const FBSessionStateChangedNotification = @"com.github.orta.Melia:FBSessionStateChangedNotification";


@implementation ORShareViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:FBSessionStateChangedNotification object:nil];

}

- (IBAction)shareFacebook:(id)sender {
    if (FBSession.activeSession.isOpen) {
        [self uploadImageToFacebook];
        
    } else {
        FBLoginView *loginview = [[FBLoginView alloc] initWithPermissions:@[@"publish_actions"]];

        loginview.frame = CGRectOffset(loginview.frame, 5, 5);
        loginview.delegate = self;

        [self.view addSubview:loginview];
        [loginview sizeToFit];
    } 
}

- (void)sessionStateChanged:(NSNotification*)notification {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), self);
    
    if (FBSession.activeSession.isOpen) {
        [self uploadImageToFacebook];
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), self);
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), self);
    
    [self uploadImageToFacebook];
}

- (void)uploadImageToFacebook {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), self);
    
    UIImage *image = [UIImage imageWithContentsOfFile:_photoPaths[0]];
    [FBRequestConnection startForUploadPhoto:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Uploaded-ish");
    }];
}



- (IBAction)shareTwitter:(id)sender {
    TWTweetComposeViewController *tweetComposeViewController = [[TWTweetComposeViewController alloc] init];
    [tweetComposeViewController setInitialText:@"TEXT"];
    [tweetComposeViewController addURL:[NSURL URLWithString:PHOTOG_URL]];
    for (NSString *photoPath in _photoPaths) {
        [tweetComposeViewController addImage:[UIImage imageWithContentsOfFile:photoPath]];
    }
    [self presentModalViewController:tweetComposeViewController animated:YES];

    [tweetComposeViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        switch (result) {
            case TWTweetComposeViewControllerResultDone:
                
                break;

            default:
                break;
        }
    }];
}

- (IBAction)shareEmail:(id)sender {

}

@end
