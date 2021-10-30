//
//  DownloadFormTableViewCell.h
//  HITPA
//
//  Created by Selma D. Souza on 28/07/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol downloadFormTableViewCell <NSObject>

- (void)emailPdf:(NSInteger)section;
- (void)updateEnteredEmailID:(NSString *)emailTxt section:(NSInteger)section;

@end

@interface DownloadFormTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) id <downloadFormTableViewCell>delegate;

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath emailTxt:(NSString *)emailTxt delegate:(id<downloadFormTableViewCell>)delegate;

@end
