//
//  ORPhotoFolderGridViewController.m
//  Melia
//
//  Created by orta therox on 26/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORAlbumGridViewController.h"
#import "ORAlbumSyncViewController.h"
#import "ORAlbumFinderViewController.h"
#import "NSFileManager+PathHandling.h"
#import "ORImageViewCell.h"

static CGSize SmallerGridCellSize = { .width = 140, .height = 120 };

@interface ORAlbumGridViewController(){
    NSArray *_photos;
}

@end

@implementation ORAlbumGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _gridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.autoresizesSubviews = YES;
    _gridView.actionDelegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TiledBackground.png"]];
    [self.view addSubview:_gridView];

    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *photosInFolder = [manager filesInFolder:_folderPath withExtension:@"jpg"];

    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *file in photosInFolder) {
        [photos addObject:[_folderPath stringByAppendingPathComponent:file]];
    }
    _photos = photos;
    [_gridView reloadData];
}

- (NSArray *)photoPaths {
    return _photos;
}

#pragma mark -
#pragma mark Gridview Datasource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView {
    return _photos.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return CGSizeMake(SmallerGridCellSize.width, SmallerGridCellSize.height);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
    static NSString * CellIdentifier = @"SmallerGridViewCellIdentifier";
    ORImageViewCell *cell = (ORImageViewCell *)[gridView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[ORImageViewCell alloc] initWithFrame:CGRectMake(0, 0, SmallerGridCellSize.width, SmallerGridCellSize.height)];
        cell.reuseIdentifier = CellIdentifier;
    }

    cell.title = @"";
    cell.position = index;
    cell.image = [UIImage imageWithContentsOfFile:[self pathForImageAtIndex:index]];
    return cell;
}

- (NSString *)pathForImageAtIndex:(NSInteger)index {
    NSString *imagePath = _photos[index];
    return [imagePath stringByReplacingOccurrencesOfString:@"/images/" withString:@"/thumbnails/"];
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
//    ORPhotoViewController *slideshow = [[ORPhotoViewController alloc] initWithSlideshowStyle:JDSlideshowStyleView];
//    slideshow.delegate = self;
//    slideshow.photoPaths = _photos;
//
//    [self.navigationController pushViewController:slideshow animated:YES];
//    [slideshow navigateToSlideIndex:position animated:NO];
}


- (CGPoint)gridContentOffset {
    return ((UIScrollView*)_gridView ).contentOffset;
}

- (NSArray *)visibleGridCells {
    NSMutableArray *cells = [NSMutableArray array];
    if (_gridView.subviews.count) {
        for (GMGridViewCell *view in [_gridView  subviews]) {
            if ([view isKindOfClass:[ORImageViewCell class]]) {
                [cells addObject:view];
            }
        }
    }
    return cells;
}

@end
