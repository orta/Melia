
//
//  ORViewController.m
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORAlbumViewController.h"
#import "ORCollectionViewController.h"
#import "ORAlbumSyncViewController.h"
#import "ORAlbumFinderViewController.h"
#import "NSFileManager+PathHandling.h"
#import "NSFileManager+AppDirectories.h"
#import "ORImageViewCell.h"
#import "JDSlideshowViewController.h"

static CGSize SmallerGridCellSize = { .width = 140, .height = 120 };

@interface ORAlbumViewController(){
    GMGridView *_gridView;
    NSArray *_photos;
}
@end

@implementation ORAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _gridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.autoresizesSubviews = YES;
    _gridView.actionDelegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_gridView];
}

- (void)viewWillAppear:(BOOL)animated {
    NSFileManager *manager = [NSFileManager defaultManager];
    _photos = [manager filesInFolder:_folderPath withExtension:@"jpg"];

    [_gridView reloadData];
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

    cell.image = [UIImage imageWithContentsOfFile:[self imagePathAtIndex:index]];

    return cell;
}

- (NSString *)imagePathAtIndex:(NSInteger)index {
    NSString *imagePath = [_photos objectAtIndex:index];
    return [_folderPath stringByAppendingPathComponent:imagePath];
}

#pragma mark -
#pragma mark Slideshow

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
    JDSlideshowViewController *slideshow = [[JDSlideshowViewController alloc]initWithSlideshowStyle:JDSlideshowStyleQuick];
    slideshow.delegate = self;

    [self.navigationController pushViewController:slideshow animated:YES];
    [slideshow navigateToSlideIndex:position animated:NO];
}

- (void) slideshow:(id<JDSlideshow>)theSlideshow fetchContentForSlideAtIndex:(NSUInteger)index {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [scrollView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    UIImage *image = [UIImage imageWithContentsOfFile:[self imagePathAtIndex:index]];
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


@end