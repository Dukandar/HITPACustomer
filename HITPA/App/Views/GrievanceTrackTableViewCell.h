//
//  GrievanceTrackTableViewCell.h
//  HITPA
//
//  Created by Bhaskar C M on 12/23/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol griveanceTrackTableViewCell <NSObject>


@end

@interface GrievanceTrackTableViewCell : UITableViewCell

@property (nonatomic, weak) id <griveanceTrackTableViewCell>delegate;

- (instancetype)initWithDelegate:(id<griveanceTrackTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath complaint:(NSString *)complaint;
@end
