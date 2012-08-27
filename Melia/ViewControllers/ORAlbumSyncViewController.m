//
//  ORAlbumSyncViewController.m
//  Melia
//
//  Created by orta therox on 11/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "APP_SETUP.h"

#import "ORAlbumSyncViewController.h"
#import "ORFileDownloadOperation.h"
#import "ORThumbnailOperation.h"
#import "NSFileManager+PathHandling.h"
#import "AFNetworking.h"
#import "ORQueuedTransitionalImageView.h"

float RetinaImageViewSize = 188;
float LegacyImageViewSize = 94;

@interface ORAlbumSyncViewController (){
    __weak IBOutlet ORQueuedTransitionalImageView *_queuedImageView;

    NSOperationQueue *_syncQueue;
}

@end

@implementation ORAlbumSyncViewController

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    _queuedImageView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    self.titleLabel.text = [NSString stringWithFormat:@"Downloading %@", _name];
}

- (void)viewDidAppear:(BOOL)animated {
    int count = 0;
    _syncQueue = [[NSOperationQueue alloc] init];
    NSString *albumPath = [NSString stringWithFormat:@"%@/%@/images", [[NSFileManager defaultManager] applicationDocumentsDirectoryPath], _name];
    [[NSFileManager defaultManager] createDirectoryAtPath:albumPath withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[albumPath stringByReplacingOccurrencesOfString:@"/images" withString:@"/thumbnails"] withIntermediateDirectories:YES attributes:nil error:nil];


    for (NSString *url in _urls) {
        NSString *address = [PHOTOG_URL stringByAppendingString:url];
        NSString *localPath = [NSString stringWithFormat:@"%@/%i.jpg", albumPath, count];
        address = [address stringByReplacingOccurrencesOfString:@"10.jpg" withString:@"4.jpg"];

        ORFileDownloadOperation *fileDownloadOperation = [ORFileDownloadOperation fileDownloadFromURL:[NSURL URLWithString:address] toLocalPath:localPath];

        [fileDownloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

            [_queuedImageView addImagePathToQueue:localPath];
            [self checkForFinish];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Download for %@ failed - %@", address, error);
        }];

        BOOL isRetina = [[UIScreen mainScreen] scale] > 1;
        CGFloat size = isRetina? RetinaImageViewSize : LegacyImageViewSize;
        NSString *thumbnailPath = [localPath stringByReplacingOccurrencesOfString:@"/images/" withString:@"/thumbnails/"];
        ORThumbnailOperation *thumbnailOperation = [ORThumbnailOperation operationFromPath:localPath toPath:thumbnailPath andSize:size];
        [thumbnailOperation addDependency:fileDownloadOperation];
        [thumbnailOperation setCompletionBlock:^{
            [self checkForFinish];
        }];

        [_syncQueue addOperation:fileDownloadOperation];
        [_syncQueue addOperation:thumbnailOperation];
        count++;
    }
}

- (void)checkForFinish {
    if (_syncQueue.operationCount == 0) {
        [self.delegate albumSyncDidFinish:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
