//
//  ORMailEnvelope.m
//  Melia
//
//  Created by orta therox on 27/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORMailEnvelope.h"
#import <QuartzCore/QuartzCore.h>

@interface ORMailEnvelopeViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *envelopeView;
@end

static CGFloat ORImagePullOutOfEnvelopeDistance = 30;
static CGFloat ORImageSideMargin = 30;

@implementation ORMailEnvelopeViewController

// This view starts off transparent

- (void)viewWillAppear:(BOOL)animated {
    self.view.alpha = 0;
    [super viewWillAppear:animated];
}

- (void)animateViewInWithImageViews:(NSArray *)imageViews {
    self.view.alpha = 1;
    for (UIImageView *imageView in imageViews) {
        NSInteger index = [imageViews indexOfObject:imageView];
        CGFloat yPosition = CGRectGetMinY(_envelopeView.frame) - ORImagePullOutOfEnvelopeDistance;
        CGFloat xPosition = ORImageSideMargin + _envelopeView.frame.origin.x + (CGRectGetWidth(_envelopeView.frame) / imageViews.count) * index;

        [self.view insertSubview:imageView aboveSubview:_backgroundView];

        CAAnimation *animation = [self animationForImageView:imageView toCenterPoint:CGPointMake(xPosition, yPosition)];
        [imageView.layer addAnimation:animation forKey:@"MoveIntoEnvelope"];
    }
}

- (CAKeyframeAnimation *)animationForImageView:(UIImageView *)imageView toCenterPoint:(CGPoint)endPoint {
    // Setup an a animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 3;

    // Use the two centerpoints of the rects to set up the bezier curve
    CGRect imageViewRect = imageView.frame;
    CGPoint startPoint = CGPointMake(imageViewRect.origin.x + (imageViewRect.size.width / 2), imageViewRect.origin.y + (imageViewRect.size.height / 2));

    // Make a curved path
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, startPoint.x, -100, endPoint.x, endPoint.y);

    // Set the path and release it
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    return pathAnimation;
}

- (void)viewDidUnload {
    [self setBackgroundView:nil];
    [self setEnvelopeView:nil];
    [super viewDidUnload];
}

@end
