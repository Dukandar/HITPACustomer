//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalModel.h"
#import "MyPolicyModel.h"

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
- (void)searchhospitaWithDetail:(HospitalModel *)hospitalDetail;
- (void)complaintType:(NSString *)complaintType;
- (void)complaintSubType:(NSString *)complaintSubType;
- (void)getPolicyNumber:(NSString *)policyNumber;
- (void)memberWithDetails:(NSDictionary *)details;
- (void)claimType:(NSString *)claimType;
- (void)notificationTime:(NSString *)notificationTime;

@optional


@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr imgArr:(NSArray *)imgArr direction:(NSString *)direction isIndex:(NSInteger)isIndex;
@end
