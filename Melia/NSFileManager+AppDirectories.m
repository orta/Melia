//
//  NSFileManager+AppDirectories.m
//  Artsy Folio
//
//  Created by orta therox on 02/08/2012.
//  Copyright (c) 2012 http://art.sy. All rights reserved.
//

#import "NSFileManager+AppDirectories.h"

@implementation NSFileManager (AppDirectories)

- (NSString *)applicationDocumentsDirectoryPath {
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
}

- (NSString *)applicationCachesDirectoryPath {
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] path];
}


@end
