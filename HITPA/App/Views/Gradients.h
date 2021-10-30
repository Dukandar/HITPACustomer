//
//  Gradients.h
//  HITPA
//
//  Created by Bathi Babu on 01/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Gradients : NSObject
+ (Gradients *)shareGradients;
- (CAGradientLayer *)myPolicy;
- (CAGradientLayer *)Updates;
- (CAGradientLayer *)quickConnect;
- (CAGradientLayer *)quickGuide;
- (CAGradientLayer *)grivence;
- (CAGradientLayer *)hospitalSearch;
- (CAGradientLayer *)claimsJunction;
- (CAGradientLayer *)login;
- (CAGradientLayer *)background;
- (CAGradientLayer *)intimateButton;
- (CAGradientLayer *)cancel;
- (CAGradientLayer *)passwordEmail;

@end
