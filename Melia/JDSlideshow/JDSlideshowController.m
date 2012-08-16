//
//  JDSlideshowController.m
//  CrossCountry
//
//  Created by James Diacono on 18/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import "JDSlideshowController.h"

// Private bits
@interface JDSlideshowController ()

// Toolbar related
@property (nonatomic, strong) UIBarButtonItem * previousButton;
@property (nonatomic, strong) UIBarButtonItem * nextButton;
@property (nonatomic, strong) UIBarButtonItem * trashButton;
@property (nonatomic) BOOL toolbarsVisible;

// Checks out the page control, as it's changed
- (void) pageControlChanged;

// Refreshes the state of whatever controls are involved here
- (void) refreshControls;

// Handlers for the toolbar items
- (void) previousButtonTouched;
- (void) nextButtonTouched;
- (void) trashButtonTouched;

@end

@implementation JDSlideshowController

@synthesize style, slideshowView, delegate, toolbar, pageControl, previousButton, nextButton, trashButton, toolbarsVisible, view;

- (id)initWithSlideshowStyle:(JDSlideshowStyle)theStyle
{
    self = [super init];
    if (self) {
        style = theStyle;
        toolbarsVisible = YES;
    }
    return self;
}


#pragma mark - Getters/setters

- (UIView *) view
{
    // Lazy load the view
    if (view == nil) {
        // Dummy frames
        CGRect dummyWhole = CGRectZero;
        CGRect dummyTop = CGRectZero;
        CGRect dummyBottom = CGRectZero;
        
        if (style == JDSlideshowStyleEdit || style == JDSlideshowStyleView) {
            // toolbar
            dummyWhole =  CGRectMake(0,  0, 100, 100);
            dummyTop =    CGRectMake(0,  0, 100, 100);
            dummyBottom = CGRectMake(0, 56, 100, 44);
            
            // Create toolbar
//            self.toolbar = [[UIToolbar alloc] initWithFrame:dummyBottom];
//            toolbar.barStyle = UIBarStyleBlackTranslucent;
//            toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth
//                                        | UIViewAutoresizingFlexibleTopMargin);
//            
//            // Create toolbar buttons
//            
//            UIImage * prev = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"leftArrow" 
//                                                                                                   ofType:@"png"]];
//            self.previousButton = [[UIBarButtonItem alloc] initWithImage:prev 
//                                                                   style:UIBarButtonItemStylePlain 
//                                                                  target:self 
//                                                                  action:@selector(previousButtonTouched)];
//            
//            UIImage * next = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"rightArrow" 
//                                                                                                   ofType:@"png"]];
//            self.nextButton = [[UIBarButtonItem alloc] initWithImage:next 
//                                                               style:UIBarButtonItemStylePlain 
//                                                              target:self 
//                                                              action:@selector(nextButtonTouched)];
//            
//            self.trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
//                                                                             target:self 
//                                                                             action:@selector(trashButtonTouched)];
//            UIBarButtonItem *flex1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//            UIBarButtonItem *flex2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//            
//            if (style == JDSlideshowStyleView) {
//                // Don't include trash button
//                [toolbar setItems:[NSArray arrayWithObjects:previousButton, flex1, nextButton, nil]];
//            } else if (style == JDSlideshowStyleEdit) {
//                // Include trash button
//                [toolbar setItems:[NSArray arrayWithObjects:previousButton, flex1, trashButton, flex2, nextButton, nil]];
//            }
//            

        } else if (style == JDSlideshowStyleQuick) {
            // paging control
            
            self.pageControl = [[UIPageControl alloc] init];
            pageControl.hidesForSinglePage = NO;
            pageControl.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                            | UIViewAutoresizingFlexibleTopMargin);
            [pageControl addTarget:self 
                            action:@selector(pageControlChanged) 
                  forControlEvents:UIControlEventValueChanged];
            
            CGSize size = [pageControl sizeForNumberOfPages:5];
            
            dummyWhole =  CGRectMake(0,  0, 100, 100);
            dummyTop =    CGRectMake(0,  0, 100, 100 - size.height);
            dummyBottom = CGRectMake(0, 100 - size.height, 100, size.height);
            
            pageControl.frame = dummyBottom;
        }
        
        // Load view
        UIView * v = [[UIView alloc]initWithFrame:dummyTop];
        v.frame = dummyWhole;
        v.clipsToBounds = YES;
        self.view = v;
        
        // Create slideshow view
        JDSlideshowView * sv = [[JDSlideshowView alloc]initWithFrame:dummyTop];
        sv.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                               |UIViewAutoresizingFlexibleHeight);
        
        self.slideshowView = sv;
        sv.delegate = self;
        [v addSubview:sv];
        
        // Add toolbar on top
        if (toolbar != nil) {
            [v addSubview:toolbar];
        }
        
        // Add page control on top
        if (pageControl != nil) {
            [v addSubview:pageControl];
        }
    }
    
    return view;
}

