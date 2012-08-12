//
//  ORAlbumSyncViewController.m
//  Melia
//
//  Created by orta therox on 11/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORAlbumSyncViewController.h"
#import "ARFileDownloadOperation.h"
#import "NSFileManager+AppDirectories.h"
#import "AFNetworking.h"

@interface ORAlbumSyncViewController (){
    NSOperationQueue *downloadQueue;
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
    downloadQueue = [[NSOperationQueue alloc] init];
    NSString *albumPath = [NSString stringWithFormat:@"%@/%@/images", [[NSFileManager defaultManager] applicationDocumentsDirectoryPath], _name];
    [[NSFileManager defaultManager] createDirectoryAtPath:albumPath withIntermediateDirectories:YES attributes:nil error:nil];

    for (NSString *url in _urls) {
        NSString *address = [@"http://jamesmeliaphoto.zenfolio.com" stringByAppendingString:url];
        NSString *localPath = [NSString stringWithFormat:@"%@/%i.jpg", albumPath, count];

        ARFileDownloadOperation *fileDownloadOperation = [ARFileDownloadOperation fileDownloadFromURL:[NSURL URLWithString:address] toLocalPath:localPath];
        [fileDownloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.imageView setImage:[UIImage imageWithContentsOfFile:localPath]];
            if (downloadQueue.operationCount == 0) {
                [self.delegate albumSyncDidFinish:self];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Download for %@ failed - %@", address, error);
        }];

        [downloadQueue addOperation:fileDownloadOperation];
        count++;
    }
}

@end
