//
//  JDSlideView.m
//  Slideshow
//
//  Created by James Diacono on 16/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import "JDSlideView.h"

// Private bits
@interface JDSlideView ()

// The spinning wheel of progress
@property (nonatomic, strong) UIActivityIndicatorView * activityView;

// The video player controller (if any)
@property (nonatomic, strong) MPMoviePlayerController * videoController;

// The audio player controller (if any)
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;

// Current video URL (if any)
@property (nonatomic, strong) NSURL * videoFile;

// Current audio URL (if any)
@property (nonatomic, strong) NSURL * audioFile;

// The play button for the video (if any)
@property (nonatomic, strong) UIImageView * playButton;

// Handler for play button tap
- (void) playButtonTapped:(UITapGestureRecognizer *)sender;

// Handler for slide tap
- (void) slideTapped:(UITapGestureRecognizer *)sender;

@end

@implementation JDSlideView

@synthesize delegate, activityView, videoController, playButton, videoFile, audioFile, audioPlayer;

- (id) initWithFrame:(CGRect)frame andTag:(NSUInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        // View setup
        self.tag = tag;
        self.clipsToBounds = YES;
        
        // Tap listener
        UITapGestureRecognizer * slideTap = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                    action:@selector(slideTapped:)];
        [self addGestureRecognizer:slideTap];
        
        // Add and permanently centre activity indicator
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        activityView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        activityView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                     | UIViewAutoresizingFlexibleLeftMargin
                                     | UIViewAutoresizingFlexibleRightMargin
                                     | UIViewAutoresizingFlexibleBottomMargin);
        activityView.hidesWhenStopped = YES;
        [activityView startAnimating];
        
        [self addSubview:activityView];
    }
    return self;
}

- (void)dealloc {
    // No more notifications, thank you
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void) layoutSubviews
{
    if (videoController != nil
        && [self.subviews containsObject:videoController.view]) {
        // Manually fit movie controller to frame (aspect fit)
        CGSize videoSize = videoController.naturalSize;
        CGSize viewSize = self.frame.size;
        
        if (videoSize.width != 0
            && videoSize.height != 0
            && viewSize.width != 0
            && viewSize.height != 0) {
            
            CGFloat hRatio = videoSize.width / viewSize.width;
            CGFloat vRatio = videoSize.height / viewSize.height;
            
            CGFloat aspectRatio = hRatio > vRatio ? hRatio : vRatio;
            CGSize newVideoSize = CGSizeMake(videoSize.width / aspectRatio, videoSize.height / aspectRatio);
            
            videoController.view.frame = CGRectMake(0, 0, newVideoSize.width, newVideoSize.height);
            videoController.view.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        }
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self setMediaStop];
}

#pragma mark - Public

- (void) prepareForReuse
{
    // Clear out subviews (including background)
    NSArray * subviews = [[NSArray alloc]initWithArray:self.subviews];
    for (UIView * v in subviews) {
        if (v != self.activityView) {
            [v removeFromSuperview];
        }
    }
    
    // Show activity view
    [activityView startAnimating];
    
    // Dispose of media related things
    self.videoController = nil;
    self.audioPlayer = nil;
    self.videoFile = nil;
    self.audioFile = nil;
    self.playButton = nil;
}

- (void) useViewAsContent:(UIView *)theView
{
    // Clear out any old content
    [self prepareForReuse];
    
    if (theView == nil) {
        // Bail if no view passed
        return;
    }
    
    // Setup view
    theView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    theView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    theView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Show view
    [self addSubview:theView];
    
    [activityView stopAnimating];
}

- (void) useVideoAsContent:(NSURL *)theVideoFile
{
    // Clear out old content
    [self prepareForReuse];
    
    // Store video file
    self.videoFile = theVideoFile;
    
    // Check if file exists
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    BOOL fileExists = theVideoFile != nil && [fileManager fileExistsAtPath:theVideoFile.relativePath];
    
    if (!fileExists) {
        // Bail if file does not exist or was not specified
        return;
    }
    
    // Prepare to load thumbnail
    [activityView stopAnimating];
    
    // Add play button
    self.playButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"playButton.png"] 
                                       highlightedImage:[UIImage imageNamed:@"playButtonHighlighted.png"]];
    playButton.frame = CGRectMake(0, 0, 80, 80);
    playButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    playButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                   | UIViewAutoresizingFlexibleLeftMargin
                                   | UIViewAutoresizingFlexibleRightMargin
                                   | UIViewAutoresizingFlexibleBottomMargin);
    playButton.userInteractionEnabled = YES;
    
    [self addSubview:playButton];
    
    // Setup play button listeners
    UITapGestureRecognizer * playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonTapped:)];
    [self.playButton addGestureRecognizer:playTap];
    
    // Generate thumbnail
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:videoFile options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    generator.appliesPreferredTrackTransform=TRUE;
    generator.maximumSize = CGSizeMake(960, 960);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        
        // Retain image so it isn't released at the end of this block
        if (im) {
            CGImageRetain(im);
        }
        
        // Get back on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage * thumbnail = nil;
            
            if (result == AVAssetImageGeneratorSucceeded) {
                thumbnail = [[UIImage alloc] initWithCGImage:im];
                
                if (thumbnail != nil) {
                    // Set up slide with thumbnail
                    UIImageView * thumbnailView = [[UIImageView alloc]initWithImage:thumbnail];
                    
                    thumbnailView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                    thumbnailView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
                    thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
                    thumbnailView.userInteractionEnabled = YES;
                    
                    [self insertSubview:thumbnailView belowSubview:playButton];
                    [self sendSubviewToBack:activityView];
                }
                
            } else {
                NSLog(@"AVAssetImageGenerator failed to create a thumbnail for the video, error: %@", error);
                
                // Uncomment to have another crack at generating the thumbnail
                // (MPMoviePlayerController probably does the same thing under the hood though)
                //            MPMoviePlayerController * temp = [[MPMoviePlayerController alloc] initWithContentURL:videoFile];
                //            temp.movieSourceType = MPMovieSourceTypeFile;
                //            thumbnail = [temp thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
                //            [temp release];
            }
            
            if (im) {
                CGImageRelease(im);
            }
            
        });
    };
    
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
}

