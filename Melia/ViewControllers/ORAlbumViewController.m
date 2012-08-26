
//
//  ORViewController.m
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORAlbumViewController.h"
#import "JBKenBurnsView.h"
#import "ORImageViewCell.h"

@interface ORAlbumViewController(){
    BOOL _selectionMode;
    NSMutableArray *_selectedIndices;
}
@end

@implementation ORAlbumViewController

- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(selectTapped:)];
    UIBarButtonItem *slideshowButton = [[UIBarButtonItem alloc] initWithTitle:@"Slideshow" style:UIBarButtonItemStyleBordered target:self action:@selector(slideshowTapped:)];

    self.navigationItem.rightBarButtonItems = @[selectButton, slideshowButton];

    [super viewWillAppear:YES];
}

- (void)slideshowTapped:(UIButton *)sender {
    JBKenBurnsView *kenView = [[JBKenBurnsView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:kenView];
    [kenView animateWithImagePaths:[self photoPaths] transitionDuration:5 loop:YES isLandscape:YES];
}

- (void)selectTapped:(UIButton *)sender {
    _selectionMode = !_selectionMode;
    if (_selectionMode) {
        self.title = @"Select Photos";
        _selectedIndices = [NSMutableArray array];
    }else {
        self.title = @" ";
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
    ORImageViewCell *cell = (ORImageViewCell *)[super GMGridView:gridView cellForItemAtIndex:index];
    if (_selectionMode) {
        if ([_selectedIndices containsObject:@(index)]) {
            [cell setSelected:YES animated:NO];
        }
    } else {
        [cell setSelected:NO animated:NO];
    }
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
    if (_selectionMode) {
        BOOL selected = (![_selectedIndices containsObject:@(position)]);
        if (selected) {
            [_selectedIndices addObject:@(position)];
        }else {
            [_selectedIndices removeObject:@(position)];
        }
        ORImageViewCell *cell = (ORImageViewCell *)[gridView cellForItemAtIndex:position];
        [cell setSelected:selected animated:YES];
    }else {
        [super GMGridView:gridView didTapOnItemAtIndex:position];
    }
}

@end
