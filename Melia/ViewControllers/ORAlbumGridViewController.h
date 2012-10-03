//
//  ORPhotoFolderGridViewController.h
//  Melia
//
//  Created by orta therox on 26/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"
#import "JDSlideshow.h"
#import "JDSlideshowDelegate.h"

@interface ORAlbumGridViewController : UIViewController <GMGridViewActionDelegate, GMGridViewDataSource, UIScrollViewDelegate>

@property (strong) NSString * folderPath;
@property (strong) GMGridView *gridView;

- (NSArray *)photoPaths;

- (CGPoint)gridContentOffset;
- (NSArray *)visibleGridCells;
- (NSString *)pathForImageAtIndex:(NSInteger)index;
@end
