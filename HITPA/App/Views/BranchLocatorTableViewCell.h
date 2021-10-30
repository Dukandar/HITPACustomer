//
//  BranchLocatorTableViewCell.h
//  HITPA
//
//  Created by Selma D. Souza on 08/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol branchLocatorTableViewCell <NSObject>

- (void)callTappedWithNumber:(NSString *)phoneNumber;

@end

@interface BranchLocatorTableViewCell : UITableViewCell

@property (nonatomic, weak) id <branchLocatorTableViewCell>delegate;

- (instancetype)initWithDelegate:(id<branchLocatorTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath response:(NSMutableDictionary *)response;

@end
