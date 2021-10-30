//
//  Gradients.m
//  HITPA
//
//  Created by Bathi Babu on 01/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "Gradients.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation Gradients

+ (Gradients *)shareGradients
{
    
    static Gradients *_shareGradients = nil;
    static dispatch_once_t onceToke ;
    dispatch_once(&onceToke, ^{
        
        _shareGradients = [[Gradients alloc]init];
        
    });
    
    return _shareGradients;
    
}
//Dashboard Mypolicy
- (CAGradientLayer *)myPolicy
{
    UIColor * color1 = [UIColor colorWithRed:15.0/255 green:160.0/255 blue:189.0/255 alpha:1.0];
    UIColor * color2 = [UIColor colorWithRed:15.0/255.0 green:143.0/255.0 blue:169.0/255 alpha:1.0];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)color1.CGColor,
                       (id)color2.CGColor,
                       nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    gradient.locations = locations;
    [gradient setStartPoint:CGPointMake(1, 0)];
    [gradient setEndPoint:CGPointMake(0, 1)];
    return gradient;
}
//Dashboard Updates
- (CAGradientLayer *)Updates
{
    UIColor * updatesColor1 = [UIColor colorWithRed:216.0/255 green:66.0/255 blue:73.0/255 alpha:1.0];
    UIColor * updatesColor2 = [UIColor colorWithRed:186.0/255.0 green:46.0/255.0 blue:52.0/255 alpha:1.0];
    CAGradientLayer *updatesGradient = [CAGradientLayer layer];
    updatesGradient.colors = [NSArray arrayWithObjects:
                              (id)updatesColor1.CGColor,
                              (id)updatesColor2.CGColor,
                              nil];
    NSNumber *updatesstopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *updatesstopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *updateslocations = [NSArray arrayWithObjects:updatesstopOne, updatesstopTwo, nil];
    updatesGradient.locations = updateslocations;
    [updatesGradient setStartPoint:CGPointMake(1, 0)];
    [updatesGradient setEndPoint:CGPointMake(0, 1)];
    return updatesGradient;
}
// Dashboard quickconnect
- (CAGradientLayer *)quickConnect
{
    UIColor * quickconnectColor1 = [UIColor colorWithRed:221.0/255 green:172.0/255 blue:43.0/255 alpha:1.0];
    UIColor * quickconnectColor2 = [UIColor colorWithRed:199.0/255.0 green:154.0/255.0 blue:35.0/255 alpha:1.0];
    CAGradientLayer *quickconnectGradient = [CAGradientLayer layer];
    quickconnectGradient.colors = [NSArray arrayWithObjects:
                                   (id)quickconnectColor1.CGColor,
                                   (id)quickconnectColor2.CGColor,
                                   nil];
    NSNumber *quickconnectstopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *quickconnectstopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *quickconnectlocations = [NSArray arrayWithObjects:quickconnectstopOne, quickconnectstopTwo, nil];
    quickconnectGradient.locations = quickconnectlocations;
    [quickconnectGradient setStartPoint:CGPointMake(1, 0)];
    [quickconnectGradient setEndPoint:CGPointMake(0, 1)];
    return quickconnectGradient;
}
- (CAGradientLayer *)quickGuide
{
    UIColor * quickguideColor1 = [UIColor colorWithRed:5.0/255 green:149.0/255 blue:140.0/255 alpha:1.0];
    UIColor * quickguideColor2 = [UIColor colorWithRed:6.0/255.0 green:106.0/255.0 blue:99.0/255 alpha:1.0];
    CAGradientLayer *quickguideGradient = [CAGradientLayer layer];
    quickguideGradient.colors = [NSArray arrayWithObjects:
                                 (id)quickguideColor1.CGColor,
                                 (id)quickguideColor2.CGColor,
                                 nil];
    NSNumber *quickguidestopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *quickguidestopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *quickguidelocations = [NSArray arrayWithObjects:quickguidestopOne, quickguidestopTwo, nil];
    quickguideGradient.locations = quickguidelocations;
    [quickguideGradient setStartPoint:CGPointMake(1, 0)];
    [quickguideGradient setEndPoint:CGPointMake(0, 1)];
    return quickguideGradient;
}

- (CAGradientLayer *)grivence
{

    UIColor * griveanceColor1 = [UIColor colorWithRed:29.0/255 green:138.0/255 blue:207.0/255 alpha:1.0];
    UIColor * griveanceColor2 = [UIColor colorWithRed:25.0/255.0 green:102.0/255.0 blue:149.0/255 alpha:1.0];
    CAGradientLayer *grivenceGradient = [CAGradientLayer layer];
    grivenceGradient.colors = [NSArray arrayWithObjects:
                           (id)griveanceColor1.CGColor,
                           (id)griveanceColor2.CGColor,
                           nil];
    NSNumber *griveancestopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *griveancestopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *griveancelocations = [NSArray arrayWithObjects:griveancestopOne, griveancestopTwo, nil];
    grivenceGradient.locations = griveancelocations;
    [grivenceGradient setStartPoint:CGPointMake(1, 0)];
    [grivenceGradient setEndPoint:CGPointMake(0, 1)];
    return grivenceGradient;
}

