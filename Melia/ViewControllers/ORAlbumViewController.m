
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
    NSMutableArray *_selectedIndices;
    BOOL _selectionMode;
    NSString *_originalTitle;
}

@property BOOL selectionMode;
@end

@implementation ORAlbumViewController

- (void)viewWillAppear:(BOOL)animated {
    if (!_originalTitle) {
        _originalTitle = self.title;
    }
    self.selectionMode = NO;
    [self updateTitle];
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.title = _originalTitle;
    [super viewWillDisappear:animated];
}


- (BOOL)selectionMode { return _selectionMode; }


- (void)setSelectionMode:(BOOL)selectionMode {
    _selectionMode = selectionMode;
    [self updateTitle];

    if (_selectionMode) {
        
        _selectedIndices = [NSMutableArray array];

        UIBarButtonItem *printsButton = [[UIBarButtonItem alloc] initWithTitle:@"Prints" style:UIBarButtonItemStyleBordered target:self action:@selector(slideshowTapped:)];
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(slideshowTapped:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(toggleSelect:)];
        self.navigationItem.rightBarButtonItems = @[ cancelButton, shareButton, printsButton ];

    }else {
        UIBarButtonItem *selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleSelect:)];
        UIBarButtonItem *slideshowButton = [[UIBarButtonItem alloc] initWithTitle:@"Slideshow" style:UIBarButtonItemStyleBordered target:self action:@selector(slideshowTapped:)];
        self.navigationItem.rightBarButtonItems = @[ selectButton, slideshowButton ];
    }

    NSArray *visibleCells = [self visibleGridCells];
    if (visibleCells.count) {
        for (ORImageViewCell *cell in visibleCells) {
            if ([cell isKindOfClass:[ORImageViewCell class]]) {
                [cell setSelectable:_selectionMode animated:YES];

                if (!_selectionMode) {
                    [cell setSelected:NO animated:YES];
                }
            }
        }
    }    
}

- (void)updateTitle {
    if (!_selectionMode) {
        self.title = @"";
    } else {
        if (_selectedIndices.count) {
            if (_selectedIndices.count == 1) {
                self.title = @"1 Photo Selected";
            }else{
                self.title = [NSString stringWithFormat:@"%i Selected Photos", _selectedIndices.count];
            }
        } else {
            self.title = @"Select Photos";
        }
    }
}


- (void)slideshowTapped:(UIButton *)sender {
    JBKenBurnsView *kenView = [[JBKenBurnsView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:kenView];
    [kenView animateWithImagePaths:[self photoPaths] transitionDuration:5 loop:YES isLandscape:YES];
}


- (void)toggleSelect:(UIButton *)sender {
    self.selectionMode = !_selectionMode;
}


- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
    ORImageViewCell *cell = (ORImageViewCell *)[super GMGridView:gridView cellForItemAtIndex:index];
    [cell setSelectable:_selectionMode animated:NO];

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

        [self updateTitle];

    }else {
        [super GMGridView:gridView didTapOnItemAtIndex:position];
    }
}

@end
