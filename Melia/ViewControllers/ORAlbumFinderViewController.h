//
//  ORAlbumFinderViewController.h
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ORAlbumFinderViewController;
@protocol ORAlbumFinderDelegate <NSObject>
- (void)albumFinder:(ORAlbumFinderViewController *)finder didFindAlbumWithName:(NSString *)name andURLs:(NSSet *)urls;
@end

@interface ORAlbumFinderViewController : UIViewController <UIWebViewDelegate>

@property (weak) id<ORAlbumFinderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;



@end
