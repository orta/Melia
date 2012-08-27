//
//  ORImageViewCell.h
//  Melia
//
//  Created by orta therox on 12/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "GMGridViewCell.h"

@interface ORImageViewCell : GMGridViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *image;
@property NSInteger position;

- (void)setSelected:(BOOL)selected animated:(BOOL)animates;
- (void)setSelectable:(BOOL)selectable animated:(BOOL)animates;
- (CGRect)frameForImage;
@end
