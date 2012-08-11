//
//  ORAlbumFinderViewController.h
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORAlbumFinderViewController : UIViewController <UIWebViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;

@end
