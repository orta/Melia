//
//  ORAlbumFinderViewController.m
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORAlbumFinderViewController.h"
#import "ORAlbumView.h"

static NSString *MeliaSite = @"http://jamesmeliaphoto.zenfolio.com";
static NSString *MeliaHomePage = @"http://jamesmeliaphoto.zenfolio.com/f634884173";

@interface ORAlbumFinderViewController (){
    NSArray *_albums;
}

@end

@implementation ORAlbumFinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    self.gridView.dataSource = self;

    [self loadPage:MeliaHomePage];
}

- (void)loadPage:(NSString *)page {
    NSURL * url = [NSURL URLWithString:page];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"should start %@", request.URL);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    NSString *address = aWebView.request.URL.absoluteString;
    NSLog(@"finished %@", address);
    
    if ([MeliaHomePage isEqualToString:address]) {
        NSString *prefix = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('folderCtr')[0].id"];
        NSString *folderRequest = [NSString stringWithFormat:@"JSON.stringify(_zfl_%@_init.data.folder)", prefix];
        NSString *JSONString = [_webView stringByEvaluatingJavaScriptFromString:folderRequest];

        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (error) {
            NSLog(@"%@", NSStringFromSelector(_cmd));
            NSLog(@"json parsing error.");
        }
        [self getFoldersFromJSON:json];
    }
}

- (void)getFoldersFromJSON: (NSDictionary *)dictionary {
    NSMutableArray *mutableAlbums = [NSMutableArray array];
    for (NSDictionary *folder in dictionary[@"$root"]) {
        NSDictionary *image = folder[@"image"];
        Album *album = [[Album alloc] init];
        album.title = folder[@"title"];
        NSString *cdnPath = [image[@"cdnPath"] stringByReplacingOccurrencesOfString:@"68jutwm64p1z" withString:@"jtrpzlbelhga"];
        NSString *address = [NSString stringWithFormat:@"%@/cdn%@/s11/v%@/%@%@-11.jpg", MeliaSite, cdnPath, image[@"_mapper"][@"_default"],image[@"prefix"], image[@"id"] ];
        album.thumbnailImageAddress = address;
        [mutableAlbums addObject:album];
    }
    _albums = mutableAlbums;
    [self.gridView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ORAlbumView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    cell.album = _albums[indexPath.row];
    return cell;
}

- (int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _albums.count;
}

@end
