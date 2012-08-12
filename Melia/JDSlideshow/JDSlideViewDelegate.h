//
//  JDSlideViewDelegate.h
//  Slideshow
//
//  Created by James Diacono on 16/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class JDSlideView;

@protocol JDSlideViewDelegate <NSObject>

@optional

// Tells the delegate that the slide was tapped in some non-functional way
- (void) slideViewWasTapped:(JDSlideView *)theSlide;

// Video events
- (void) slideView:(JDSlideView *)theSlide mediaPlaybackStateChanged:(MPMoviePlaybackState)newState;

@end
