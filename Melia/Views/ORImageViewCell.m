//
//  ORImageViewCell.m
//  Melia
//
//  Created by orta therox on 12/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORImageViewCell.h"
#import <QuartzCore/QuartzCore.h>
static UIEdgeInsets ImageContentInsets = {.top = 10, .left = 6, .right = 6, .bottom = 10};

static CGFloat TitleLabelHeight = 44;
static CGFloat ImageBottomMargin = 10;


@interface ORImageViewCell (){
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

@end

@implementation ORImageViewCell


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.opaque = YES;

        _imageView.frame = [self imageFrame];
        [self addSubview:_imageView];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.opaque = NO;
        _titleLabel.userInteractionEnabled = YES;

        _titleLabel.textAlignment = UITextAlignmentCenter;
        [_titleLabel setNumberOfLines:0];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)prepareForReuse {
    _titleLabel.text = @"";
    self.image = nil;
    _imageView.layer.backgroundColor = [UIColor clearColor].CGColor;
    _imageView.layer.borderWidth = 0.0f;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([_title length]) {
        [_titleLabel sizeToFit];

        CGRect titleFrame = _titleLabel.frame;
        titleFrame = CGRectMake(ImageContentInsets.left, CGRectGetMaxY(_imageView.frame) + ImageBottomMargin, CGRectGetWidth(self.bounds) - ImageContentInsets.left - ImageContentInsets.right, TitleLabelHeight);
        _titleLabel.frame = titleFrame;
    }
    else {
        _titleLabel.frame = CGRectNull;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setImage:(UIImage *)anImage {
    _image = anImage;
    [_imageView setImage:anImage];
}

- (CGRect)imageFrame {
    CGRect imageFrame = self.bounds;
    imageFrame.size.width = CGRectGetWidth(self.frame) - ImageContentInsets.left - ImageContentInsets.right;
    imageFrame.size.height = CGRectGetHeight(self.frame) - ImageContentInsets.bottom - ImageContentInsets.top;

    imageFrame.origin.x = ImageContentInsets.left;
    imageFrame.origin.y = ImageContentInsets.top;
    return imageFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    BOOL duration = animated? 0.3 : 0;
    if (selected) {
        [UIView animateWithDuration:duration animations:^{
            _imageView.frame = CGRectInset([self imageFrame], 3, 3);
        }];

        _imageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _imageView.layer.borderWidth = 3.0f;
    }else {
        _imageView.layer.backgroundColor = [UIColor clearColor].CGColor;
        _imageView.layer.borderWidth = 0.0f;

        [UIView animateWithDuration:duration animations:^{
            _imageView.frame = [self imageFrame];
        }];
    }
}

@end
