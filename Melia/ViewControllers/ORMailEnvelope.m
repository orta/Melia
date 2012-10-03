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

static CGFloat ORImageMovementDuration = 0.5;
static CGFloat ORImagePullOutOfEnvelopeDistance = 30;
static CGFloat ORImageSideMargin = 40;

@implementation ORMailEnvelopeViewController

// This view starts off transparent

- (void)viewWillAppear:(BOOL)animated {
    self.view.alpha = 0;
    [super viewWillAppear:animated];
}

- (void)animateViewInWithImageViews:(NSArray *)imageViews {
    self.view.alpha = 1;
    CGFloat yPosition = CGRectGetMinY(_envelopeView.frame) - ORImagePullOutOfEnvelopeDistance;
    CGFloat envelopeSpace = CGRectGetWidth(_envelopeView.frame) - ORImageSideMargin ;

    for (UIImageView *imageView in imageViews) {
        NSInteger index = [imageViews indexOfObject:imageView];
        CGFloat xPosition = 40 + ORImageSideMargin + _envelopeView.frame.origin.x + (envelopeSpace / imageViews.count) * index + 1;

        [self.view insertSubview:imageView aboveSubview:_backgroundView];

        CAAnimation *movementAnimation = [self animationForImageView:imageView toCenterPoint:CGPointMake(xPosition, yPosition)];
        CAAnimation *rotationAnimation = [self randomRotationAnimation];

        [imageView.layer addAnimation:movementAnimation forKey:@"MoveIntoEnvelope"];
        [imageView.layer addAnimation:rotationAnimation forKey:@"RotateForEnvelope"];
    }
}

- (CABasicAnimation *)randomRotationAnimation {
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = @(0);
    CGFloat random = arc4random() % 40;
    CGFloat toRotation =  ((random) / 100)  - 0.2 ;
    NSLog(@" %f ", toRotation);
    rotation.toValue = @(toRotation);
    rotation.duration = ORImageMovementDuration;
    rotation.removedOnCompletion = NO;
    rotation.fillMode = kCAFillModeForwards;
    return rotation;
}

- (CAKeyframeAnimation *)animationForImageView:(UIImageView *)imageView toCenterPoint:(CGPoint)endPoint {
    // Setup an a animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = ORImageMovementDuration;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
