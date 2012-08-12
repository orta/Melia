
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

static CGSize SmallerGridCellSize = { .width = 140, .height = 120 };

@interface ORAlbumViewController(){
    GMGridView *_gridView;
    NSArray *_photos;
}
@end

@implementation ORAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _gridView = [[GMGridView alloc] initWithFrame:self.view.frame];
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


    NSString *imagePath = [_photos objectAtIndex:index];
    NSString *image = [_folderPath stringByAppendingPathComponent:imagePath];
    cell.image = [UIImage imageWithContentsOfFile:image];

    return cell;
}

#pragma mark -
#pragma mark Gridview Delegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {

}

@end