- (JDSlideshowView *) slideshowView
{
    if (slideshowView == nil) {
        // Load view
        [self view];
    }
    
    return slideshowView;
}

#pragma mark - Actions

- (void) previousButtonTouched
{
    [self navigateToSlideIndex:self.slideshowView.currentSlideIndex - 1 animated:YES];
}

- (void) nextButtonTouched
{
    [self navigateToSlideIndex:self.slideshowView.currentSlideIndex + 1 animated:YES];
}

- (void) trashButtonTouched
{
    if ([delegate respondsToSelector:@selector(slideshow:userDeletedSlideAtIndex:)]) {
        [delegate slideshow:self userDeletedSlideAtIndex:self.slideshowView.currentSlideIndex];
    }
}

- (void) pageControlChanged
{
    [self navigateToSlideIndex:[self.pageControl currentPage] animated:YES];
}

- (void) refreshControls
{
    self.pageControl.numberOfPages = [delegate slideshowNumberOfSlides:self];
    self.pageControl.currentPage = [self.slideshowView currentSlideIndex];
    
    self.previousButton.enabled = ([delegate slideshowNumberOfSlides:self] != 0
                                   && self.slideshowView.currentSlideIndex != 0);
    self.nextButton.enabled = ([delegate slideshowNumberOfSlides:self] != 0
                               && self.slideshowView.currentSlideIndex != [delegate slideshowNumberOfSlides:self] - 1);
}

- (void) setToolbarsVisible:(BOOL)visible animated:(BOOL)animated
{
    static BOOL animating = NO;
    
    // Cancel if we're already animating this, or there's no change
    if (animating || visible == toolbarsVisible) {
        return;
    }
    
    // Ask delegate
    if ([delegate respondsToSelector:@selector(slideshow:shouldSetToolbarsVisible:)]
        && ![delegate slideshow:self shouldSetToolbarsVisible:visible]) {
        // Bail if not allowed
        return;
    }
    
    CGPoint from = toolbar.center;
    // either move down or up
    CGPoint to = CGPointMake(from.x, from.y + (visible ? - toolbar.frame.size.height : toolbar.frame.size.height));
    
    if (animated) {
        animating = YES;
        
        [UIView animateWithDuration:0.2 
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^(void) {
                             toolbar.center = to;
                         } completion:^(BOOL finished) {
                             toolbarsVisible = visible;
                             animating = NO;
                         }];
    } else {
        self.toolbar.center = to;
        
        toolbarsVisible = visible;
    }
    
    // Inform delegate
    if ([delegate respondsToSelector:@selector(slideshow:didSetToolbarsVisible:animated:)]) {
        [delegate slideshow:self didSetToolbarsVisible:visible animated:animated];
    }
    
    // TODO: Set up timer to hide toolbars
    //    static NSDate * lastChange = nil;
    //    lastChange = [NSDate date];
    //    if (visible) {
    //        double delayInSeconds = 5.0;
    //        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //            if (toolbarsVisible
    //                && [lastChange timeIntervalSinceNow] >= delayInSeconds) {
    //                [self setToolbarsVisible:NO animated:YES];
    //            }
    //        });
    //    }
}

