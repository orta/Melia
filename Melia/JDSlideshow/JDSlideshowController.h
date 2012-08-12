//
//  JDSlideshowController.h
//  CrossCountry
//
//  Created by James Diacono on 18/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JDSlideshow.h"
#import "JDSlideshowView.h"
#import "JDSlideshowViewDelegate.h"
#import "JDSlideshowControllerDelegate.h"

typedef enum {
    JDSlideshowStyleQuick,
    JDSlideshowStyleView,
    JDSlideshowStyleEdit
} JDSlideshowStyle;

// Extends the JDSlideshowView to include optional controls.
// Does care about how many slides there are (for the controls' sakes).
//
// Usage:
// 1. Init with "initWithSlideshowStyle:"
// 2. Set delegate
// 3. Set "view" frame
// 4. Navigate to the first item
//
// Things to remember:
// 1. Tell any playing media to stop when the slideshow view disappears
//    (by calling [slideshowView setMediaStop])
// 2. Reload when any data might have changed
@interface JDSlideshowController : NSObject <JDSlideshow, JDSlideshowViewDelegate>

// The view which contains the controls and the slideshow
@property (nonatomic, strong) UIView * view;

// The internally used slideshow view (you can edit various
// presentational options through here)
@property (nonatomic, strong) JDSlideshowView * slideshowView;

// The style used in initialising this slideshow
@property (readonly) JDSlideshowStyle style;

// The slideshow delegate
@property (nonatomic, unsafe_unretained) id<JDSlideshowControllerDelegate> delegate;

// The toolbar at the bottom of the slideshow (if in view or edit mode)
@property (nonatomic, strong) UIToolbar * toolbar;

// The page control at the bottom of the slideshow (if in quick mode)
@property (nonatomic, strong) UIPageControl * pageControl;

// The only way to initialise this
- (id) initWithSlideshowStyle:(JDSlideshowStyle)theStyle;

// Toggles the toolbar's visibility (if it exists)
- (void) setToolbarsVisible:(BOOL)visible animated:(BOOL)animated;

@end
