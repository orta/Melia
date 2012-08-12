//
//  ORViewController.m
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORCollectionViewController.h"
#import "ORAlbumSyncViewController.h"
#import "ORAlbumFinderViewController.h"
#import "NSFileManager+PathHandling.h"
#import "NSFileManager+AppDirectories.h"
#import "ORImageViewCell.h"
#import "ORAlbumViewController.h"

static CGSize GridCellSize = { .width = 360, .height = 300 };

@interface ORCollectionViewController (){
    GMGridView *_gridView;
    NSArray *_folders;
}

@end

@implementation ORCollectionViewController

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
    NSString *path = [manager applicationDocumentsDirectoryPath];
    _folders = [manager foldersInFolder:path];
    [_gridView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    if(_folders.count == 0){
        ORAlbumFinderViewController *loginVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"loginView"];
        loginVC.delegate = self;
        [self presentModalViewController:loginVC animated:YES];
    }
}

- (void)albumFinder:(ORAlbumFinderViewController *)finder didFindAlbumWithName:(NSString *)name andURLs:(NSSet *)urls {
    [self dismissViewControllerAnimated:YES completion:^{
        ORAlbumSyncViewController *sync = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"syncView"];
        sync.name = name;
        sync.urls = urls;
        sync.delegate = self;
        [self presentModalViewController:sync animated:YES];
    }];
}

- (void)albumSyncDidFinish:(ORAlbumSyncViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self viewWillAppear:NO];
}

#pragma mark -
#pragma mark Gridview Datasource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView {
    return _folders.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return CGSizeMake(GridCellSize.width, GridCellSize.height);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
    static NSString * CellIdentifier = @"GridViewCellIdentifier";
    ORImageViewCell *cell = (ORImageViewCell *)[gridView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[ORImageViewCell alloc] initWithFrame:CGRectMake(0, 0, GridCellSize.width, GridCellSize.height)];
        cell.reuseIdentifier = CellIdentifier;
    }

    NSString *folderPath = [_folders objectAtIndex:index];
    cell.title = [[[folderPath pathComponents] lastObject] stringByReplacingOccurrencesOfString:@"_" withString:@" "];

    NSString *imageDir = [NSString stringWithFormat:@"%@/%@/images/", [[NSFileManager defaultManager] applicationDocumentsDirectoryPath], folderPath];
    NSArray *images = [[NSFileManager defaultManager] filesInFolder:imageDir withExtension:@"jpg"];
    NSString *imagePath = [images objectAtIndex:arc4random() % images.count];
    NSString *image = [imageDir stringByAppendingPathComponent:imagePath];
    cell.image = [UIImage imageWithContentsOfFile:image];

    return cell;
}

#pragma mark -
#pragma mark Gridview Delegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
    ORAlbumViewController *controller = [[ORAlbumViewController alloc] init];
    NSString *folderPath = [_folders objectAtIndex:position];
    NSString *docs = [[NSFileManager defaultManager] applicationDocumentsDirectoryPath];
    controller.folderPath = [[docs stringByAppendingPathComponent:folderPath] stringByAppendingPathComponent:@"images"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index {
    NSLog(@"Delete");
}

@end
