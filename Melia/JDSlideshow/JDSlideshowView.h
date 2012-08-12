//
//  JDSlideshowView.h
//  Slideshow
//
//  Created by James Diacono on 15/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JDSlideshow.h"
#import "JDSlideshowViewDelegate.h"
#import "JDSlideView.h"
#import "JDSlideViewDelegate.h"

// The workhorse of the slideshow.  Has no connection with
// any controls, however the user can drag from slide to slide
// (and the delegate will be informed).
//
// Will work with any view bounds, and auto transform itself when
// they change.
//
// Does not care about how many slides there are, it will ask the
// delegate as it goes along (meaning you can have an infinite/changing 
// number of slides).
//
// Lazy loads slides and removes them when they're out of view.
@interface JDSlideshowView : UIView <JDSlideshow, UIScrollViewDelegate, JDSlideViewDelegate>

// The only way to instantiate this class
- (id) initWithFrame:(CGRect)frame;

// The insets (padding) for each slide
@property (nonatomic) UIEdgeInsets slideInsets;

// Gets the index of the current slide, which will always be 
// greater than zero.  Default is zero, even if that slide does not exist.
@property (readonly) NSUInteger currentSlideIndex;

// Whether the slideshow is between slides
@property (readonly) BOOL transitioning;

// The number of slides to load before and after the current slide.
// Default is one.  Decreasing buffer size will purge extraneous slides.
@property (nonatomic) NSUInteger slideBuffer;

// The delegate of the slideshow view
@property (nonatomic, unsafe_unretained) id<JDSlideshowViewDelegate> delegate;

// Media controls (for active media)
- (void) setMediaPlay;
- (void) setMediaPause;
- (void) setMediaStop;

@end
