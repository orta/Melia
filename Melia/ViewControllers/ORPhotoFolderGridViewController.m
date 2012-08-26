//
//  ORPhotoFolderGridViewController.m
//  Melia
//
//  Created by orta therox on 26/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORPhotoFolderGridViewController.h"
#import "ORCollectionViewController.h"
#import "ORAlbumSyncViewController.h"
#import "ORAlbumFinderViewController.h"
#import "NSFileManager+PathHandling.h"
#import "ORImageViewCell.h"
#import "ORPhotoViewController.h"

static CGSize SmallerGridCellSize = { .width = 140, .height = 120 };

@interface ORPhotoFolderGridViewController(){
    GMGridView *_gridView;
    NSArray *_photos;
    BOOL _selectionMode;
}

- (void)setSelectionMode:(BOOL)selectionMode;
@end

@implementation ORPhotoFolderGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _gridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.autoresizesSubviews = YES;
    _gridView.actionDelegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TiledBackground.png"]];
    [self.view addSubview:_gridView];
}

- (void)viewWillAppear:(BOOL)animated {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *photosInFolder = [manager filesInFolder:_folderPath withExtension:@"jpg"];

    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *file in photosInFolder) {
        [photos addObject:[_folderPath stringByAppendingPathComponent:file]];
    }
    _photos = photos;

    [_gridView reloadData];
    //    self.selectionMode = YES;
}

- (void)setSelectionMode:(BOOL)selectionMode {
    _selectionMode = selectionMode;
    _gridView.editing = selectionMode;
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

    NSString *imagePath = _photos[index];
    cell.image = [UIImage imageWithContentsOfFile:[imagePath stringByReplacingOccurrencesOfString:@"/images/" withString:@"/thumbnails/"]];
    return cell;
}


- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
    ORPhotoViewController *slideshow = [[ORPhotoViewController alloc] initWithSlideshowStyle:JDSlideshowStyleView];
    slideshow.delegate = self;
    slideshow.photoPaths = _photos;

    [self.navigationController pushViewController:slideshow animated:YES];
    [slideshow navigateToSlideIndex:position animated:NO];
}

- (CGPoint)gridContentOffset {
    return ((UIScrollView*)[[_gridView subviews]objectAtIndex:0]).contentOffset;
}

- (NSArray *)visibleGridCells {
    NSMutableArray *cells = [NSMutableArray array];
    for (GMGridViewCell *view in [[[_gridView subviews]objectAtIndex:0] subviews]) {
        [cells addObject:view];
    }
    return cells;
}

#pragma mark -
#pragma mark Slideshow

- (void) slideshow:(id<JDSlideshow>)theSlideshow fetchContentForSlideAtIndex:(NSUInteger)index {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [scrollView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIImage *image = [UIImage imageWithContentsOfFile:_photos[index]];
    scrollView.contentSize = image.size;
    imageView.image = image;

    [theSlideshow loadView:scrollView forSlideAtIndex:index];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [[scrollView subviews] objectAtIndex:0];
}

- (NSUInteger) slideshowNumberOfSlides:(id<JDSlideshow>)theSlideshow {
    return _photos.count;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



@end