- (void) useAudioAsContent:(NSURL *)theAudioFile withBackground:(UIView *)theBackground
{
    // Clear out old content
    [self prepareForReuse];
    
    // Store audio file
    self.audioFile = theAudioFile;
    
    // Check if file exists
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    BOOL fileExists = (theAudioFile != nil 
                       && [fileManager fileExistsAtPath:theAudioFile.relativePath]);
    
    if (!fileExists) {
        // Bail if file does not exist or was not specified
        self.audioFile = nil;
        return;
    }
    
    [activityView stopAnimating];
    
    // Add play button
    self.playButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"playButton.png"] 
                                       highlightedImage:[UIImage imageNamed:@"playButtonHighlighted.png"]];
    playButton.frame = CGRectMake(0, 0, 80, 80);
    playButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    playButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                   | UIViewAutoresizingFlexibleLeftMargin
                                   | UIViewAutoresizingFlexibleRightMargin
                                   | UIViewAutoresizingFlexibleBottomMargin);
    playButton.userInteractionEnabled = YES;
    
    [self addSubview:playButton];
    
    // Setup play button listeners
    UITapGestureRecognizer * playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonTapped:)];
    [self.playButton addGestureRecognizer:playTap];
    
    // Add background
    if (theBackground) {
        theBackground.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        theBackground.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                         | UIViewAutoresizingFlexibleLeftMargin
                                         | UIViewAutoresizingFlexibleRightMargin
                                         | UIViewAutoresizingFlexibleBottomMargin);
        [self addSubview:theBackground];
        [self sendSubviewToBack:theBackground];
    }
}

#pragma mark - Media controls

- (void) setMediaPlay
{
    if (self.videoFile) {
        [videoController play];
        [delegate slideView:self mediaPlaybackStateChanged:MPMoviePlaybackStatePlaying];
    } else if (self.audioFile) {
        [audioPlayer play];
        [delegate slideView:self mediaPlaybackStateChanged:MPMoviePlaybackStatePlaying];
        
        self.playButton.hidden = YES;
    }
}

- (void) setMediaPause
{
    if (self.videoFile) {
        [videoController pause];
        [delegate slideView:self mediaPlaybackStateChanged:MPMoviePlaybackStatePaused];
    } else if (self.audioFile) {
        [audioPlayer pause];
        [delegate slideView:self mediaPlaybackStateChanged:MPMoviePlaybackStatePaused];
        
        self.playButton.highlighted = NO;
        self.playButton.hidden = NO;
    }
}

- (void) setMediaStop
{
    if (self.videoFile) {
        [videoController stop];
        [delegate slideView:self mediaPlaybackStateChanged:MPMoviePlaybackStateStopped];
    } else if (self.audioFile) {
        [audioPlayer stop];
        [delegate slideView:self mediaPlaybackStateChanged:MPMoviePlaybackStateStopped];
        
        self.playButton.highlighted = NO;
        self.playButton.hidden = NO;
    }
}

#pragma mark - Private

- (void) playButtonTapped:(UITapGestureRecognizer *)sender
{
    playButton.highlighted = YES;
    
    if (self.videoFile) {
        // Create and configure media player
        self.videoController = [[MPMoviePlayerController alloc] initWithContentURL:videoFile];
        
        videoController.movieSourceType = MPMovieSourceTypeFile;
        videoController.scalingMode = MPMovieScalingModeAspectFit;
        videoController.controlStyle = MPMovieControlStyleNone;
        
        // We will manually set the frame later
        videoController.view.frame = CGRectZero;
        
        // Add invisble layer to receive taps
        UIView * tapInterceptor = [[UIView alloc] initWithFrame:CGRectZero];
        tapInterceptor.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                           | UIViewAutoresizingFlexibleHeight);
        
        // Listen for tap
        UITapGestureRecognizer * slideTap = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                    action:@selector(slideTapped:)];
        [tapInterceptor addGestureRecognizer:slideTap];
        [videoController.view addSubview:tapInterceptor];
        
        
        // Listen for video events
        NSNotificationCenter * dnc = [NSNotificationCenter defaultCenter];
        
        [dnc addObserver:self selector:@selector(videoDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoController];
        
        [dnc addObserver:self selector:@selector(videoDidChangeLoadState) name:MPMoviePlayerLoadStateDidChangeNotification object:self.videoController];

    } else if (self.audioFile) {
        NSError * error = nil;
        AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFile error:&error];
        
        if (error) {
            NSLog(@"Could not load audio file.");
        } else {
            self.audioPlayer = player;
            self.audioPlayer.delegate = self;
            [self setMediaPlay];
        }
        
    }
}

- (void) slideTapped:(UITapGestureRecognizer *)sender
{
    [delegate slideViewWasTapped:self];
}

#pragma mark - Notification handlers

- (void) videoDidFinish
{
    [self setMediaStop];
    
    [videoController.view removeFromSuperview];
    self.videoController = nil;
}

- (void) videoDidChangeLoadState
{
    [self addSubview:videoController.view];
    [self setNeedsLayout];
    
    [self setMediaPlay];
}

@end
