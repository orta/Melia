//
//  JDSlideshowControllerDelegate.h
//  Slideshow
//
//  Created by James Diacono on 15/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JDSlideshowDelegate.h"

@class JDSlideshowController;

@protocol JDSlideshowControllerDelegate <JDSlideshowDelegate>

@optional

// Notification that the toolbar was hidden
- (BOOL) slideshow:(JDSlideshowController *)theSlideshow 
shouldSetToolbarsVisible:(BOOL)visible;

// Notification that the toolbar was hidden
- (void) slideshow:(JDSlideshowController *)theSlideshow 
didSetToolbarsVisible:(BOOL)visible 
          animated:(BOOL)animated;

@end
