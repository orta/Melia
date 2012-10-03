//
//  ORKenBurnsView.m
//  Melia
//
//  Created by orta therox on 28/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORKenBurnsView.h"
#import <QuartzCore/QuartzCore.h>

enum ORKBSourceMode {
    ORKBSourceModeImages,
    ORKBSourceModePaths
};

@interface ORKenBurnsView (){
    NSInteger _currentIndex;
    enum ORKBSourceMode _sourceMode;

    CGFloat _imageChangeDuration;
    NSArray *_imageSourcesArray;

    NSTimer *_nextImageTimer;
}

@property (nonatomic) int currentImage;

@end

@implementation ORKenBurnsView

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    self.backgroundColor = [UIColor blackColor];
    _imageChangeDuration = 20;
    
}

- (void)animateWithImagePaths:(NSArray *)imagePaths {
    _sourceMode = ORKBSourceModePaths;
    [self _startAnimationsWithData:imagePaths];
}

- (void)animateWithImages:(NSArray *)images {
    _sourceMode = ORKBSourceModeImages;
    [self _startAnimationsWithData:images];
}

- (void)_startAnimationsWithData:(NSArray *)data {
    _imageSourcesArray = data;
    _currentIndex       = 0;

    _nextImageTimer = [NSTimer scheduledTimerWithTimeInterval:_imageChangeDuration target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [_nextImageTimer fire];
}

- (void)nextImage {    
    UIImage *image = nil;
    switch (_sourceMode) {
        case ORKBSourceModeImages:
            image = _imageSourcesArray[_currentIndex];
            break;

        case ORKBSourceModePaths:
            image = [UIImage imageWithContentsOfFile:_imageSourcesArray[_currentIndex]];
            break;
    }

    NSLog(@"%@ - %i", NSStringFromSelector(_cmd), _currentIndex);

    CGImageRef cgImage = image.CGImage;


    CALayer *layer = [[CALayer alloc] init];
    layer.contents = (__bridge id) cgImage;

    [self.layer addSublayer:layer];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{ CIDetectorAccuracy: CIDetectorAccuracyLow }];
    NSArray* features = [detector featuresInImage:[CIImage imageWithCGImage:cgImage]];
    if (features.count) {
        NSUInteger randomIndex = arc4random() % features.count;
        CGRect faceRect = [features[randomIndex] bounds];
    }


    CGSize imageSize = image.size;
    CGFloat startingScale = imageSize.width / self.bounds.size.width;

//    layer.bounds = CGRectMake(0, 0, imageSize.width, <#CGFloat height#>)

//    CALayer *picLayer    = [CALayer layer];
//    picLayer.contents    = (id)image.CGImage;
//    picLayer.anchorPoint = CGPointMake(0, 0);
//    picLayer.bounds      = CGRectMake(0, 0, optimusWidth, optimusHeight);
//    picLayer.position    = CGPointMake(originX, originY);
//
//    [imageView.layer addSublayer:picLayer];
//
//    CATransition *animation = [CATransition animation];
//    [animation setDuration:1];
//    [animation setType:kCATransitionFade];
//    [[self layer] addAnimation:animation forKey:nil];
//
//    // Remove the previous view
//    if ([[self subviews] count] > 0){
//        UIView *oldImageView = [[self subviews] objectAtIndex:0];
//        [oldImageView removeFromSuperview];
//        oldImageView = nil;
//    }
//
//    [self addSubview:imageView];
//
//    // Generates the animation
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:_showImageDuration + 2];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    CGAffineTransform rotate    = CGAffineTransformMakeRotation(rotation);
//    CGAffineTransform moveRight = CGAffineTransformMakeTranslation(moveX, moveY);
//    CGAffineTransform combo1    = CGAffineTransformConcat(rotate, moveRight);
//    CGAffineTransform zoomIn    = CGAffineTransformMakeScale(zoomInX, zoomInY);
//    CGAffineTransform transform = CGAffineTransformConcat(zoomIn, combo1);
//    imageView.transform = transform;
//    [UIView commitAnimations];
//
//    [self _notifyDelegate];
//

    _currentIndex ++;
    if (_currentIndex == _imageSourcesArray.count - 1) {
        _currentIndex = 0;
    }
}

@end
