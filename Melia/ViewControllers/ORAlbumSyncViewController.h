//
//  ORAlbumSyncViewController.h
//  Melia
//
//  Created by orta therox on 11/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORAlbumSyncViewController;
@protocol ORAlbumSyncDelegate <NSObject>

- (void)albumSyncDidFinish:(ORAlbumSyncViewController *)controller;

@end

@interface ORAlbumSyncViewController : UIViewController

@property (weak) id <ORAlbumSyncDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property NSString *name;
@property NSSet *urls;

@end
