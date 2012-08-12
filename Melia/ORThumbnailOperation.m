//
//  ARThumbnailDownloadOperation.m
//  Melia
//
//  Created by orta therox on 12/03/2012.
//  Copyright (c) 2012 http://art.sy. All rights reserved.

//  Image cropping based off http://brian-erickson.com/uiimage-thumbnails-in-objective-c-for-the-iph


#import "ORThumbnailOperation.h"
#import "NSFileManager+PathHandling.h"


NSString *ImageThumbnailExtension = @"jpg";

@interface ORThumbnailOperation (){
    NSString *_fromPath;
    NSString *_toPath;
    CGFloat _size;
}
@end

@implementation ORThumbnailOperation

+ (ORThumbnailOperation *)operationFromPath:(NSString *)imagePath toPath:(NSString *)toPath andSize:(CGFloat)theSize {
    ORThumbnailOperation *this = [[self alloc] initFromPath:imagePath toPath:toPath andSize:theSize];
    return this;
}

- (ORThumbnailOperation *)initFromPath:(NSString *)thePath toPath:(NSString *)toPath andSize:(CGFloat)theSize{
    if (self = [super init]) {
        _toPath = toPath;
        _fromPath = thePath;
        _size = theSize;
    }
    return self;
}

- (void)main {
    if ([[NSFileManager defaultManager] fileExistsAtPath:_fromPath]) {
        [self resizeImageFrom:_fromPath to:_toPath toSize:_size withCrop:NO];
    }
}

- (void)resizeImageFrom:(NSString *)fromPath to:(NSString *)toPath toSize:(CGFloat)dimension withCrop:(BOOL)crop {
    UIImage *image = [UIImage imageWithContentsOfFile:fromPath];
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    CGImageRef imageRef;
    CGRect rect;
    if (crop) {
        // check the size of the image, we want to make it
        // a square with sides the size of the smallest dimension
        if (size.width > size.height) {
            offsetX = (size.height - size.width) / 2;
            croppedSize = CGSizeMake(size.height, size.height);
        } else {
            offsetY = (size.width - size.height) / 2;
            croppedSize = CGSizeMake(size.width, size.width);
        }

        // Crop the image before resize
        CGRect clippedRect = CGRectMake(-offsetX, -offsetY, croppedSize.width, croppedSize.height);
        imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
        rect = CGRectMake(0.0, 0.0, dimension, dimension);

    } else {
        imageRef = CGImageRetain([image CGImage]);
        rect = CGRectMake(0.0, 0.0, dimension, dimension);


        //we're making sure these are intgral and even because otherwise
        //they'll be misaligned while centered
        //which forces an alphablend on the fractional pixels
        //http://www.ultrajoke.net/2011/12/cancel-dispatch_after/
        if (size.width > size.height) {
            rect.size.height = floor(dimension * (size.height/size.width));
            if (fmod(rect.size.height, 2.f) != 0) {
                rect.size.height -= 1.f;
            }
        } else {
            rect.size.width = floor(dimension * (size.width/size.height));
            if (fmod(rect.size.width, 2.f) != 0) {
                rect.size.width -= 1.f;
            }
        }
    }

    //we've compensated for the sizes already, so
    //we'll draw with a scale factor of 1
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1.f);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);

    // Done Resizing
    NSData *imageData = UIImageJPEGRepresentation(thumbnail, 0.8f);
    [imageData writeToFile:toPath atomically:YES];
}

@end
