//
//  DocumentDirectory.m
//  HITPA
//
//  Created by Selma D. Souza on 01/08/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import "DocumentDirectory.h"
#import "UserManager.h"
#import "ZipArchive.h"

@implementation DocumentDirectory

+ (DocumentDirectory *)shareDocumentDirectory
{
    
    static DocumentDirectory *_shareDocumentDirectory = nil;
    static dispatch_once_t onceToke ;
    dispatch_once(&onceToke, ^{
        
        _shareDocumentDirectory = [[DocumentDirectory alloc]init];
        
    });
    
    return _shareDocumentDirectory;
    
}

- (instancetype)init
{
    
    self = [super init];
    if(self)
    {
         NSString *mediaFolder;
    }
    
    return self;
}

- (NSURL *)directoryPath {
    
    NSString * url = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
    return [NSURL fileURLWithPath:url];
}


- (NSString *)stringDirectoryPath {
    
    NSString * url = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
    return url;
}

- (void)createDirectoryWithUsername:(NSString *)username {
    
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    NSURL *directoryPath = [[self directoryPath]URLByAppendingPathComponent:username];
    NSString *stringPath = [directoryPath absoluteString];
    NSURL *url = [NSURL URLWithString:stringPath];
    if ([filemanager fileExistsAtPath:url.path]) {
        
    }else {
        [[NSFileManager defaultManager]createDirectoryAtPath:directoryPath.path withIntermediateDirectories:true attributes:nil error:nil];
    }
}

- (BOOL)writePdfIntoDocumentDirectory:(NSData *)data pdfName:(NSString *)name {
    
    [self createDirectoryWithUsername:[[UserManager sharedUserManager]userName]];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.pdf",[[UserManager sharedUserManager]userName],name];
    NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
    if ([data writeToURL:fileURL atomically:true]) {
        return true;
    }else {
        return false;
    }
}

- (NSData *)getPdfWithName:(NSString *)name {
    
    NSData *data = [[NSData alloc]init];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.pdf",[[UserManager sharedUserManager]userName],name];
    NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:fileURL.path]) {
        return [[NSData alloc]initWithContentsOfURL: fileURL];
    }else {
        return data;
    }
}

- (BOOL)writeIntimateImageIntoDocumentDirectory:(NSData *)data imageName:(NSString *)name {
    
    [self createDirectoryWithUsername:@"Intimate"];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",@"Intimate",name];
    NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
    if ([data writeToURL:fileURL atomically:true]) {
        return true;
    } else {
        return false;
    }
}

- (BOOL)writeImageOrPdfIntoDocumentDirectory:(NSData *)data imageName:(NSString *)name {
    
    [self createDirectoryWithUsername:[[UserManager sharedUserManager]userName]];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",[[UserManager sharedUserManager]userName],name];
    NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
    if ([data writeToURL:fileURL atomically:true]) {
        return true;
    } else {
        return false;
    }
}

- (NSData *)getClaimImageOrPdfWithName:(NSString *)name {
    
    NSData *data = [[NSData alloc]init];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",@"Intimate",name];
    NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:fileURL.path]) {
        return [[NSData alloc]initWithContentsOfURL: fileURL];
    } else {
        return data;
    }
}

- (NSData *)getImageOrPdfWithName:(NSString *)name {
    
    NSData *data = [[NSData alloc]init];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",[[UserManager sharedUserManager]userName],name];
    NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:fileURL.path]) {
        return [[NSData alloc]initWithContentsOfURL: fileURL];
    } else {
        return data;
    }
}

- (BOOL)compressImagesWithUserName:(BOOL) isIntimate {

    [self createDirectoryWithUsername:(isIntimate) ? @"ftpuser_intimate/Intimate": DocumentDirectory.shareDocumentDirectory.mediaFolder];
        NSFileManager *filemanager = [[NSFileManager alloc]init];
    NSString *fileName = [NSString stringWithFormat:@"%@",(isIntimate) ? @"Intimate" : [[UserManager sharedUserManager]userName]];
        NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
        NSLog(@"%@",fileURL);
        if ([filemanager fileExistsAtPath:fileURL.path]) {
            
            NSArray *subPaths = [filemanager subpathsAtPath:fileURL.path];
            for (NSString *path in subPaths) {
                NSLog(@"path:%@", path);
                NSURL *imageUrl = [[self directoryPath] URLByAppendingPathComponent: [NSString stringWithFormat:@"%@/%@",fileName,path]];
                NSLog(@"imageUrl:%@", imageUrl);
                //Media URL
                NSURL *mediaImageUrl = [[self directoryPath] URLByAppendingPathComponent: [NSString stringWithFormat:@"%@/%@",(isIntimate) ? @"ftpuser_intimate/Intimate": DocumentDirectory.shareDocumentDirectory.mediaFolder,path]];
                 NSLog(@"mediaImageUrl:%@", mediaImageUrl);
                NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                UIImage *image = [UIImage imageWithData:imageData];
                UIImage *compressedImage = [self compressImage:image];
                if (compressedImage != nil) {
                    NSLog(@"compressed Image");
                    // Save image.
                    [UIImageJPEGRepresentation(image, 0.015) writeToURL:mediaImageUrl atomically:YES];
                }
            }
            return true;
        }
    return false;
}

