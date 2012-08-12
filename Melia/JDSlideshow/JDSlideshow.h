//
//  JDSlideshow.h
//  CrossCountry
//
//  Created by James Diacono on 18/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JDSlideshow <NSObject>

// Retrieves the slideshow's current position
- (NSUInteger) currentSlideIndex;

// Navigates to a specified slide index
- (void) navigateToSlideIndex:(NSUInteger)newIndex 
                     animated:(BOOL)animated;

// Reloads all loaded slides and the control states
- (void) reload;

// Loads a view for a specified slide index, replacing any existing content.
// The view will be retained while the slide is in the buffer zone, 
// then it will be released.
- (void) loadView:(UIView *)view forSlideAtIndex:(NSUInteger)forIndex;

// Loads a video for a specified slide index, replacing any existing content.
// A still is automatically extracted for the slide view.
- (void) loadVideo:(NSURL *)videoURL forSlideAtIndex:(NSUInteger)forIndex;

// Loads audio for a specified slide index, replacing any existing content.
// The slide's background will only be visible if set after this method is called.
- (void) loadAudio:(NSURL *)audioURL forSlideAtIndex:(NSUInteger)forIndex  withBackground:(UIView *)theBackground;

@end
