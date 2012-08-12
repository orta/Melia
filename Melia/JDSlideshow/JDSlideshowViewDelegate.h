//
//  JDSlideshowViewDelegate.h
//  Slideshow
//
//  Created by James Diacono on 15/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class JDSlideshowView;

@protocol JDSlideshowViewDelegate <NSObject>

@required

// Determines if a slide exists at a certain index.
- (BOOL) slideshowView:(JDSlideshowView *)theSlideshowView 
    slideExistsAtIndex:(NSUInteger)index;

// Asks the delegate to fetch the content for the slide
// at a corresponding index.  The delegate, once done, will
// pass the content directly to the slideshowView. 
// While the slideshow is waiting for the content, 
// it will display an activity indicator.
- (void) slideshowView:(JDSlideshowView *)theSlideshowView 
fetchContentForSlideAtIndex:(NSUInteger)index;

@optional

// Informs the delegate that the currentSlideIndex has changed
// (either programmatically or due to user interaction)
- (void) slideshowView:(JDSlideshowView *)theSlideshowView 
      draggedFromIndex:(NSUInteger)fromIndex 
               toIndex:(NSUInteger)toIndex;

// Informs the delegate that the user tapped the slideshow view
// without it being handled
- (void) slideshowViewWasTapped:(JDSlideshowView *)theSlideshowView;

// Informs the delegate that media playback state changed (play/pause etc)
- (void) slideshowView:(JDSlideshowView *)theSlideshowView 
mediaPlaybackStateChanged:(MPMoviePlaybackState)newState;
@end
