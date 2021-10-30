//
//  ClaimsTableViewCell.h
//  HITPA
//
//  Created by Selma D. Souza on 07/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPolicyModel.h"
#import "HospitalModel.h"
#import "NIDropDown.h"

typedef enum {
    
    HospitalSearch = 0,
    PatientDetails,
    HospitalizationDetails
    
}SectionType;


@protocol claimsTableViewCell <NSObject>

- (void)postClaimsWithParams:(NSMutableDictionary *)params;
- (void)createDatePickerView:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;
- (void)populateDictWithFieldText:(NSString *)string tag:(NSInteger)tag;
- (void)hospitalSearch;
- (void)animateTextField:(UITextField*)textField isUp:(BOOL)isUp;
- (void)showDropDown;
- (void)nearMeHospital;
- (void)searchAgain;
- (void)hospitaWithDetail:(HospitalModel *)hospital;
- (void)memberWithDetails:(NSDictionary *)details;
- (void)feedbackWithIndex:(NSInteger)index feedbackStatus:(NSString *)status;
- (void)claimType:(NSString *)claimType;
- (void)getChoosedImages:(NSMutableArray *)selectedArray;
@end

@interface ClaimsTableViewCell : UITableViewCell<NIDropDownDelegate,UITextFieldDelegate>

@property (nonatomic, weak) id <claimsTableViewCell>delegate;

@property(strong,nonatomic)NSMutableArray *imagesArray,*selectedArray,*selectedImagesArray;

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath delegate:(id<claimsTableViewCell>)delegate segment:(NSInteger)segment response:(NSMutableDictionary *)response hospitalDetail:(NSMutableDictionary *)claimsDetail imagesArray:(NSMutableArray *)imagesArray isAttach:(BOOL) isAttach selectedArray:(NSMutableArray *)selectedArray;

@property (strong, nonatomic) UIView  *dropDownViews;
@property (nonatomic, strong) NIDropDown    * nIDropDown;



@end
