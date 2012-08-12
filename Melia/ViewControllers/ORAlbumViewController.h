//
//  ORAlbumViewController.h
//  Melia
//
//  Created by orta therox on 12/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"
#import "JDSlideshow.h"
#import "JDSlideshowDelegate.h"

@interface ORAlbumViewController : UIViewController <GMGridViewActionDelegate, GMGridViewDataSource, JDSlideshowDelegate, UIScrollViewDelegate>
@property NSString *folderPath;
@end
