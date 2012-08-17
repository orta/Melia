//
//  ORQueuedTransitionalImageView.h
//  Melia
//
//  Created by orta therox on 17/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

@interface ORQueuedTransitionalImageView : UIView

- (void)addImagePathToQueue:(NSString *)path;

@property (assign, nonatomic) NSTimeInterval transitionTime;

@end
