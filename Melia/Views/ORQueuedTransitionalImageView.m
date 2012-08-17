//
//  ORQueuedTransitionalImageView.m
//  Melia
//
//  Created by orta therox on 17/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORQueuedTransitionalImageView.h"

const NSTimeInterval ORDefaultImageChangeDelay = 1.5;
const NSTimeInterval ORAnimationDuration = 0.45;

@interface ORQueuedTransitionalImageView (){
    NSMutableArray *_imageQueue;
    NSTimer *_nextImageTimer;

    UIImageView *_currentImageView;
    UIImageView *_offscreenImageView;

    UIImageView *_imageView;
    UIImageView *_secondImageView;

    CGPoint _centerPoint;
}

@end

@implementation ORQueuedTransitionalImageView

- (void)dealloc {
    [_imageView removeFromSuperview];
    [_secondImageView removeFromSuperview];

    [_nextImageTimer invalidate];
    _imageQueue = nil;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    _imageQueue = [NSMutableArray array];
    self.transitionTime = ORDefaultImageChangeDelay;
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _secondImageView = [[UIImageView alloc] initWithFrame:self.bounds];

    _currentImageView = _imageView;
    _offscreenImageView = _secondImageView;

    for (UIImageView *imageView in @[_imageView, _secondImageView]) {
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
    }
}

- (void)setTransitionTime:(NSTimeInterval)transitionTime {
    [_nextImageTimer invalidate];

    _transitionTime = transitionTime;
    _nextImageTimer = [NSTimer scheduledTimerWithTimeInterval:transitionTime target:self selector:@selector(checkImageQueue) userInfo:nil repeats:YES];
}

- (void)addImagePathToQueue:(NSString *)path {
    [_imageQueue addObject:path];
}

- (void)layoutSubviews {
    _centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

    _currentImageView.center = _centerPoint;
    CGFloat offscreenX = self.bounds.size.width + self.superview.bounds.size.width;
    _offscreenImageView.center = CGPointMake(offscreenX, self.center.y);
}

- (void)showImage:(NSString *)fileName {
    CGFloat offscreenX = self.bounds.size.width + self.superview.bounds.size.width;

    _offscreenImageView.alpha = 0;
    _offscreenImageView.center = CGPointMake(offscreenX, _centerPoint.y);
    _offscreenImageView.image = [UIImage imageWithContentsOfFile:fileName];

    [UIView animateWithDuration:ORAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{

        _offscreenImageView.alpha = 1;
        _offscreenImageView.center = _centerPoint;

        _currentImageView.alpha = 0;
        _currentImageView.center = CGPointMake(-offscreenX, _centerPoint.y);

    } completion:^(BOOL completed){
        UIImageView *tempView = _currentImageView;
        _currentImageView = _offscreenImageView;
        _offscreenImageView = tempView;
    }];
}

- (void)checkImageQueue {
    if ([_imageQueue count] > 0) {
        NSString *nextFilePath = _imageQueue[0];
        [_imageQueue removeObject:nextFilePath];

        [self showImage:nextFilePath];
    }
}


@end
