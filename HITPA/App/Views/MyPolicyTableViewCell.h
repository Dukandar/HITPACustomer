//
//  MyPolicyTableViewCell.h
//  HITPA
//
//  Created by Selma D. Souza on 09/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPolicyModel.h"

typedef enum {
    
    MembersEnrolled,
    PolicyDetails,
    MemberCard
    
}PolicySectionType;

@protocol myPolicyTableViewCell <NSObject>

- (void)postClaimsWithParams:(NSMutableDictionary *)params;
- (void)cardTypeWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyPolicyTableViewCell : UITableViewCell

@property (nonatomic, weak) id <myPolicyTableViewCell>delegate;

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath delegate:(id<myPolicyTableViewCell>)delegate policyDetail:(MyPolicyModel *)policyDetail policySectionType:(PolicySectionType)policySectionType cardDetails:(NSMutableDictionary *)cardDetails;

@end
