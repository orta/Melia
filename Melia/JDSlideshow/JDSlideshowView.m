//
//  JDSlideshowView.m
//  Slideshow
//
//  Created by James Diacono on 15/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import "JDSlideshowView.h"

// Private bits
@interface JDSlideshowView ()

// Main scroll view
@property (nonatomic, strong) UIScrollView * scrollView;

// Sits inside the scroll view, it encapsulates all the
// slide views and is used as the view to zoom
@property (nonatomic, strong) UIView * containerView;

// Remembers the current size so layoutSubviews can compare and
// contrast
@property (nonatomic) CGSize currentSize;

// Ensures that a slide exists and is situated correctly.
// If a slide aleady exists at index, it is replaced.
- (void) addSlideForIndex:(NSUInteger)index;

// Positions the slides properly and configure scrollview
// to the correct size
- (void) refreshScrollView;

// Deduces the minimum number of slides which could be scrolled
// through.
- (NSUInteger) minimumNumberOfSlides;

// Navigates to the current slide, optionally animated
- (void) showCurrentSlideAnimated:(BOOL)animated;

// Updates the currentSlideIndex without affecting the UI.
// 'user' is true if the user has dragged to a new slide.
- (void) updateCurrentSlideIndex:(NSUInteger)newIndex 
                         dragged:(BOOL)dragged;

// Gets the slide for a specified index (nil if it
// does not exist)
- (JDSlideView *) slideForIndex:(NSUInteger)index;

// Releases the views which are outside the buffer zone
- (void) releaseUnusedSlides;

// Whether the scroller is in zoom mode or not
- (BOOL) isZoomed;

@end

@implementation JDSlideshowView

@synthesize delegate, slideInsets, scrollView, slideBuffer, currentSlideIndex, currentSize, transitioning, containerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Defaults
        slideInsets = UIEdgeInsetsZero;
        currentSlideIndex = 0;
        slideBuffer = 2;
        currentSize = frame.size;
        transitioning = NO;
        
        // Create scroll view to always fit flush in this view's frame
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 4.0;
        [self addSubview:scrollView];
        
        // Create container view (which directly holds the slides)
        self.containerView = [[UIView alloc]initWithFrame:CGRectZero];
        containerView.clipsToBounds = YES;
        [scrollView addSubview:containerView];
        
        
        // Wire up memory warning handler
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didReceiveMemoryWarning) 
                                                     name:UIApplicationDidReceiveMemoryWarningNotification 
                                                   object:[UIApplication sharedApplication]];
    }
    
    return self;
}

- (void) didReceiveMemoryWarning
{
    // In case the app can't keep up with this memory usage, reduce the buffer
    self.slideBuffer = slideBuffer > 0 ? slideBuffer - 1 : 0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}

#pragma mark - Layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize newSize = self.frame.size;
    if (newSize.width != currentSize.width
        || newSize.height != currentSize.height) {
        
        currentSize = newSize;
        
        // Dimensions have changed, refresh the scroll view
        [self refreshScrollView];
        
        // Realign scroll view
        [self showCurrentSlideAnimated:NO];
    }
}

- (void) addSlideForIndex:(NSUInteger)index
{
    // Reset slide
    JDSlideView * slide = [self slideForIndex:index];
    
    if (slide) {
        [slide prepareForReuse];
    } else {
        slide = [[JDSlideView alloc] initWithFrame:CGRectZero andTag:index + 1];
    }
    
    slide.delegate = self;
    [containerView addSubview:slide];
    
    // Position and resize via refreshing the scroll view
    [self refreshScrollView];
}

- (void) refreshScrollView
{
    NSUInteger slideCount = [self minimumNumberOfSlides];
    CGSize page = self.frame.size;
    
    // Make content size big enough
    CGRect contentFrame = CGRectMake(0, 0, page.width * slideCount, page.height);
    scrollView.contentSize = contentFrame.size;
    containerView.frame = contentFrame;
    
    // Position slides
    for (UIView * container in [containerView subviews]) {
        container.frame = CGRectMake(page.width * (container.tag - 1) + slideInsets.left, 
                                     slideInsets.top, 
                                     page.width - slideInsets.left - slideInsets.right, 
                                     page.height - slideInsets.top - slideInsets.bottom);
    }
}

- (void) showCurrentSlideAnimated:(BOOL)animated
{
    CGFloat offset = self.frame.size.width * currentSlideIndex;
    [scrollView setContentOffset:CGPointMake(offset, 0) animated:animated];
    
    if (animated) {
        transitioning = YES;
    }
}

#pragma mark - Getter/setters

- (void) setSlideBuffer:(NSUInteger)theBuffer
{
    slideBuffer = theBuffer;
    
    [self releaseUnusedSlides];
}

- (void) setSlideInsets:(UIEdgeInsets)theSlideInsets
{
    slideInsets = theSlideInsets;
    
    [self refreshScrollView];
}

- (NSUInteger) minimumNumberOfSlides
{
    // Always make sure there's a page ahead (if it exists)
    NSUInteger min = currentSlideIndex + (slideBuffer == 0 ? 1 : slideBuffer);
    
    while (![delegate slideshowView:self slideExistsAtIndex:min]) {
        min--;
        
        if (min == 0) {
            break;
        }
    }
    
    return min + 1;
}

- (JDSlideView *) slideForIndex:(NSUInteger)index
{
    JDSlideView * foundSlide = nil;
    
    for (UIView * v in [containerView subviews]) {
        if (v.tag == index + 1) {
            foundSlide = (JDSlideView *)v;
            break;
        }
    }
    
    return foundSlide;
}

