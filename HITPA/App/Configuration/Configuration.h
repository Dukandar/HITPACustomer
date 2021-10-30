//
//  Configuration.h
//  HITPA
//
//  Created by Bathi Babu on 27/11/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Configuration : NSObject

+ (Configuration *)shareConfiguration;
- (UIFont *)hitpaFontWithSize:(CGFloat)size;
+ (NSString *)appGroupName;
- (UIFont *)hitpaBoldFontWithSize:(CGFloat)size;
- (NSString *)appName;
- (NSString *)baseURL;
- (NSString *)timeInterval;
- (NSString *)deviceModelName;
- (NSString *)serviceProvider;
- (NSString *)ftpHostName;
- (NSString *)ftpUserName;
- (NSString *)ftpPassword;
- (NSString *)ftpDirPath;
- (NSString *)downlaodFtpHostName;
- (NSString *)ftpIntimateHostName;
@end
