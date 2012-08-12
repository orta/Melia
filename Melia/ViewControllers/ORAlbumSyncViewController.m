//
//  ORAlbumSyncViewController.m
//  Melia
//
//  Created by orta therox on 11/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORAlbumSyncViewController.h"
#import "ARFileDownloadOperation.h"
#import "ORThumbnailOperation.h"
#import "NSFileManager+PathHandling.h"
#import "AFNetworking.h"

float RetinaImageViewSize = 188;
float LegacyImageViewSize = 94;

@interface ORAlbumSyncViewController (){
    NSOperationQueue *syncQueue;
}

@end

@implementation ORAlbumSyncViewController

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    self.titleLabel.text = [NSString stringWithFormat:@"Downloading %@", _name];
}

- (void)viewDidAppear:(BOOL)animated {
    int count = 0;
    syncQueue = [[NSOperationQueue alloc] init];
    NSString *albumPath = [NSString stringWithFormat:@"%@/%@/images", [[NSFileManager defaultManager] applicationDocumentsDirectoryPath], _name];
    [[NSFileManager defaultManager] createDirectoryAtPath:albumPath withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[albumPath stringByReplacingOccurrencesOfString:@"/images" withString:@"/thumbnails"] withIntermediateDirectories:YES attributes:nil error:nil];


    for (NSString *url in _urls) {
        NSString *address = [@"http://jamesmeliaphoto.zenfolio.com" stringByAppendingString:url];
        NSString *localPath = [NSString stringWithFormat:@"%@/%i.jpg", albumPath, count];
        address = [address stringByReplacingOccurrencesOfString:@"10.jpg" withString:@"4.jpg"];

        ARFileDownloadOperation *fileDownloadOperation = [ARFileDownloadOperation fileDownloadFromURL:[NSURL URLWithString:address] toLocalPath:localPath];
        [fileDownloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.imageView setImage:[UIImage imageWithContentsOfFile:localPath]];
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

        [syncQueue addOperation:fileDownloadOperation];
        [syncQueue addOperation:thumbnailOperation];
        count++;
    }
}

- (void)checkForFinish {
    if (syncQueue.operationCount == 0) {
        [self.delegate albumSyncDidFinish:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