- (CAGradientLayer *)hospitalSearch
{
    UIColor * hospitalColor1 = [UIColor colorWithRed:155.0/255 green:74.0/255 blue:210.0/255 alpha:1.0];
    UIColor * hospitalColor2 = [UIColor colorWithRed:133.0/255.0 green:56.0/255.0 blue:183.0/255 alpha:1.0];
    CAGradientLayer *hospitalGradient = [CAGradientLayer layer];
    hospitalGradient.colors = [NSArray arrayWithObjects:
                               (id)hospitalColor1.CGColor,
                               (id)hospitalColor2.CGColor,
                               nil];
    NSNumber *hospitalstopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *hospitalstopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *hospitallocations = [NSArray arrayWithObjects:hospitalstopOne, hospitalstopTwo, nil];
    hospitalGradient.locations = hospitallocations;
    [hospitalGradient setStartPoint:CGPointMake(1, 0)];
    [hospitalGradient setEndPoint:CGPointMake(0, 1)];
    return hospitalGradient;
}
- (CAGradientLayer *)claimsJunction
{
    UIColor * claimsColor1 = [UIColor colorWithRed:38.0/255 green:165.0/255 blue:98.0/255 alpha:1.0];
    UIColor * claimsColor2 = [UIColor colorWithRed:23.0/255.0 green:131.0/255.0 blue:75.0/255 alpha:1.0];
    CAGradientLayer *claimsGradient = [CAGradientLayer layer];
    claimsGradient.colors = [NSArray arrayWithObjects:
                             (id)claimsColor1.CGColor,
                             (id)claimsColor2.CGColor,
                             nil];
    NSNumber *claimsstopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *claimsstopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *claimslocations = [NSArray arrayWithObjects:claimsstopOne, claimsstopTwo, nil];
    claimsGradient.locations = claimslocations;
    [claimsGradient setStartPoint:CGPointMake(1, 0)];
    [claimsGradient setEndPoint:CGPointMake(0, 1)];

    return claimsGradient;
}

- (CAGradientLayer *)login
{
    UIColor * color1 = [UIColor colorWithRed:4.0/255 green:60.0/255 blue:119.0/255 alpha:1.0];
    UIColor * color2 = [UIColor colorWithRed:21.0/255.0 green:103.0/255.0 blue:189.0/255 alpha:1.0];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)color1.CGColor,
                       (id)color2.CGColor,
                       nil];

    return gradient;
}

- (CAGradientLayer *)background
{
    UIColor * claimsColor1 = [UIColor colorWithRed:36.0/255 green:53.0/255 blue:86.0/255 alpha:1.0];
    UIColor * claimsColor2 = [UIColor colorWithRed:94.0/255.0 green:152.0/255.0 blue:174.0/255 alpha:1.0];
    CAGradientLayer *claimsGradient = [CAGradientLayer layer];
    claimsGradient.colors = [NSArray arrayWithObjects:
                             (id)claimsColor1.CGColor,
                             (id)claimsColor2.CGColor,
                             nil];
    NSNumber *claimsstopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *claimsstopTwo = [NSNumber numberWithFloat:0.7];
    NSArray *claimslocations = [NSArray arrayWithObjects:claimsstopOne, claimsstopTwo, nil];
    claimsGradient.locations = claimslocations;
    [claimsGradient setStartPoint:CGPointMake(0.0, 0.6)];
    [claimsGradient setEndPoint:CGPointMake(1.0, 0.5)];
    
    return claimsGradient;
}

- (CAGradientLayer *)intimateButton
{
    UIColor * claimsColor1 = [UIColor colorWithRed:117.0/255 green:115.0/255 blue:202.0/255 alpha:1.0];
    UIColor * claimsColor2 = [UIColor colorWithRed:57.0/255.0 green:73.0/255.0 blue:166.0/255 alpha:1.0];
    CAGradientLayer *claimsGradient = [CAGradientLayer layer];
    claimsGradient.colors = [NSArray arrayWithObjects:
                             (id)claimsColor1.CGColor,
                             (id)claimsColor2.CGColor,
                             nil];
    NSNumber *claimsstopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *claimsstopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *claimslocations = [NSArray arrayWithObjects:claimsstopOne, claimsstopTwo, nil];
    claimsGradient.locations = claimslocations;
    [claimsGradient setStartPoint:CGPointMake(1, 0)];
    [claimsGradient setEndPoint:CGPointMake(0, 1)];
    
    return claimsGradient;
}

- (CAGradientLayer *)cancel
{
    UIColor * color1 = [UIColor colorWithRed:4.0/255 green:60.0/255 blue:119.0/255 alpha:1.0];
    UIColor * color2 = [UIColor colorWithRed:21.0/255.0 green:103.0/255.0 blue:189.0/255 alpha:1.0];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)color1.CGColor,
                       (id)color2.CGColor,
                       nil];
    
    return gradient;
}

- (CAGradientLayer *)passwordEmail
{
    UIColor * color1 = [UIColor colorWithRed:4.0/255 green:60.0/255 blue:119.0/255 alpha:1.0];
    UIColor * color2 = [UIColor colorWithRed:21.0/255.0 green:103.0/255.0 blue:189.0/255 alpha:1.0];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)color1.CGColor,
                       (id)color2.CGColor,
                       nil];
    
    return gradient;
}


@end