#pragma mark - Other

- (void) updateCurrentSlideIndex:(NSUInteger)newIndex 
                         dragged:(BOOL)dragged
{
    NSUInteger oldIndex = currentSlideIndex;
    
    // Cancel any media playback
    if (oldIndex != newIndex) {
        [self setMediaStop];
    }
    
    // Update state
    currentSlideIndex = newIndex;
    
    /*
     * Load surrounding slides
     */
    
    NSUInteger slideCount = [self minimumNumberOfSlides];
    
    // Get buffer zone range
    int bufferStart = newIndex - slideBuffer;
    int bufferEnd = newIndex + slideBuffer;
    
    NSUInteger start = bufferStart < 0 ? 0 : bufferStart;
    NSUInteger end = bufferEnd > (slideCount - 1) ? (slideCount - 1) : bufferEnd;
    
    NSUInteger i = start;
    
    while (i <= end) {
        JDSlideView * slide = [self slideForIndex:i];
        
        // Check slide does not exist
        if (slide == nil) {
            // Create container and fetch slide view
            [self addSlideForIndex:i];
            
            [delegate slideshowView:self fetchContentForSlideAtIndex:i];
        }
        
        i++;
    }
    
    // Kill the slides outside the buffer zone
    [self releaseUnusedSlides];
    
    // Inform delegate
    if (newIndex != oldIndex
        && dragged) {
        [delegate slideshowView:self draggedFromIndex:oldIndex toIndex:newIndex];
    }
    
    [self refreshScrollView];
}

- (void) releaseUnusedSlides
{
    NSUInteger lowBufferIndex = currentSlideIndex > slideBuffer ? currentSlideIndex - slideBuffer : 0;
    NSUInteger highBufferIndex = currentSlideIndex + slideBuffer; // does not matter if this is out of range
    
    NSArray * subviews = [[NSArray alloc]initWithArray:containerView.subviews];
    for (UIView * v in subviews) {
        NSUInteger index = v.tag - 1;
        
        if (index < lowBufferIndex 
            || index > highBufferIndex) {
            [v removeFromSuperview];
        }
    }
}

- (BOOL) isZoomed
{
    return scrollView.zoomScale > scrollView.minimumZoomScale
            || scrollView.zooming
            || scrollView.zoomBouncing;
}

#pragma mark - Media controls

- (void) setMediaPlay
{
    [[self slideForIndex:currentSlideIndex] setMediaPlay];
}

- (void) setMediaPause
{
    [[self slideForIndex:currentSlideIndex] setMediaPause];
}

- (void) setMediaStop
{
    [[self slideForIndex:currentSlideIndex] setMediaStop];
}

#pragma mark - JDSlideshow

- (void) navigateToSlideIndex:(NSUInteger)newIndex
                     animated:(BOOL)animated
{
    if ([self.delegate slideshowView:self slideExistsAtIndex:newIndex]) {        
        [self updateCurrentSlideIndex:newIndex dragged:NO];
        [self showCurrentSlideAnimated:animated];
    }
}

- (void) reload
{
    // Clear all views
    NSArray * subviews = [[NSArray alloc]initWithArray:containerView.subviews];
    for (UIView * v in subviews) {
        [v removeFromSuperview];
    }
    
    // Reload
    NSUInteger newSlideIndex = [delegate slideshowView:self slideExistsAtIndex:currentSlideIndex] ? currentSlideIndex : 0;
    
    [self navigateToSlideIndex:newSlideIndex animated:NO];
    
}

- (void) loadView:(UIView *)view forSlideAtIndex:(NSUInteger)forIndex
{
    JDSlideView * slide = [self slideForIndex:forIndex];
    
    if (slide != nil) {
        [slide useViewAsContent:view];
    }
}

- (void) loadVideo:(NSURL *)videoURL forSlideAtIndex:(NSUInteger)forIndex
{
    JDSlideView * slide = [self slideForIndex:forIndex];
    
    if (slide != nil) {
        [slide useVideoAsContent:videoURL];
    }
}

- (void) loadAudio:(NSURL *)audioURL forSlideAtIndex:(NSUInteger)forIndex withBackground:(UIView *)theBackground
{
    JDSlideView * slide = [self slideForIndex:forIndex];
    
    if (slide != nil) {
        [slide useAudioAsContent:audioURL withBackground:theBackground];
    }
}

#pragma mark - JDSlideViewDelegate

- (void) slideViewWasTapped:(JDSlideView *)theSlide
{
    [delegate slideshowViewWasTapped:self];
}

- (void) slideView:(JDSlideView *)theSlide mediaPlaybackStateChanged:(MPMoviePlaybackState)newState
{
    [delegate slideshowView:self mediaPlaybackStateChanged:newState];
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)theScrollView
{
    transitioning = NO;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)theScrollView
{
    if (![self isZoomed]) {
        transitioning = YES;
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)theScrollView willDecelerate:(BOOL)decelerate
{
    if (transitioning) {
        // Calculate new index
        NSUInteger newIndex = (NSUInteger)round(theScrollView.contentOffset.x / self.frame.size.width);
        
        // Update current index
        [self updateCurrentSlideIndex:newIndex dragged:YES];
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    if (transitioning) {
        transitioning = NO;
        
        // Calculate new index
        NSUInteger newIndex = (NSUInteger)round(theScrollView.contentOffset.x / self.frame.size.width);
        
        // Update current index
        [self updateCurrentSlideIndex:newIndex dragged:YES];
    }
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)theScrollView
//{
//    return containerView;
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
//{
//}

@end
