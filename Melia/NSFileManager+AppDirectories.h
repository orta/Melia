//
//  NSFileManager+AppDirectories.h
//  Artsy Folio
//
//  Created by orta therox on 02/08/2012.
//  Copyright (c) 2012 http://art.sy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (AppDirectories)
- (NSString *)applicationDocumentsDirectoryPath;
- (NSString *)applicationCachesDirectoryPath;
@end
