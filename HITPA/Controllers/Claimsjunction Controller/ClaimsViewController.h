//
//  ClaimsViewController.h
//  HITPA
//
//  Created by Selma D. Souza on 07/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    
    HospitalName = 00,
    Pincode,
    City,
    PatientName = 10,
    PhoneNo,
    EmailAddress,
    Diagnosis = 20,
    AdmissionDate,
    DischargeDate,
    ClaimAmount
    
}FieldType;

@interface ClaimsViewController : BaseViewController

- (void)createDatePickerView:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;

@end
