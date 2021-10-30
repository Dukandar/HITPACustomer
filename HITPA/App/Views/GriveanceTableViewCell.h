//
//  GriveanceTableViewCell.h
//  HITPA
//
//  Created by Bhaskar C M on 12/18/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol griveanceTableViewCell <NSObject>

//- (void)getChoosedImages:(NSMutableArray *)selectedArray selectedImagesArray:(NSMutableArray *)selectedImagesArray; //OLD Code
- (void)getChoosedImages:(NSMutableArray *)selectedArray; //NEW Code

@end

@interface GriveanceTableViewCell : UITableViewCell

@property(strong,nonatomic)NSMutableArray *imagesArray,*selectedArray,*selectedImagesArray;

@property (nonatomic, weak) id <griveanceTableViewCell>delegate;

- (instancetype)initWithDelegate:(id<griveanceTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath grievnaceDetails:(NSMutableDictionary *)grievnaceDetails index:(NSInteger)index imagesArray:(NSMutableArray *)imagesArray isAttach:(BOOL) isAttach selectedArray:(NSMutableArray *)selectedArray;

@end
