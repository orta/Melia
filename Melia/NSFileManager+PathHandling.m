//
//  NSFileManager+PathHandling.m
//  Melia
//
//  Created by orta therox on 12/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "NSFileManager+PathHandling.h"

@implementation NSFileManager (PathHandling)

- (NSString *)applicationDocumentsDirectoryPath {
    return [[[self URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
}

- (NSString *)applicationCachesDirectoryPath {
    return [[[self URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] path];
}

- (NSArray *)contentsOfPath:(NSString *)path {
    NSError *error = nil;
    NSArray *dirContents = [self contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        NSLog(@"Error %@", error.localizedFailureReason);
        return nil;
    }
    return dirContents;
}

- (NSArray *)filesInFolder:(NSString *)path withExtension:(NSString *)extension {
    NSArray * dirContents = [self contentsOfPath:path];
#warning fix one day
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'", extension];
	return [dirContents filteredArrayUsingPredicate:filter];
}

- (NSArray *)foldersInFolder:(NSString *)path {
    NSArray * dirContents = [self contentsOfPath:path];
    NSIndexSet *folderIndexes = [dirContents indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL isDir = NO;
        if ([self fileExistsAtPath:[path stringByAppendingPathComponent:obj] isDirectory:&isDir] && isDir) return YES;
        return NO;
    }];
	return [dirContents objectsAtIndexes:folderIndexes];
}


- (NSString *) filePathWithFolder:(NSString *)folderName
                        filename:(NSString *)imageName
                       extension:(NSString *)extension {
    
    NSString *directory = [[NSString alloc] initWithFormat:@"%@/%@", [self applicationDocumentsDirectoryPath], folderName];
    if (![self fileExistsAtPath:directory isDirectory:nil]) {
        NSError *error = nil;
        [self createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Error creating directory at path %@", folderName);
            NSLog(@"%@", [error userInfo]);
        }
    }
    return [[NSString alloc] initWithFormat:@"%@/%@.%@", directory, imageName, extension];
}


@end
