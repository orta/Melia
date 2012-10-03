//
//  ORAlbumFinderViewController.m
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORAlbumFinderViewController.h"
#import "APP_SETUP.h"

static NSString *MeliaHomePage = @"http://jamesmeliaphoto.zenfolio.com/f634884173";

@interface ORAlbumFinderViewController (){
    NSMutableSet *_photos;
    NSTimer *_parseTimer;
    NSString *_albumTitle;

    NSInteger _photoCount;
    NSInteger _sameNumberCount;
}

@end

@implementation ORAlbumFinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;

    [self loadPage:MeliaHomePage];
}

- (void)loadPage:(NSString *)page {
    NSURL * url = [NSURL URLWithString:page];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (![request.URL.absoluteString hasPrefix:PHOTOG_URL]) {
        [self loadPage:MeliaHomePage];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    NSString *address = aWebView.request.URL.absoluteString;
    
    if ([MeliaHomePage isEqualToString:address]) {
        // do nothing
    }else {
        // Album page
        _albumTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('title')[0].innerHTML"];

        if([self isPasswordPage]){
            [self performSelector:@selector(focusTextField) withObject:nil afterDelay:0.5];
        }else {
            _webView.alpha = 0.5;
            _webView.userInteractionEnabled = NO;
            [_activityIndicator startAnimating];
            _titleLabel.text = [NSString stringWithFormat:@"Getting images for %@", _albumTitle]; 

            // Show all images
            [_webView stringByEvaluatingJavaScriptFromString:@"$('#ctl02_Pager-a').mousedown()"];
            _photos = [NSMutableSet set];

            _parseTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(backgroundParseWebviewForPhotos) userInfo:nil repeats:YES];
            [_parseTimer fire];
        }
    }
}

- (void)focusTextField {
    [_webView stringByEvaluatingJavaScriptFromString:@"$('input:text:visible:first').focus();"];
}

- (void)backgroundParseWebviewForPhotos {
    NSString *theGridHTML = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('defdec')[0].innerHTML.toString()"];
    NSArray *splitHTMLAtImage = [theGridHTML componentsSeparatedByString:@"background-image:url("];
    for (int i = 1; i < splitHTMLAtImage.count; i++) {
        NSString *path = [[[splitHTMLAtImage objectAtIndex:i] componentsSeparatedByString:@");"] objectAtIndex:0];
        if (![_photos containsObject:path]) {
            [_photos addObject:path];
        }
    }
    NSInteger oldPhotoCount = _photoCount;
    _photoCount = _photos.count;
    if (oldPhotoCount == _photoCount) {
        _sameNumberCount++;
        if (_sameNumberCount == 3) {
            [_parseTimer invalidate];
            [_delegate albumFinder:self didFindAlbumWithName:_albumTitle andURLs:_photos];
            NSLog(@"Got all the photos");
        }
    }else{
        _sameNumberCount = 0;
    }
    _photoCount = _photoCount;
}

- (BOOL)isPasswordPage {
    return [[_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('password2-frame').length.toString()"] integerValue];
}


- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
