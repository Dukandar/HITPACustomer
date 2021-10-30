//
//  Configuration.m
//  HITPA
//
//  Created by Bathi Babu on 27/11/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "Configuration.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@interface Configuration ()

@property (nonatomic, strong) NSDictionary *infoDictionary;

@end

@implementation Configuration

+ (Configuration *)shareConfiguration
{
    
    static Configuration *_shareConfiguration = nil;
    static dispatch_once_t onceToke ;
    dispatch_once(&onceToke, ^{
        
        _shareConfiguration = [[Configuration alloc]init];
        
    });
    
    return _shareConfiguration;
    
}

- (instancetype)init
{
    
    self = [super init];
    if(self)
    {
        self.infoDictionary = [[NSBundle mainBundle] infoDictionary];
    }
    
    return self;
}

- (UIFont *)hitpaFontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size];
}

- (UIFont *)hitpaBoldFontWithSize:(CGFloat)size
{
    
    return [UIFont boldSystemFontOfSize:size];
}

+ (NSString *)appGroupName
{
    
    return @"com.HITPA.in";
    
}

- (NSString *)appName
{
    
    return NSLocalizedString(@"HITPA", nil);
    
}

- (NSString *)baseURL
{
    
    return [self.infoDictionary objectForKeyedSubscript:@"BaseURL"];
    
}

- (NSString *)timeInterval
{
    
    return [self.infoDictionary objectForKey:@"TimeInterval"];
}

- (NSString *)deviceModelName {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"iPhone Simulator",
      @"x86_64":   @"iPad Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      @"iPhone7,2":    @"iPhone 6",
      @"iPhone7,1":    @"iPhone 6 Plus",
      @"iPhone8,1":    @"iPhone 6s",
      @"iPhone8,2":    @"iPhone 6s Plus",
      @"iPhone8,4":    @"iPhone SE",
//      @"iPhone9,1":    @"iPhone 7",
//      @"iPhone9,2":    @"iPhone 7 Plus",
//      @"iPhone9,3":    @"iPhone 7",
//      @"iPhone9,4":    @"iPhone 7 Plus",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini(WiFi)",
      @"iPad2,6":  @"iPad Mini(GSM)",
      @"iPad2,7":  @"iPad Mini(GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      
      };
    
    NSString *deviceName = commonNamesDictionary[machineName];
    
    if (deviceName == nil) {
        
        deviceName = machineName;
        
    }
    
    return deviceName;
}

- (NSString *)serviceProvider
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init] ;
    
    NSString *serviceProvider = networkInfo.subscriberCellularProvider.carrierName;
    
    return serviceProvider;
}

#pragma FTP Credential Details
- (NSString *)ftpHostName
{
    return [self.infoDictionary objectForKeyedSubscript:@"ftp_hostname"];
}

- (NSString *)ftpIntimateHostName
{
    return [self.infoDictionary objectForKeyedSubscript:@"ftp_Intimatehostname "];
}

- (NSString *)downlaodFtpHostName
{
    return [self.infoDictionary objectForKeyedSubscript:@"ftp_downloadhostname "];
}

- (NSString *)ftpDirPath
{
    return [self.infoDictionary objectForKeyedSubscript:@"ftp_dirPath"];
}

- (NSString *)ftpUserName
{
    return [self.infoDictionary objectForKeyedSubscript:@"ftp_username"];
}

- (NSString *)ftpPassword
{
    return [self.infoDictionary objectForKeyedSubscript:@"ftp_password"];
}

@end
