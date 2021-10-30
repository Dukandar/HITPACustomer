//
//  DocumentDirectory.h
//  HITPA
//
//  Created by Selma D. Souza on 01/08/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentDirectory : NSObject

+ (DocumentDirectory *)shareDocumentDirectory;
@property (nonatomic, strong) NSString *mediaFolder;
- (NSURL *)directoryPath;
- (void)createDirectoryWithUsername:(NSString *)username;
- (BOOL)writePdfIntoDocumentDirectory:(NSData *)data pdfName:(NSString *)name;
- (NSData *)getPdfWithName:(NSString *)name;
- (BOOL)writeImageOrPdfIntoDocumentDirectory:(NSData *)data imageName:(NSString *)name;
- (NSData *)getImageOrPdfWithName:(NSString *)name;
- (BOOL)compressImagesWithUserName:(BOOL) isIntimate;
- (BOOL)zipWithUserName:(NSString *)name;
- (void)removeZipPathWithUserName:(NSString *)name;
- (NSMutableArray *)getImagesOrPdfsFromDocumentDirectory;
- (void) removeImageOrPdfWithName:(NSString *)name;
- (void)uploadMediaFolderToServer;
- (NSString *)saveWellnessTipsFile;
- (NSString *)getImageFormDirectotyWithPath:(NSString *)path;
- (BOOL)writeIntimateImageIntoDocumentDirectory:(NSData *)data imageName:(NSString *)name;
- (NSData *)getClaimImageOrPdfWithName:(NSString *)name;
@end
