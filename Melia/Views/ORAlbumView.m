//
//  ORAlbumView.m
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORAlbumView.h"
#import "UIImageView+AFNetworking.h"

@implementation ORAlbumView

- (void)setAlbum:(Album *)album {
    _album = album;
    self.titleLabel.text = album.title;
    NSLog(@"thumb %@", album.thumbnailImageAddress);
    NSString *address = [album.thumbnailImageAddress stringByAppendingString:@"?sn=4&tk=R8eFTRh8IYVEd4TBYkNYRcACeem3WheYR9WUqQoAOj8=&keyringx=EY2MpxFy1FdaLnodjONq7f-DrufemSc5iE9-vUu7bGdTcatZRZMwvxjoST5Y7kPG36NtGrF2rV7upVwXr61kXWstA52Ibf7KsNBikYIqDFzWFbDNTZKPJOGhGyy93Q1hPJH-ZDWFrVST81hLNKtPQVc6P0EqU3ka07LQ4tKaKrPt14zl03gN7BO-DW1cxGZ9"];
    [self.imageView setImageWithURL:[NSURL URLWithString:address]];
}

@end
