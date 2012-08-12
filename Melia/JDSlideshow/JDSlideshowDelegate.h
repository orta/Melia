//
//  JDSlideshowDelegate.h
//  CrossCountry
//
//  Created by James Diacono on 18/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JDSlideshowDelegate <NSObject>

@required

// Asks the delegate to fetch the content for the slide
// at a corresponding index.  The delegate, once done, will
// pass the content directly to the slideshow.  While the slideshow
// is waiting for the content, it will display an activity indicator.
- (void) slideshow:(id<JDSlideshow>)theSlideshow 
fetchContentForSlideAtIndex:(NSUInteger)index;

// The number of slides in the slideshow
- (NSUInteger) slideshowNumberOfSlides:(id<JDSlideshow>)theSlideshow;

@optional

// The user caused the slideshow to navigate
- (void) slideshow:(id<JDSlideshow>)theSlideshow 
userNavigatedFromIndex:(NSUInteger)fromIndex 
           toIndex:(NSUInteger)toIndex;

// The user deleted a slide.  It is up to the delegate to
// refresh the slides in the slideshow
- (void) slideshow:(id<JDSlideshow>)theSlideshow
userDeletedSlideAtIndex:(NSUInteger)index;

@end
