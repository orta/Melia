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

@implementation ORShareViewController

- (IBAction)shareFacebook:(id)sender {

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