- (void)uploadMediaFolderToServer {
    
    // Get current datetime
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    // Get the date time in NSString
    NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
    
    DocumentDirectory.shareDocumentDirectory.mediaFolder = [NSString stringWithFormat:@"%@%@", [[UserManager sharedUserManager]userName], dateInString];
    
    NSLog(@"mediaFolder:%@", DocumentDirectory.shareDocumentDirectory.mediaFolder);
}

- (NSString *)saveWellnessTipsFile{
    
    [[DocumentDirectory shareDocumentDirectory] createDirectoryWithUsername:@"Download/"];
    
    NSString *zipFileName = @"Download/";
    
    NSString *zipPathUrl = [[self stringDirectoryPath] stringByAppendingPathComponent:zipFileName];
    
    return zipPathUrl;
}

- (NSString *)getImageFormDirectotyWithPath:(NSString *)path{
    
       NSString *zipFileName = [NSString stringWithFormat:@"Download/%@",path];
       NSString *filePathUrl = [[self stringDirectoryPath] stringByAppendingPathComponent:zipFileName];
    return filePathUrl;
}

- (BOOL)zipWithUserName:(NSString *)name {
    
    NSString *zipFileName = [NSString stringWithFormat:@"%@.zip",name];
    NSURL *zipPathUrl = [[self directoryPath] URLByAppendingPathComponent:zipFileName];
    NSLog(@"zipPathUrl:%@", zipPathUrl);
    BOOL success = [self removeZipFileWithPath:zipPathUrl];
    NSLog(@"success:%d", success);
    ZipArchive *zipArchive = [ZipArchive new];
    [zipArchive CreateZipFile2:zipPathUrl.path];
    
    if (success) {
        NSFileManager *filemanager = [[NSFileManager alloc]init];
        NSString *fileName = [NSString stringWithFormat:@"%@/Intimate",name];
        NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
        NSLog(@"%@",fileURL);
        if ([filemanager fileExistsAtPath:fileURL.path]) {  
        
            NSArray *subPaths = [filemanager subpathsAtPath:fileURL.path];
            for (NSString *path in subPaths) {
                NSLog(@"path:%@", path);
                NSURL *imageUrl = [[self directoryPath] URLByAppendingPathComponent: [NSString stringWithFormat:@"%@/%@",fileName,path]];
                NSLog(@"imageUrl:%@", imageUrl);
                [zipArchive addFileToZip:imageUrl.path newname:path];
            }
        }
    }
    
    BOOL successCompressing = [zipArchive CloseZipFile2];
    if (successCompressing) {
        return true;
    }
    return false;
}

- (BOOL) removeZipFileWithPath:(NSURL *)zipPathUrl
{
    NSLog(@"removeZipFileWithPath:%@", zipPathUrl);
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    if ([filemanager fileExistsAtPath:zipPathUrl.path]) {
        [filemanager removeItemAtPath:zipPathUrl.path error:nil];
        return true;
    }
    return true;
}

- (void)removeZipPathWithUserName:(NSString *)name {
    /*
    NSString *zipFileName = [NSString stringWithFormat:@"%@.zip",name];
    NSURL *zipPathUrl = [[self directoryPath] URLByAppendingPathComponent:zipFileName];
    
    BOOL zipRemoveSuccess = [self removeZipFileWithPath:zipPathUrl];
    NSLog(@"Remove Zip Success:%d", zipRemoveSuccess);

    if (zipRemoveSuccess) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@",name];
        NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
        NSLog(@"%@",fileURL);
        BOOL folderRemoveSuccess = [self removeZipFileWithPath:fileURL];
        NSLog(@"Remove Folder Success:%d", folderRemoveSuccess);
     
     
        return true;
    }
    return false;
    */
    NSString *strFileName = name;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [enumerator nextObject])) {
        NSLog(@"The file name is - %@",filename);
        if ([filename containsString:strFileName]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
            NSLog(@"The folder:%@ is deleted successfully", fileManager);
        }
    }
}

- (void) removeImageOrPdfWithName:(NSString *)name
{
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",[[UserManager sharedUserManager]userName],name];
    NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
    
    BOOL removeSuccess = [self removeZipFileWithPath:fileURL];
    NSLog(@"removeSuccess:%d", removeSuccess);
}

- (NSMutableArray *)getImagesOrPdfsFromDocumentDirectory {
    
    NSMutableArray *imagesPdfsArray = [NSMutableArray new];
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    NSString *fileName = [NSString stringWithFormat:@"%@",[[UserManager sharedUserManager]userName]];
    NSURL *fileURL = [[self directoryPath]URLByAppendingPathComponent:fileName];
    NSLog(@"%@",fileURL);
    if ([filemanager fileExistsAtPath:fileURL.path]) {
        
        NSArray *subPaths = [filemanager subpathsAtPath:fileURL.path];
        for (NSString *path in subPaths) {
            NSLog(@"path:%@", path);
            [imagesPdfsArray addObject:path];
        }
    }
    return imagesPdfsArray;
}

- (UIImage *)compressImage:(UIImage *)inputImage {
    NSData *imageData = UIImageJPEGRepresentation(inputImage, 0.4);
    UIImage *image = [[UIImage alloc]initWithData:imageData];
    return image;
}

@end
