//
//  JDSlideView.h
//  Slideshow
//
//  Created by James Diacono on 16/09/11.
//  Copyright 2011 Communica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "JDSlideViewDelegate.h"

// The container view for a slideshow, it renders content passed to it
@interface JDSlideView : UIView <AVAudioPlayerDelegate>

// The delegate of the slide view
@property (nonatomic, unsafe_unretained) id<JDSlideViewDelegate> delegate;

// Only proper way to initialise this
- (id) initWithFrame:(CGRect)frame andTag:(NSUInteger)tag;

// Removes any content and releases subviews
- (void) prepareForReuse;

// Gives the slide a view to display (will replace any existing content)
- (void) useViewAsContent:(UIView *)theView;

// Gives the slide a video to display (will replace any existing content)
- (void) useVideoAsContent:(NSURL *)theVideoFile;

// Gives the slide audio to play (will replace any existing content)
- (void) useAudioAsContent:(NSURL *)theAudioFile withBackground:(UIView *)theBackground;

// Media controls
- (void) setMediaPlay;
- (void) setMediaPause;
- (void) setMediaStop;

@end