#pragma mark - JDSlideshowViewDelegate

- (BOOL) slideshowView:(JDSlideshowView *)theSlideshowView 
    slideExistsAtIndex:(NSUInteger)index
{
    return index < [delegate slideshowNumberOfSlides:self];
}

- (void) slideshowView:(JDSlideshowView *)theSlideshowView 
fetchContentForSlideAtIndex:(NSUInteger)index
{
    [delegate slideshow:self fetchContentForSlideAtIndex:index];
}

- (void) slideshowView:(JDSlideshowView *)theSlideshowView 
      draggedFromIndex:(NSUInteger)fromIndex 
               toIndex:(NSUInteger)toIndex
{
    [self refreshControls];
    
    if ([delegate respondsToSelector:@selector(slideshow:userNavigatedFromIndex:toIndex:)]) {
        [delegate slideshow:self userNavigatedFromIndex:fromIndex toIndex:toIndex];
    }
}

- (void) slideshowViewWasTapped:(JDSlideshowView *)theSlideshowView
{
    if ((style == JDSlideshowStyleView || style == JDSlideshowStyleEdit)) {
        [self setToolbarsVisible:!toolbarsVisible animated:YES];
    } else if (style == JDSlideshowStyleQuick) {
        [self.slideshowView setMediaStop];
    }
}

- (void) slideshowView:(JDSlideshowView *)theSlideshowView 
mediaPlaybackStateChanged:(MPMoviePlaybackState)newState
{
    // Changed toolbar items
    if (toolbar) {
        // Create buttons
        UIBarButtonItem * stopButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stopIcon.png"] style:UIBarButtonItemStylePlain target:theSlideshowView action:@selector(setMediaStop)];
        UIBarButtonItem * flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem * flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        if (newState == MPMoviePlaybackStatePlaying
            || newState == MPMoviePlaybackStatePaused) {
            [toolbar setItems:[NSArray arrayWithObjects:flex1, stopButton, flex2, nil] animated:YES];
        } else {
            [toolbar setItems:[NSArray arrayWithObjects:previousButton, flex1, trashButton, flex2, nextButton, nil] animated:YES];
        }
        
    }
}

#pragma mark - JDSlideshow

- (NSUInteger) currentSlideIndex
{
    return self.slideshowView.currentSlideIndex;
}

- (void) navigateToSlideIndex:(NSUInteger)newIndex 
                     animated:(BOOL)animated
{    
    NSUInteger oldIndex = self.currentSlideIndex;
    
    [self.slideshowView navigateToSlideIndex:newIndex animated:animated];
    
    if ([delegate respondsToSelector:@selector(slideshow:userNavigatedFromIndex:toIndex:)]) {
        [delegate slideshow:self userNavigatedFromIndex:oldIndex toIndex:newIndex];
    }
    
    [self refreshControls];
}

- (void) reload
{
    [self.slideshowView reload];
    
    [self refreshControls];
}

- (void) loadView:(UIView *)theView forSlideAtIndex:(NSUInteger)forIndex
{
    [self.slideshowView loadView:theView forSlideAtIndex:forIndex];
}

- (void) loadVideo:(NSURL *)videoURL forSlideAtIndex:(NSUInteger)forIndex
{
    [self.slideshowView loadVideo:videoURL forSlideAtIndex:forIndex];
}

- (void) loadAudio:(NSURL *)audioURL forSlideAtIndex:(NSUInteger)forIndex withBackground:(UIView *)theBackground
{
    [self.slideshowView loadAudio:audioURL forSlideAtIndex:forIndex withBackground:theBackground];
}

@end
