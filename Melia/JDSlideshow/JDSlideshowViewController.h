//
//  JDSlideshowViewController.h
//  Slideshow
//
//  Created by James Diacono on 15/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JDSlideshow.h"
#import "JDSlideshowController.h"
#import "JDSlideshowControllerDelegate.h"
#import "JDSlideshowDelegate.h"

// A wrapper for a JDSlideshowController that is a UIViewController
@interface JDSlideshowViewController : UIViewController <JDSlideshow, JDSlideshowControllerDelegate>

// Slideshow delegate
@property (nonatomic, unsafe_unretained) id<JDSlideshowDelegate> delegate;

// The underlying slideshow controller
@property (nonatomic, strong) JDSlideshowController * slideshow;

// Only way to init this
- (id)initWithSlideshowStyle:(JDSlideshowStyle)theStyle;

@end
