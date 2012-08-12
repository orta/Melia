//
//  JDSlideshowViewController.m
//  Slideshow
//
//  Created by James Diacono on 15/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import "JDSlideshowViewController.h"

@interface JDSlideshowViewController ()

// The specified style
@property (nonatomic) JDSlideshowStyle style;

// Refreshes the toolbar to fit the state of the slideshow
- (void) refreshControls;

@end

@implementation JDSlideshowViewController

@synthesize slideshow, style, delegate;

- (id)initWithSlideshowStyle:(JDSlideshowStyle)theStyle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {        
        style = theStyle;
        
        self.wantsFullScreenLayout = YES;
    }
    return self;
}


#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Create slideshow
    JDSlideshowController * ss = [[JDSlideshowController alloc] initWithSlideshowStyle:style];
    ss.delegate = self;
    self.slideshow = ss;
    
    self.view = slideshow.view;
}

- (void)viewDidUnload
{
    self.slideshow = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor blackColor];
    slideshow.slideshowView.slideInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];

    [slideshow reload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    [slideshow.slideshowView setMediaStop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Other

- (void) refreshControls
{
    self.title = [NSString stringWithFormat:@"%d of %d", slideshow.currentSlideIndex + 1, [delegate slideshowNumberOfSlides:self]];
}

#pragma mark - JDSlideshowControllerDelegate

- (void) slideshow:(id<JDSlideshow>)theSlideshow 
fetchContentForSlideAtIndex:(NSUInteger)index
{
    [delegate slideshow:self fetchContentForSlideAtIndex:index];
}

- (NSUInteger) slideshowNumberOfSlides:(id<JDSlideshow>)theSlideshow
{
    return [delegate slideshowNumberOfSlides:self];
}

- (void) slideshow:(JDSlideshowController *)theSlideshow 
didSetToolbarsVisible:(BOOL)visible 
          animated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:!visible animated:animated];
}

- (void) slideshow:(id<JDSlideshow>)theSlideshow 
userNavigatedFromIndex:(NSUInteger)fromIndex 
           toIndex:(NSUInteger)toIndex
{
    [self refreshControls];
    
    if ([delegate respondsToSelector:@selector(slideshow:userNavigatedFromIndex:toIndex:)]) {
        [delegate slideshow:self userNavigatedFromIndex:fromIndex toIndex:toIndex];
    }
}

- (void) slideshow:(id<JDSlideshow>)theSlideshow
userDeletedSlideAtIndex:(NSUInteger)index
{
    if ([delegate respondsToSelector:@selector(slideshow:userDeletedSlideAtIndex:)]) {
        [delegate slideshow:self userDeletedSlideAtIndex:index];
    }
}

#pragma mark - JDSlideshow

- (NSUInteger) currentSlideIndex
{
    return slideshow.currentSlideIndex;
}

- (void) navigateToSlideIndex:(NSUInteger)newIndex 
                     animated:(BOOL)animated
{    
    [slideshow navigateToSlideIndex:newIndex animated:animated];
    
    [self refreshControls];
}

- (void) reload
{
    [slideshow reload];
    
    [self refreshControls];
}

- (void) loadView:(UIView *)theView forSlideAtIndex:(NSUInteger)forIndex
{
    [slideshow loadView:theView forSlideAtIndex:forIndex];
    
    [self refreshControls];
}

- (void) loadVideo:(NSURL *)videoURL forSlideAtIndex:(NSUInteger)forIndex
{
    [slideshow loadVideo:videoURL forSlideAtIndex:forIndex];
    
    [self refreshControls];
}

- (void) loadAudio:(NSURL *)audioURL forSlideAtIndex:(NSUInteger)forIndex withBackground:(UIView *)theBackground
{
    [slideshow loadAudio:audioURL forSlideAtIndex:forIndex withBackground:theBackground];
    
    [self refreshControls];
}

@end
