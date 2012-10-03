//
//  ORSlidingPhotoViewController.h
//  Melia
//
//  Created by orta therox on 29/09/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface ORSlidingPhotoViewController : UIViewController <SwipeViewDataSource>
@property (strong) NSArray *photos;
@end
