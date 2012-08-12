//
//  NSFileManager+PathHandling.h
//  Melia
//
//  Created by orta therox on 12/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (PathHandling)
- (NSArray *)filesInFolder:(NSString *)path withExtension:(NSString *)extension;
- (NSArray *)foldersInFolder:(NSString *)path;


- (NSString *)applicationDocumentsDirectoryPath;
- (NSString *)applicationCachesDirectoryPath;
- (NSArray *)contentsOfPath:(NSString *)path;
- (NSString *) filePathWithFolder:(NSString *)folderName
                         filename:(NSString *)imageName
                        extension:(NSString *)extension;
@end
