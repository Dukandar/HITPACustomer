//
//  GrievanceViewController.m
//  HITPA
//
//  Created by Selma D. Souza on 08/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "GrievanceViewController.h"
#import "Configuration.h"
#import "Gradients.h"
#import "Constants.h"
#import "GrievanceTrackViewController.h"
#import "HITPAAPI.h"
#import "Utility.h"
//#import "KeyboardHelper.h"
#import "KeyboardConstants.h"
#import "CoreData.h"
#import "MyPolicyModel.h"
#import "UserManager.h"
#import "Helper.h"
#import "Greveance.h"
#import "DocumentDirectory.h"
#import "FTPHelper.h"
#import "CreateDirController.h"

typedef enum
{
    complaintRegarding = 0,
    claimNo,
    complaintRemark,
    uploadAttachment
}GrievanceType;

NSString * const kComplaintRequestType          = @"CallType";
NSString * const kComplaintClaimNumber         = @"ClaimNo";
NSString * const kCallerType                    = @"callerType";
NSString * const kComplaintRemark               = @"ServiceRequestDetails";
NSString * const kComplaintRequestStatus        = @"ServiceRequestStatus";
NSString * const kUploadDocument_ReferenceNo    = @"UploadDocument_ReferenceNo";
NSString * const kComplaintRemarkPlaceholder    = @"Complaint Remark";
NSString * const kComplaintAssignFromUser       = @"AssignFromUser";
NSString * const kComplaintSubType              = @"Complaint";
NSString * const kComplaintType                 = @"GrievanceType";
NSString * const kCellIdentifier                = @"cellIdentifier";
NSInteger  const kRaiseGrievanceTag             = 10000;
NSInteger  const kGrievanceTrackTag             = 20000;
NSInteger  const kGrievanceGuideTag             = 30000;
NSInteger  const kHeaderScrollTag               = 40000;
NSInteger  const kRaiseGrievanceLineTag         = 50000;
NSInteger  const kGrievanceTrackLineTag         = 60000;
NSInteger  const kGrievanceGuideLineTag         = 70000;
NSInteger  const kGrievanceTrackAlertTag        = 543223;
NSInteger  const kGrievanceStausLabelTag        = 55555;
NSInteger  const kGrievanceUploadScreenTag      = 54322;
NSInteger  const kGrievanceUploadPopUpTag       = 55556;
NSInteger  const kCompliantTextFieldTag         = 32000;
NSInteger  const kCompliantSubTextFieldTag      = 32001;

NSString * const boundry = @"unique-consistent-string";


@interface GrievanceViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NIDropDownDelegate,UITableViewDelegate,UITableViewDataSource,GrievanceTrack, FTPHelperDelegate, UIDocumentPickerDelegate>
@property (nonatomic, readwrite)    NSInteger             selectedSegment;
@property (nonatomic, strong)       NSMutableDictionary * dictionary,*policyDetail,*grievanceDetail;
@property (nonatomic, strong)       UIPickerView        * picker;
@property (nonatomic, strong)       NSMutableArray      * strings, *imagesArray, *selectedArray, *expandCollapse;
@property (nonatomic, strong)       UIView              * pickerView;
@property (strong, nonatomic)       UIView              * dropDownViews;
@property (nonatomic, strong)       NIDropDown          * nIDropDown;
@property (nonatomic, strong)       NSArray             * complaintsArray, *HealthArray, *claimArray, *policyArray, *providerArray;
@property(readwrite)                BOOL                  isAttach;
@end

@implementation GrievanceViewController

#pragma mark -
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.complaintsArray = [[NSArray alloc]initWithObjects:@"Health Card Related",@"Claims Related",@"Policy Related",@"Provider Related", nil];
    self.HealthArray = [[NSArray alloc]initWithObjects:@"Request to dispatch Card",@"Member/Dependent has lost card",@"Error in Cards",@"Request for E Card",@"Error in capturing member details",@"Card not received",@"No Photo on card (Upload Photo)", nil];
    self.claimArray = [[NSArray alloc]initWithObjects:@"Claim not settled",@"Claim submitted but not intimated/Lost",@"Deductions not justified",@"Delay in Claim processing",@"Documents submitted but details not updated",@"Error in settlement",@"Member does not agree with query Reason",@"Member does not agree with repudiation reason",@"Payment not received",@"Settlement letter not received", nil];
    self.policyArray = [[NSArray alloc]initWithObjects:@"Request for enrollment of members (Attach Policy schedule)",@"Guide book not received",@"Member not added endorsement received",@"Member not enrolled as per policy", nil];
    self.providerArray = [[NSArray alloc]initWithObjects:@"Poor Facility/ Poor Service",@"Incorrect Address/ facility details on Website", nil];
    self.grievanceDetail = [[NSMutableDictionary alloc]init];
//    self.imagesArray = [[NSMutableArray alloc]init];
//    self.selectedArray = [[NSMutableArray alloc]init];
//    [[KeyboardHelper sharedKeyboardHelper]notificationCenter:self.tableView view:self.view];
    self.dictionary = [[NSMutableDictionary alloc]init];
    self.navigationItem.title = NSLocalizedString(@"Complaint", @"");
    [self headerView];
    // [self reloadTableView];
    // Do any additional setup after loading the view.
    //Create Document Directory for Store and Retrieve Images
//    [[DocumentDirectory shareDocumentDirectory] createDirectoryWithUsername:[[UserManager sharedUserManager]userName]];
    //    NSLog(@"Before:%@", self.imagesArray);
    //    self.imagesArray = [[DocumentDirectory shareDocumentDirectory] getImagesOrPdfsFromDocumentDirectory];
    //     NSLog(@"After:%@", self.imagesArray);
//    [self uploadImagesUsingFTP];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTableView];
}

- (void)loadTableView {
    
    self.imagesArray = [[NSMutableArray alloc]init];
    self.selectedArray = [[NSMutableArray alloc]init];
    self.imagesArray = [[DocumentDirectory shareDocumentDirectory] getImagesOrPdfsFromDocumentDirectory];
    if (self.imagesArray.count > 0) {
//        [self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (NSArray *)returynGrievanceGuide
{
    return [[NSArray alloc]initWithObjects:@"a) Raise a Complaints and the interaction will be acknowledged immediately via a Complaints number",@"b)Within 48 hours the initial findings/feedback will be updated", @"c) Escalation Option will be available in the case there is no response within 48 hours", @"d) In case user wish to update the Complaints it can be done at any moment after Complaints number is created", @"e) The Complaints will be resolved within 7 working days and closed", @"f) Escalation Option will be available in case the issue is not closed after 7 working days",@"g) Re-open option will be available in case user is not satisfied with Complaints closure and will be actioned & updated within 48 hrs", @"h) In case of no response at this stage higher level escalation option will be available to the user", nil];
    
}
-(void)viewDidLayoutSubviews
{
    
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + 64.0, frame.size.width, frame.size.height - 128.0);
    [self.view layoutIfNeeded];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     //When Scroll User then HIDE the Table View
        if (self.dropDownViews != nil) {
            [self.dropDownViews removeFromSuperview];
            self.nIDropDown = nil;
        }
}

- (void)headerView
{
    CGRect frame = [self bounds];
    CGFloat xPos , yPos , width ,height;
    xPos    = 0.0 ;
    yPos    = 0.0;
    width   = frame.size.width;
    height  = 40;
    self.pickerView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerView];
    xPos = -75.0;
    yPos = 0.0;
    width = frame.size.width + 150.0;
    height = 35.0;
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(- M_PI/2);
    rotate = CGAffineTransformScale(rotate, 1.0, 1.0);
    [self.picker setTransform:rotate];
    self.picker.frame = CGRectMake(xPos, yPos, width , height);
    [self.pickerView addSubview:self.picker];
    [self raiseGrievance];
    [self belowView:@"Raise Complaint"];
    [self.picker selectRow:0 inComponent:0 animated:NO];
    
    //Status Label
    width = frame.size.width * 0.8;
    height = 40.0;
    xPos = roundf(frame.size.width - width)/2;
    yPos = roundf((frame.size.height - height - self.pickerView.frame.size.height - 50.0 - 64.0)/2);
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    statusLabel.tag = kGrievanceStausLabelTag;
    [statusLabel setHidden:YES];
    statusLabel.text = @"No Complaints";
    [statusLabel setTextColor:[UIColor whiteColor]];
    [statusLabel setTextAlignment:NSTextAlignmentCenter];
    [statusLabel setFont:[[Configuration shareConfiguration] hitpaBoldFontWithSize:14.0]];
    [self.tableView addSubview:statusLabel];

    
}

- (void)belowView :(NSString *)Header
{
    CGSize size = [Header sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:16]}];
    CGFloat xPos , yPos ,width ,height;
    xPos   = ([[UIScreen mainScreen]bounds].size.width)/3.1;
    yPos   = 35.0;
    width  =  size.width;
    height = 1.5;
    UIView * togglebelowView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    togglebelowView.backgroundColor =[UIColor colorWithRed:(25.0/255.0) green:(102.0/255.0) blue:(149.0/255.0) alpha:1.0f];
    togglebelowView.hidden = NO;
    [self.pickerView addSubview:togglebelowView];
}


- (UIView *)raiseGrievanceViewWithSectionType:(NSInteger)section
{
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    if(section == 0)
    {
        xPos = 0.0;
        yPos = 0.0;
        width =  frame.size.width;
        height = 360.0;
        UIView *sectionHeader = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
        yPos = 0.0;
        height = 360.0;
        UIView *sectionView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor]];
        sectionView.tag = section;
        [sectionHeader addSubview:sectionView];
        xPos = 3.0;
        yPos = 10.0;
        height = 40.0;
        width = frame.size.width - 2 * xPos;
        UIView *complaintTypeView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor]];//white
        complaintTypeView.layer.cornerRadius = 3;
        complaintTypeView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
        complaintTypeView.layer.borderWidth = 1.0;
        complaintTypeView.layer.masksToBounds = YES;
        [sectionView addSubview:complaintTypeView];
        
        
        xPos = 5.0;
        yPos = 5.0;
        width = (complaintTypeView.frame.size.width - 2 * xPos) - 30.0;
        height = 30.0;
        UITextField *complaintTextField = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        complaintTextField.tag = kCompliantTextFieldTag;
        //complaintTextField.text = [[self complaintRegarding] objectAtIndex:0];
        //[self.grievanceDetail setValue:[[self complaintRegarding] objectAtIndex:0] forKey:kComplaintRegarding];
        complaintTextField.delegate = self;
        NSAttributedString *compliantPlaceholder;
        compliantPlaceholder = [[NSAttributedString alloc]initWithString:@"Complaint Type" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:12.0]}];
        complaintTextField.attributedPlaceholder = compliantPlaceholder;
        complaintTextField.enabled = NO;
        complaintTextField.textColor = [UIColor blackColor];
//        complaintTextField.backgroundColor = [UIColor greenColor];
        complaintTextField.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
        [complaintTypeView addSubview:complaintTextField];
        
        xPos = complaintTextField.frame.origin.x + complaintTextField.frame.size.width + 5.0;
        width = 25.0;
        height = 25.0;
        yPos = (complaintTypeView.frame.size.height - height) / 2.0;
        //dropdown imageview
        UIImageView *complaintDropdown = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        complaintDropdown.image = [UIImage imageNamed:@"icon_dropdown.png"];
//        complaintDropdown.backgroundColor = [UIColor blackColor];
        [complaintTypeView addSubview:complaintDropdown];
        
        
        UIButton *complaintTypeBtn = [[UIButton alloc]initWithFrame:complaintTypeView.frame];
        [complaintTypeBtn addTarget:self action:@selector(complaintTypeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [complaintTypeView addSubview:complaintTypeBtn];
        
        xPos = 3.0;
        yPos = complaintTypeView.frame.origin.y +complaintTypeView.frame.size.height + 20.0;
        height = 40.0;
        width = frame.size.width - 2 * xPos;
        UIView *complaintSubTypeView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor]];//white
        complaintSubTypeView.layer.cornerRadius = 3;
        complaintSubTypeView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
        complaintSubTypeView.layer.borderWidth = 1.0;
        complaintSubTypeView.layer.masksToBounds = YES;
        [sectionView addSubview:complaintSubTypeView];
        
        
        xPos = 5.0;
        yPos = 5.0;
        width = (complaintSubTypeView.frame.size.width - 2 * xPos) - 30.0;
        height = 30.0;
        UITextField *complaintSubTextField = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        complaintSubTextField.tag = kCompliantSubTextFieldTag;
        //complaintTextField.text = [[self complaintRegarding] objectAtIndex:0];
        //[self.grievanceDetail setValue:[[self complaintRegarding] objectAtIndex:0] forKey:kComplaintRegarding];
        complaintSubTextField.delegate = self;
        NSAttributedString *compliantSubtypePlaceholder;
        compliantSubtypePlaceholder = [[NSAttributedString alloc]initWithString:@"Complaint SubType" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:12.0]}];
        complaintSubTextField.attributedPlaceholder = compliantSubtypePlaceholder;
        complaintSubTextField.enabled = NO;
        complaintSubTextField.textColor = [UIColor blackColor];
        //        complaintTextField.backgroundColor = [UIColor greenColor];
        complaintSubTextField.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
        [complaintSubTypeView addSubview:complaintSubTextField];
        
        xPos = complaintSubTextField.frame.origin.x + complaintSubTextField.frame.size.width + 5.0;
        width = 25.0;
        height = 25.0;
        yPos = (complaintSubTypeView.frame.size.height - height) / 2.0;
        //dropdown imageview
        UIImageView *complaintSubtypeDropdown = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        complaintSubtypeDropdown.image = [UIImage imageNamed:@"icon_dropdown.png"];
        //        complaintDropdown.backgroundColor = [UIColor blackColor];
        [complaintSubTypeView addSubview:complaintSubtypeDropdown];
        
        
        UIButton *complaintSubTypeBtn = [[UIButton alloc]initWithFrame:complaintTypeView.frame];
        [complaintSubTypeBtn addTarget:self action:@selector(complaintSubTypeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [complaintSubTypeView addSubview:complaintSubTypeBtn];
        
        //Claim Number
        xPos = 3.0;
        yPos = complaintSubTypeView.frame.origin.y +complaintSubTypeView.frame.size.height + 20.0;
        height = 25.0;
        width = frame.size.width - 2 * xPos;
        UILabel *claimNoLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Claim Number" fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [sectionView addSubview:claimNoLbl];
        
        xPos = 3.0;
        yPos = claimNoLbl.frame.origin.y +claimNoLbl.frame.size.height + 5.0;
        height = 40.0;
        width = frame.size.width - 2 * xPos;
        UIView *policyNoView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor]];//white
        policyNoView.layer.cornerRadius = 3;
        policyNoView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
        policyNoView.layer.borderWidth = 1.0;
        policyNoView.layer.masksToBounds = YES;
        [sectionView addSubview:policyNoView];
        
        xPos = 5.0;
        yPos = 5.0;
        width = (policyNoView.frame.size.width - 2 * xPos) - 30.0;
        height = 30.0;
        UITextField *policyNoTextField = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        policyNoTextField.tag = 33000;
        policyNoTextField.delegate = self;
        NSAttributedString *policyPlaceholder;
        policyPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Claim Number" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0]}];
        policyNoTextField.attributedPlaceholder = policyPlaceholder;
//        [policyNoTextField setKeyboardType:[[KeyboardHelper sharedKeyboardHelper]keyValues:defaulyKeyboard]];
        policyNoTextField.keyboardType = UIKeyboardTypeDefault;
        policyNoTextField.textColor = [UIColor blackColor];
//        claimNoTextField.backgroundColor = [UIColor greenColor];
        policyNoTextField.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
        //OLD-Code
//        policyNoTextField.text = [[UserManager sharedUserManager]policyNumber];
//         policyNoTextField.enabled = NO;

        //NEW-Code
        policyNoTextField.text = @"";
        policyNoTextField.enabled = YES;
        [policyNoView addSubview:policyNoTextField];
        
        //         [self.grievanceDetail setValue:[[UserManager sharedUserManager]policyNumber] forKey:kComplaintPolicyNumber];
//        [self.grievanceDetail setValue:policyNoTextField.text forKey:kComplaintClaimNumber];

        
        xPos = policyNoTextField.frame.origin.x + policyNoTextField.frame.size.width + 5.0;
        width = 25.0;
        height = 25.0;
        yPos = (policyNoView.frame.size.height - height) / 2.0;
        //claim dropdown imageview
        UIImageView *policyDropdown = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        policyDropdown.image = [UIImage imageNamed:@"icon_dropdown.png"];
//        claimDropdown.backgroundColor = [UIColor blueColor];
        //[policyNoView addSubview:policyDropdown];
        
        
        xPos = policyNoView.frame.origin.x;
        yPos = 0.0;
        width = policyNoView.frame.size.width;
        height = policyNoView.frame.size.height;
        UIButton *policyNoBtn = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [policyNoBtn addTarget:self action:@selector(policyNoBtnBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        //[policyNoView addSubview:policyNoBtn];
        
        //Complaints Remark View
        xPos = 3.0;
        yPos = policyNoView.frame.origin.y + policyNoView.frame.size.height + 20.0;
        width = frame.size.width - 2 * xPos;
        height = 25.0;
        
        UIView *complaintsRemarkView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor]];//white
//        complaintsRemarkView.layer.cornerRadius = 3;
        complaintsRemarkView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
//        complaintsRemarkView.layer.borderWidth = 1.0;
//        complaintsRemarkView.layer.masksToBounds = YES;
        [sectionView addSubview:complaintsRemarkView];
        
        //Complaints Remark Label
        xPos = 0.0;
        yPos = 0.0;
        height = 25.0;
        width = complaintsRemarkView.frame.size.width;
        
        UILabel *complaintsRemarkLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"*Complaints Remark" fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
         initWithAttributedString: complaintsRemarkLbl.attributedText];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor redColor]
                     range:NSMakeRange(0, 1)];
        [complaintsRemarkLbl setAttributedText: text];
        [complaintsRemarkView addSubview:complaintsRemarkLbl];
        
        
        xPos = 3.0;
        yPos = complaintsRemarkView.frame.origin.y + complaintsRemarkView.frame.size.height + 5.0;
        width = frame.size.width - 2 * xPos;
        height = 100.0;
        UITextView *textView = [[UITextView alloc]init];
        [textView setFrame:CGRectMake(xPos, yPos, width, height)];
        textView.delegate = self;
        textView.tag = complaintRemark;
        textView.layer.cornerRadius = 3.0f;
        textView.layer.masksToBounds = YES;
        textView.textColor = [UIColor grayColor];
        textView.text = kComplaintRemarkPlaceholder;
        textView.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
        textView.backgroundColor = [UIColor whiteColor];
        textView.layer.borderWidth = 1.0f;
        textView.layer.borderColor = [[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0] CGColor];
        [sectionView addSubview:textView];
        //Upload
        xPos = 3.0;
        yPos = textView.frame.origin.y + textView.frame.size.height + 20.0;
        height = 40.0;
        width = frame.size.width - 2 * xPos;
        UIView *uploadView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor]];
        uploadView.layer.cornerRadius = 3;
        uploadView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
        uploadView.layer.borderWidth = 1.0;
        uploadView.layer.masksToBounds = YES;
//        [sectionView addSubview:uploadView]; //Un-Commented
        /*
        //Add Button on uploadView
        UIButton *addAttachment = [[UIButton alloc]initWithFrame:uploadView.frame];
        [addAttachment addTarget:self action:@selector(uploadAttachments:) forControlEvents:UIControlEventTouchUpInside];
        addAttachment.backgroundColor = [UIColor redColor];
        [uploadView addSubview:addAttachment];
        */
        xPos = 5.0;
        yPos = 5.0;
        width = (uploadView.frame.size.width / 1.5) - xPos;
        height = 30.0;
        UILabel *uploadLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        uploadLabel.text = @"Upload Attachments";
        uploadLabel.tag = uploadAttachment;
        uploadLabel.textColor = [UIColor grayColor];
        uploadLabel.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
        [uploadView addSubview:uploadLabel];
        xPos = width + 10.0;
        yPos = 0.0;
        width = 30.0;
        height = 40.0;
        UIView *attachView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor colorWithRed:31/255.0 green:133/255.0 blue:199/255.0 alpha:1.0]];
        [uploadView addSubview:attachView];
        xPos = 5.0;
        yPos = 10.0;
        width = 20.0;
        height = 20.0;
        UIImageView *uploadImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        uploadImage.image = [UIImage imageNamed:@"icon_attach.png"];
        [attachView addSubview:uploadImage];
        xPos = attachView.frame.origin.x + attachView.frame.size.width;
        yPos = 0.0;
        width = uploadView.frame.size.width - xPos;
        height = 40.0;
        UILabel *attachLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        attachLabel.text = @"Attach File";
        attachLabel.backgroundColor = [UIColor colorWithRed:31/255.0 green:133/255.0 blue:199/255.0 alpha:1.0];
        attachLabel.textColor = [UIColor whiteColor];
        attachLabel.textAlignment = NSTextAlignmentCenter;
        attachLabel.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
        [uploadView addSubview:attachLabel];
        
        return sectionHeader;
    }
    
    else if (section == 1) {
        
        xPos = 0.0;
        yPos = 0.0;
        width =  frame.size.width;
        height = 50.0;
        UIView *sectionHeader = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
        
        xPos = 15.0;
        yPos = 0.0;
        width =  frame.size.width/2;
        height = 50.0;
        UILabel *uploadAttachment = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        uploadAttachment.text = @"Upload Attachments:";
        uploadAttachment.textColor = [UIColor whiteColor];
        uploadAttachment.font = [UIFont systemFontOfSize:15.0];
        [sectionHeader addSubview:uploadAttachment];
        
        xPos = uploadAttachment.frame.size.width + 20.0;
        yPos = 10.0;
        width =  (frame.size.width/2) - 30.0;
        height = 30.0;
        UIButton *addAttachment = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [addAttachment setTitle:@"Attach File" forState:UIControlStateNormal];
        addAttachment.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
        [addAttachment addTarget:self action:@selector(uploadAttachments:) forControlEvents:UIControlEventTouchUpInside];
        addAttachment.layer.cornerRadius = 5.0;
        addAttachment.layer.borderColor = [UIColor colorWithRed:214/255.0 green:213/255.0 blue:215/255.0 alpha:1.0].CGColor;
        addAttachment.layer.borderWidth = 1.0;
        addAttachment.layer.masksToBounds = YES;
        addAttachment.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
        [addAttachment setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        [sectionHeader addSubview:addAttachment];
        
        return sectionHeader;

    }

    else
    {
        xPos = 0.0;
        yPos = 10.0;
        width =  frame.size.width;
        height = 50.0;
        UIView *sectionHeader = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
        xPos = sectionHeader.frame.size.width / 3.25;
        yPos = 0.0;
        width = sectionHeader.frame.size.width / 2.5;
        height = 40.0;
        UIButton *raiseGrievanceButton = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [raiseGrievanceButton setTitle:@"Raise Complaint" forState:UIControlStateNormal];
        raiseGrievanceButton.layer.cornerRadius = 4.0;
        raiseGrievanceButton.layer.borderColor = [UIColor colorWithRed:214/255.0 green:213/255.0 blue:215/255.0 alpha:1.0].CGColor;
        raiseGrievanceButton.layer.borderWidth = 1.0;
        raiseGrievanceButton.layer.masksToBounds = YES;
        raiseGrievanceButton.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
        [raiseGrievanceButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        [raiseGrievanceButton addTarget:self action:@selector(raiseGrievanceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [sectionHeader addSubview:raiseGrievanceButton];
        return sectionHeader;
    }
    
}



- (UIView *)grievanceGuideHeaderView
{
    CGRect frame = [self bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat width = frame.size.width;
    CGFloat height = 10.0;
    UIView *sectionHeader = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
    return sectionHeader;
    
}

- (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:backgroundColor];
    return view;
}
- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
}

- (NSArray *)complaintRegarding
{
    return [[NSArray alloc]initWithObjects:@"Claim still not settled",@"Claim submitted but not intimated/lost",@"Deductions not justified",@"Deductions not justified" ,@"Delay in Claims Processing",@"Delay in Enhancement",@"Documents submitted but details not updated",@"Error in settlement",@"Errors in Capturing the member details",@"Grievance",@"Guide book not received",@"Health Card Not received",@"Health Card Photo Related",@"Hospital claims Payment not received",@"Hospital complaints about  HITPA Employees/Members",@"Incorrect Address/ facility details on Website",@"Lost card not re-issued",@"Member complaints about  HITPA Employees",@"Member does not agree with query reason",@"Member does not agree with Repudiation reason",@"Member not added endorsement received",@"Member not receiving SMS/Email Alerts ",@"Member not receiving SMS/Email Alerts ",@"Members not  enrolled as per policy",@"Payment not received",@"Poor Facility/ Poor Service",@"Settlement letter not received",@"Unable to download E card from Website",@"Website Down",nil];
    
}

#pragma mark - Picker view delegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  //  [[self.picker.subviews objectAtIndex:1] setHidden:TRUE];
   // [[self.picker.subviews objectAtIndex:2] setHidden:TRUE];
    self.strings = [NSMutableArray arrayWithCapacity:3];
    [self.strings addObject:@"Raise Complaint"];
    [self.strings addObject:@"Complaint Track"];
    [self.strings addObject:@"Complaint Guide"];
    UILabel * pickerData = [[UILabel alloc]init];
    pickerData.textColor = [UIColor blackColor];
    pickerData.textAlignment = NSTextAlignmentCenter;
    pickerData.frame = CGRectZero;
    pickerData.text =[ NSString stringWithFormat:@"%@", [self.strings objectAtIndex:(row%3)]];
    CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI/2);
    rotate = CGAffineTransformScale(rotate, 1.0, 1.0);
    [pickerData setTransform:rotate];
    pickerData.frame = CGRectMake(0.0, 0.0, [self bounds].size.width/2, [self bounds].size.width/2);
    return pickerData;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return ([[UIScreen mainScreen]bounds].size.width)/2.4;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *retriveData = [self.strings objectAtIndex:(row%3)];
    
    if ([retriveData isEqualToString:@"Raise Complaint"])
    {
        [self raiseGrievance];
    }
    else if ([retriveData isEqualToString:@"Complaint Track"])
    {
        [self grievanceTrack];
    }
    else if ([retriveData isEqualToString:@"Complaint Guide"])
    {
        [self grievanceGuide];
    }
    [self belowView:retriveData];
    [self pickerViewLoaded:nil];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 16384;
    
}


-(void)pickerViewLoaded: (id)blah {
    
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%3;
    [self.picker selectRow:[self.picker selectedRowInComponent:0]%3+base10 inComponent:0 animated:false];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

#pragma mark - Protocol

- (void)complaintType:(NSString *)complaintType{
    [self.dropDownViews removeFromSuperview];
    self.nIDropDown = nil;
    [(UITextField *)[self.view viewWithTag:kCompliantTextFieldTag] setText:complaintType];
    [self.grievanceDetail setValue:complaintType forKey:kComplaintType];
    UITextField *complaintSubTypeTxtField = (UITextField *)[self.view viewWithTag:kCompliantSubTextFieldTag];
    if([complaintSubTypeTxtField text].length > 0) {
        complaintSubTypeTxtField.text = @"";
        NSAttributedString *compliantSubtypePlaceholder;
        compliantSubtypePlaceholder = [[NSAttributedString alloc]initWithString:@"Complaint SubType" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration] hitpaFontWithSize:14.0]}];
        complaintSubTypeTxtField.attributedPlaceholder = compliantSubtypePlaceholder;
    }
    
}

- (void)complaintSubType:(NSString *)complaintSubType{
    [self.dropDownViews removeFromSuperview];
    self.nIDropDown = nil;
    [(UITextField *)[self.view viewWithTag:kCompliantSubTextFieldTag] setText:complaintSubType];
    [self.grievanceDetail setValue:complaintSubType forKey:kComplaintSubType];
    
}

- (void)getPolicyNumber:(NSString *)policyNumber
{
    [self.dropDownViews removeFromSuperview];
    self.nIDropDown = nil;
    [(UITextField *)[self.view viewWithTag:33000] setText:policyNumber];
    [self.grievanceDetail setValue:policyNumber forKey:kComplaintClaimNumber];
    
}

- (void)getGrievanceTrackDetails {
    [self grievanceTrackHandler];

}


#pragma mark - Button Delegate

- (IBAction)policyNoBtnBtnTapped:(id)sender
{
    if ([[[CoreData shareData] getPolicyDetail] count] > 0) {
        NSDictionary *response = [[CoreData shareData] getPolicyDetail];
        NSMutableArray *claimHistoryDetail = [[NSMutableArray alloc]init];
        self.policyDetail = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *policyDetailDic = [[NSMutableDictionary alloc]init];
        NSMutableArray *memberPolicyNumbers = [[NSMutableArray alloc]init];
        
        //NSArray *array = [response valueForKey:@"MemberDetails"];
        if ([[response valueForKey:@"PolicyNumber"] length] > 0)
        {
//            NSDictionary *dict = [array objectAtIndex:0];
            [memberPolicyNumbers addObject:[response valueForKey:@"PolicyNumber"]];
        }
//        for (NSDictionary *dict in [response valueForKey:@"MemberDetails"]) {
//            if ([[dict valueForKey:@"MemberRelationship"] isEqualToString:@"Self"])
//                [memberPolicyNumbers addObject:[dict valueForKey:@"MemberPolicyNumber"]];
//        }
        [policyDetailDic setValue:memberPolicyNumbers forKey:@"policynumber"];
        [policyDetailDic setValue:[response valueForKey:@"MemberID"] forKey:@"memberiD"];
        [policyDetailDic setValue:[response valueForKey:@"PolicyType"] forKey:kCallerType];
        for (NSDictionary *dictionary in [response valueForKey:@"PolicyDetails"]) {
            MyPolicyModel *home = [MyPolicyModel getPolicyHistoryDetailsByResponse:dictionary];
            [claimHistoryDetail addObject:home];
        }
        [self.policyDetail setValue:policyDetailDic forKey:@"policydetail"];
        [self.policyDetail setValue:claimHistoryDetail forKey:@"claimhistory"];
        [self policyNumber];
    }else{
        [self showHUDWithMessage:@""];
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
        [param setValue:[[UserManager sharedUserManager] userName] forKey:@"UHID"];
        [[HITPAAPI shareAPI] policyDetailsWithParams:param completionHandler:^(NSDictionary *response, NSError *error){
            [self didReceivePolicyResponse:response error:error];
        }];
    }
    
}



- (IBAction)complaintTypeBtnTapped:(id)sender
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
//    if(self.complaintTableView == nil) {
//        self.expandCollapse = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil];
//        self.complaintTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0,130.0,frame.size.width, 180.0) style:UITableViewStylePlain];
//        self.complaintTableView.dataSource = self;
//        self.complaintTableView.delegate = self;
//        [self.view addSubview:self.complaintTableView];
//    }else
//    {
//        [self.complaintTableView removeFromSuperview];
//        self.complaintTableView = nil;
//        
//    }
    
    
    
    if (self.nIDropDown == nil)
    {

        self.dropDownViews = [[UIView alloc]initWithFrame:CGRectMake(-8.0,118.0,frame.size.width, 200.0)];
        //[self.dropDownViews setBackgroundColor:[UIColor greenColor]];
        self.dropDownViews.tag = 40000;
        UIButton *locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.dropDownViews.frame.size.width, self.dropDownViews.frame.size.height)];
        CGRect btnFrame=locationBtn.frame;
        btnFrame.origin.y=0.0;
        btnFrame.origin.x = 0.0;
        btnFrame.size.height=0.0;
        locationBtn.frame=btnFrame;
        locationBtn.backgroundColor=[UIColor clearColor];
        
        CGFloat f = ([UIScreen mainScreen].bounds.size.height > 480)?186.0:121.0;
        self.nIDropDown = [[NIDropDown alloc]showDropDown:locationBtn height:&f arr:self.complaintsArray imgArr:nil direction:@"down" isIndex:30000];
        self.nIDropDown.delegate = self;
        [self.dropDownViews addSubview:self.nIDropDown];
        [self.view addSubview:self.dropDownViews];
        
    }else
    {
        [self.dropDownViews removeFromSuperview];
        self.nIDropDown = nil;
        
    }
}

- (IBAction)complaintSubTypeBtnTapped:(id)sender
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    if (self.nIDropDown == nil)
    {
        
        self.dropDownViews = [[UIView alloc]initWithFrame:CGRectMake(-8.0,180.0,frame.size.width, 200.0)];
        //[self.dropDownViews setBackgroundColor:[UIColor greenColor]];
        self.dropDownViews.tag = 40000;
        UIButton *locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.dropDownViews.frame.size.width, self.dropDownViews.frame.size.height)];
        CGRect btnFrame=locationBtn.frame;
        btnFrame.origin.y=0.0;
        btnFrame.origin.x = 0.0;
        btnFrame.size.height=0.0;
        locationBtn.frame=btnFrame;
        locationBtn.backgroundColor=[UIColor clearColor];
        
        CGFloat f = ([UIScreen mainScreen].bounds.size.height > 480)?186.0:121.0;
        self.nIDropDown = [[NIDropDown alloc]showDropDown:locationBtn height:&f arr:[self getComplaintSubTypeForComplaintType:[self.grievanceDetail valueForKey:kComplaintType]] imgArr:nil direction:@"down" isIndex:60000];
        self.nIDropDown.delegate = self;
        [self.dropDownViews addSubview:self.nIDropDown];
        [self.view addSubview:self.dropDownViews];
        
    }else
    {
        [self.dropDownViews removeFromSuperview];
        self.nIDropDown = nil;
        
    }
}


- (IBAction)uploadAttachments:(UIButton *)sender
{
    NSLog(@"uploadAttachments");
    [self.view endEditing:YES];
    self.isAttach = YES;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        sender.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        sender.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            sender.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.navigationController.navigationBarHidden = YES;
            CGRect frame = [[UIScreen mainScreen] bounds];
            CGFloat xPos = 0.0;
            CGFloat yPos = 0.0;
            CGFloat height = frame.size.height;
            CGFloat width = frame.size.width;
            UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
            viewMain.backgroundColor = [UIColor blackColor];
            viewMain.tag = kGrievanceUploadScreenTag;
            viewMain.alpha = 0.6;
            [self.view addSubview:viewMain];
            
            width = frame.size.width - 40.0;
            height = 225.0;
            xPos = (frame.size.width - width)/2;
            yPos = (frame.size.height - height)/2;
            UIView *popUp = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
            popUp.backgroundColor = [UIColor whiteColor];
            popUp.tag = kGrievanceUploadPopUpTag;
            popUp.layer.cornerRadius = 5.0;
            [self.view addSubview:popUp];
            
            width = popUp.frame.size.width;
            height = 40.0;
            xPos = 0.0;
            yPos = 0.0;
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            title.text = @"Grievance";
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor colorWithRed:(96.0/255.0) green:(193.0/255.0) blue:(244.0/255.0) alpha:1.0f];
            title.font = [UIFont boldSystemFontOfSize:20.0];
            [popUp addSubview:title];
            
            height = 2.0;
            yPos = 40.0;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            line.backgroundColor = [UIColor colorWithRed:(96.0/255.0) green:(193.0/255.0) blue:(244.0/255.0) alpha:1.0f];
            [popUp addSubview:line];
            
            height = 40.0;
            yPos = 42.0;
            UILabel *option = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            option.text = @"How would you like to upload ?";
            option.textAlignment = NSTextAlignmentCenter;
            option.textColor = [UIColor blackColor];
            option.font = [UIFont systemFontOfSize:16.0];
            [popUp addSubview:option];
            
            height = 100.0;
            yPos = 82.0;
            xPos = 0.0;
            width = popUp.frame.size.width/3;
            UIView *capture = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//            capture.backgroundColor = [UIColor blueColor]; //Need to Remove
            [popUp addSubview:capture];
            
            height = 100.0;
            yPos = 82.0;
            xPos = popUp.frame.size.width/3;
            width = popUp.frame.size.width/3;
            UIView *gallery = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//            gallery.backgroundColor = [UIColor redColor]; //Need to Remove
            [popUp addSubview:gallery];
            
            //File Manager
            height = 100.0;
            yPos = 82.0;
            xPos = (popUp.frame.size.width/3) + (popUp.frame.size.width/3);
            width = popUp.frame.size.width/3;
            UIView *fileManager = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//            fileManager.backgroundColor = [UIColor greenColor]; //Need to Remove
            [popUp addSubview:fileManager];
            
            width = 120.0;
            height = 35.0;
            yPos = 185.0;
            xPos = (popUp.frame.size.width - width)/2;
            UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:18.0];
            cancel.backgroundColor = [UIColor colorWithRed:(96.0/255.0) green:(193.0/255.0) blue:(244.0/255.0) alpha:1.0f];
            [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            cancel.layer.cornerRadius = 5.0;
            [popUp addSubview:cancel];
            
            height = 30.0;
            yPos = 70.0;
            xPos = 0.0;
            width = capture.frame.size.width;
            UILabel *captureTitle = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            captureTitle.text = @"Capture";
            captureTitle.textAlignment = NSTextAlignmentCenter;
            captureTitle.textColor = [UIColor blackColor];
            captureTitle.font = [UIFont systemFontOfSize:16.0];
            [capture addSubview:captureTitle];
            
            UILabel *galleryTitle = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            galleryTitle.text = @"Gallery";
            galleryTitle.textAlignment = NSTextAlignmentCenter;
            galleryTitle.textColor = [UIColor blackColor];
            galleryTitle.font = [UIFont systemFontOfSize:16.0];
            [gallery addSubview:galleryTitle];
            
            UILabel *fileManagerTitle = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            fileManagerTitle.text = @"File Manager";
            fileManagerTitle.textAlignment = NSTextAlignmentCenter;
            fileManagerTitle.textColor = [UIColor blackColor];
            fileManagerTitle.font = [UIFont systemFontOfSize:16.0];
            [fileManager addSubview:fileManagerTitle];
            
            height = 60.0;
            yPos = 5.0;
            width = 60.0;
            xPos = (capture.frame.size.width - width)/2;
            UIImageView *captureImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            captureImage.image = [UIImage imageNamed:@"icon_camera.png"];
            [capture addSubview:captureImage];
            
            UIImageView *chooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            chooseImage.image = [UIImage imageNamed:@"icon_gallery.png"];
            [gallery addSubview:chooseImage];
            
            UIImageView *fileManagerImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            fileManagerImage.image = [UIImage imageNamed:@"ic_folder.png"];
            [fileManager addSubview:fileManagerImage];
            
            UITapGestureRecognizer *captureTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attachCapturedImage:)];
            [capture addGestureRecognizer:captureTapped];
            
            UITapGestureRecognizer *galleryTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attachGalleryImage:)];
            [gallery addGestureRecognizer:galleryTapped];
            
            UITapGestureRecognizer *fileManagerTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attachFileManagerPdf:)];
            [fileManager addGestureRecognizer:fileManagerTapped];
            
        }];
        
    }];
    
    
}

- (void)attachCapturedImage:(UITapGestureRecognizer *)gesture
{
    self.navigationController.navigationBarHidden = NO;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        alertView(@"Camera", @"Device has no Camera.", nil, @"Ok", nil, 0);
    } else {
        //UIImagePickerControllerSourceTypeCamera is Available
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:Nil];
        
        [(UIView *) [self.view viewWithTag:kGrievanceUploadScreenTag] removeFromSuperview];
        [(UIView *) [self.view viewWithTag:kGrievanceUploadPopUpTag] removeFromSuperview];
    }
}

- (void)attachGalleryImage:(UITapGestureRecognizer *)gesture
{
    self.navigationController.navigationBarHidden = NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:Nil];
    
    [(UIView *) [self.view viewWithTag:kGrievanceUploadScreenTag] removeFromSuperview];
    [(UIView *) [self.view viewWithTag:kGrievanceUploadPopUpTag] removeFromSuperview];
    
}

- (void)attachFileManagerPdf:(UITapGestureRecognizer *)gesture
{
    NSLog(@"attachFileManagerPdf");
    self.navigationController.navigationBarHidden = NO;
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"com.apple.iwork.pages.pages", @"com.apple.iwork.numbers.numbers", @"com.apple.iwork.keynote.key", @"public.image", @"com.apple.application", @"public.item", @"public.data", @"public.content", @"public.audiovisual-content", @"public.movie", @"public.audiovisual-content", @"public.video", @"public.audio", @"public.text", @"public.data", @"public.composite-content", @"public.text"] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
    
    [(UIView *) [self.view viewWithTag:kGrievanceUploadScreenTag] removeFromSuperview];
    [(UIView *) [self.view viewWithTag:kGrievanceUploadPopUpTag] removeFromSuperview];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        
        NSLog(@"lastPathComponent:%@", [url lastPathComponent]);
        NSLog(@"pathExtension:%@", [url pathExtension]);
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        if (imageData.length > 0) {
            //To Check Duplicate Array Name and Maintain unique names in Array
            NSString *imageName = [NSString stringWithFormat:@"%@", url.lastPathComponent];
            BOOL isTheObjectThere = [self.imagesArray containsObject:imageName];
            if (isTheObjectThere) {
                NSLog(@"isTheObjectThere1");
                for (long int i = 1; i <= [self.imagesArray count]+1; i++) {
                    imageName = [NSString stringWithFormat:@"%@%lu.%@", imageName, i, url.pathExtension];
                    BOOL isTheObjectThere = [self.imagesArray containsObject:imageName];
                    if (isTheObjectThere) {
                        NSLog(@"isTheObjectThere2");
                    } else {
                        i = [self.imagesArray count]+1;
                    }
                }
            }
            
            if ([[DocumentDirectory shareDocumentDirectory] writeImageOrPdfIntoDocumentDirectory:imageData imageName:imageName]) {
                [self.imagesArray addObject:imageName];
                NSLog(@"UIDocumentPickerViewController:%@", self.imagesArray);
                [controller dismissViewControllerAnimated:YES completion:nil];
                
//                [self.tableView reloadData];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

#pragma mark-imagePickerControler
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    
    if (imageData.length > 0) {
        //To Check Duplicate Array Name and Maintain unique names in Array
        NSString *imageName = [NSString stringWithFormat:@"Image%lu.jpg", [self.imagesArray count]+1];
        BOOL isTheObjectThere = [self.imagesArray containsObject:imageName];
        if (isTheObjectThere) {
             NSLog(@"isTheObjectThere1");
            for (long int i = 1; i <= [self.imagesArray count]+1; i++) {
                imageName = [NSString stringWithFormat:@"Image%lu.jpg", i];
                BOOL isTheObjectThere = [self.imagesArray containsObject:imageName];
                if (isTheObjectThere) {
                    NSLog(@"isTheObjectThere2");
                } else {
                    i = [self.imagesArray count]+1;
                }
            }
        }
        
        if ([[DocumentDirectory shareDocumentDirectory] writeImageOrPdfIntoDocumentDirectory:imageData imageName:imageName]) {
            
//            NSMutableDictionary *dic_Images=[[NSMutableDictionary alloc]init];
//            [dic_Images setValue:selectedImage forKey:[NSString stringWithFormat:@"Image%lu", imageName]];
            
//            [self.imagesArray mutableCopy];
//            [self.imagesArray addObject:dic_Images];
            [self.imagesArray addObject:imageName];
             NSLog(@"imagePickerController:%@", self.imagesArray);
            [picker dismissViewControllerAnimated:YES completion:nil];
            
//            [self.tableView reloadData];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (IBAction)cancelAction:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    self.isAttach = NO;
    [(UIView *) [self.view viewWithTag:kGrievanceUploadScreenTag] removeFromSuperview];
    [(UIView *) [self.view viewWithTag:kGrievanceUploadPopUpTag] removeFromSuperview];
    
}

- (UIView *)createViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    return view;
    
}

- (IBAction)raiseGrievanceButtonTapped:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        sender.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        
        
        sender.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            
            [[DocumentDirectory shareDocumentDirectory] uploadMediaFolderToServer];
            
            NSArray *error = nil;
            
            NSLog(@"P1:%@", [self.policyDetail valueForKey:@"policydetail"]);
            NSLog(@"P2:%@", [[self.policyDetail valueForKey:@"policydetail"] valueForKey:kCallerType]);
            NSString *callerType = [[self.policyDetail valueForKey:@"policydetail"] valueForKey:kCallerType];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
            [params setValue:[self.grievanceDetail valueForKey:kComplaintClaimNumber] forKey:kComplaintClaimNumber];
            [params setValue:@"Complaint" forKey:kComplaintRequestType];
            [params setValue:[self.grievanceDetail valueForKey:kComplaintRemark] forKey:kComplaintRemark];
            [params setValue:[self.grievanceDetail valueForKey:kComplaintType] forKey:kComplaintType];
            [params setValue:[self.grievanceDetail valueForKey:kComplaintSubType] forKey:kComplaintSubType];
//            [params setValue:[[self.policyDetail valueForKey:@"policydetail"] valueForKey:kCallerType] forKey:kCallerType];
            [params setValue:[[UserManager sharedUserManager] userName] forKey:kComplaintAssignFromUser];
            [params setValue:@"Open" forKey:kComplaintRequestStatus];
//            [params setValue:[[UserManager sharedUserManager]userName] forKey:kUploadDocument_ReferenceNo];
            [params setValue:DocumentDirectory.shareDocumentDirectory.mediaFolder forKey:kUploadDocument_ReferenceNo];
            
            BOOL isVlaidate =  [[Helper shareHelper] validateGrievanceWithWithError:&error parmas:params];
        
            if (!isVlaidate)
            {
                NSString *errorMessage = [[Helper shareHelper] getErrorStringFromErrorDescription:error];
                alertView([[Configuration shareConfiguration] appName], errorMessage, self, @"Ok", nil, 0);
                return;
                
            }
            
            [self showHUDWithMessage:@""];

            [[HITPAAPI shareAPI] postGrievanceDetailsWithParams:params callerType:callerType completionHandler:^(NSDictionary *response , NSError *error){
                
                [self didReceiveGrieveanceResponse:response error:error];
                
            }];
            
        }];
        
        
    }];
    
    
    
}

#pragma Upload Documents or Images into Server using Service Call [Multi Part]
- (void)uploadingDataWithIndex
{
    
    NSMutableData *body = [[NSMutableData alloc]init];
    
    for(int i = 0; i < [self.imagesArray count]; i++)
    {
        UIImage *attachmentImage = [self scaleImage:[[self.imagesArray objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"Image_%d",i+1]] toSize:CGSizeMake(1280, 800)];
        NSData *frontImageData = UIImageJPEGRepresentation(attachmentImage, 1.0);
        [body appendData:[self appendImageBodyDataWithKey:[NSString stringWithFormat:@"Image_%d",i+1] data:frontImageData]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [self requestManger];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Inward/SaveDMSFiles",[[Configuration shareConfiguration] baseURL]]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        
        if(data.length > 0)
        {
            NSString *status=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Sucess%@",status);
            
        }else
        {
            
        }
        
    }];
    
    
}

- (NSMutableURLRequest *)requestManger
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:180];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    return request;
    
}

- (NSMutableData *)appendImageBodyDataWithKey:(NSString *)key data:(NSData *)data
{
    
    NSMutableData *bodyData = [NSMutableData data];
    [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:data];
    [bodyData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return bodyData;
    
}

#pragma mark-scaleImage
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)policyNumber
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    NSMutableArray *policyNumber = [[self.policyDetail valueForKey:@"policydetail"] valueForKey:@"policynumber"];
    
    if (self.nIDropDown == nil)
    {
        
        self.dropDownViews = [[UIView alloc]initWithFrame:CGRectMake(-8.0,242.0,frame.size.width, 200.0)];
        //[self.dropDownViews setBackgroundColor:[UIColor greenColor]];
        self.dropDownViews.tag = 40000;
        UIButton *locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.dropDownViews.frame.size.width, self.dropDownViews.frame.size.height)];
        CGRect btnFrame=locationBtn.frame;
        btnFrame.origin.y=0.0;
        btnFrame.origin.x = 0.0;
        btnFrame.size.height=0.0;
        locationBtn.frame=btnFrame;
        locationBtn.backgroundColor=[UIColor clearColor];
        
        CGFloat f = ([UIScreen mainScreen].bounds.size.height > 480)?186.0:121.0;
        self.nIDropDown = [[NIDropDown alloc]showDropDown:locationBtn height:&f arr:policyNumber imgArr:nil direction:@"down" isIndex:40000];
        self.nIDropDown.delegate = self;
        [self.dropDownViews addSubview:self.nIDropDown];
        [self.view addSubview:self.dropDownViews];
        
    }else
    {
        [self.dropDownViews removeFromSuperview];
        self.nIDropDown = nil;
    }
    
}


#pragma mark - Handler

- (void)grievanceTrackHandler
{
    [self showHUDWithMessage:@""];

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:[[UserManager sharedUserManager] userName] forKey:@"userid"];
    [[HITPAAPI shareAPI] getGrievanceDetailWithParam:param  completionHandler:^(NSDictionary *response, NSError *error){
        [self didReceiveGrievanceWithResponse:response error:error];
    }];
    
}

- (void)didReceiveGrievanceWithResponse:(NSDictionary *)response error:(NSError *)error
{
    [self hideHUD];
    [(UILabel *)[self.view viewWithTag:kGrievanceStausLabelTag] setHidden:YES];

    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in response) {
        
        Greveance *grievance = [Greveance grivanceWithResponse:dic];
        [array addObject:grievance];
    }
    
    if ([array count]  > 0)
    {
        [self.grievanceDetail setObject:array forKey:@"grievancetrack"];
        
    }
    else
    {
        [(UILabel *)[self.view viewWithTag:kGrievanceStausLabelTag] setHidden:NO];

    }
    
    [self reloadTableView];
    
    
}


- (void)didReceivePolicyResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    self.policyDetail = [[NSMutableDictionary alloc]init];
    NSMutableArray *policyDetail = [[NSMutableArray alloc]init];
    NSMutableDictionary *policyDetailDic = [[NSMutableDictionary alloc]init];
    NSMutableArray *memberPolicyNumbers = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in [response valueForKey:@"MemberDetails"]) {
        [memberPolicyNumbers addObject:[dict valueForKey:@"MemberPolicyNumber"]];
    }
    [policyDetailDic setValue:memberPolicyNumbers forKey:@"policynumber"];
    [policyDetailDic setValue:[response valueForKey:@"MemberID"] forKey:@"memberiD"];
    [policyDetail addObject:policyDetailDic];
    NSMutableArray *claimHistoryDetail = [[NSMutableArray alloc]init];
    for (NSDictionary *dictionary in [response valueForKey:@"PolicyDetails"]) {
        MyPolicyModel *home = [MyPolicyModel getPolicyHistoryDetailsByResponse:dictionary];
        [claimHistoryDetail addObject:home];
    }
    [self.policyDetail setValue:policyDetail forKey:@"policydetail"];
    [self.policyDetail setValue:claimHistoryDetail forKey:@"claimhistory"];
//    [self policyNumber];
    
}


- (void)didReceiveGrieveanceResponse:(NSDictionary *)response error:(NSError *)error
{
    NSLog(@"response:%@", response);
    [self hideHUD];//
    if([response isKindOfClass:[NSDictionary class]]) {
        
        if ([[response valueForKey:@"number"] length] > 0) {
            NSString *responseId = [response valueForKey:@"number"];
            responseId = [responseId stringByReplacingOccurrencesOfString:@"/" withString:@""];
            alertView([[Configuration shareConfiguration] appName], [NSString stringWithFormat:@"Your Reference ID is %@",responseId], self, @"Ok", nil, kGrievanceTrackAlertTag);
            [self.grievanceDetail removeAllObjects];
            [self reloadTableView];
            
            if ([self.imagesArray count] == 0) {
                
            } else {
                //OLD Code
                //[self uploadingDataWithIndex];
                //New Code
                [self uploadImagesUsingFTP];
            }
        } else if ([[response valueForKey:@"Message"] length] > 0) {
             alertView([[Configuration shareConfiguration] appName], [NSString stringWithFormat:@"%@",[response valueForKey:@"Message"]], self, @"Ok", nil, kGrievanceTrackAlertTag);
        }
    } else {
        if(error != nil) {
            alertView([[Configuration shareConfiguration] appName], @"No internet connection. Connect to internet to proceed", nil, @"Ok", nil, 0);
            return;
        }
    }
    
}

- (void)uploadImagesUsingFTP {

//    [[DocumentDirectory shareDocumentDirectory] uploadMediaFolderToServer]; //Need to Remove
    
    BOOL compressStatus = [[DocumentDirectory shareDocumentDirectory] compressImagesWithUserName:false];
    if (compressStatus) {
        
        BOOL folderZipFile = [[DocumentDirectory shareDocumentDirectory] zipWithUserName:@"ftpuser_intimate"];
        if (folderZipFile) {
            NSLog(@"Zip File Created");
            NSString *zipFileName = [NSString stringWithFormat:@"%@.zip", @"ftpuser_intimate"];
            NSURL *zipPathUrl = [[[DocumentDirectory shareDocumentDirectory] directoryPath] URLByAppendingPathComponent:zipFileName];
            NSLog(@"zipPathUrl:%@", zipPathUrl);
            
            [self createDirectory:zipPathUrl.absoluteString completionHandler:^(BOOL status) {
                if (status) {
                    // get zip file path here
                    NSString *zipPath = [self returnZipPathWithUserName];
                    NSLog(@"zipPath%@", zipPath);
                    
                    if ([zipPath length] > 0) {
                        [self uploadMediaWithPath:zipPath];
                    }
                }
            }];
        } else {
            NSLog(@"Zip File Not Created");
        }
    }
}

- (void)createDirectory:(NSString *)path completionHandler:(DirCompletionHandler)dirCompletionHandler {
    CreateDirController *createDirController = [CreateDirController sharedCreateDirController];
//    NSString *ftpPath = [NSString stringWithFormat:@"%@%@",[[Configuration shareConfiguration] ftpDirPath],[[UserManager sharedUserManager]userName]];
    NSString *ftpPath = [NSString stringWithFormat:@"%@%@",[[Configuration shareConfiguration] ftpDirPath],DocumentDirectory.shareDocumentDirectory.mediaFolder];
    NSLog(@"ftpPath------> %@", ftpPath);
    
    [createDirController createDirectory:ftpPath
             completionHandler:  (DirCompletionHandler) dirCompletionHandler];
}

- (NSString *)returnZipPathWithUserName {
    
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    NSString *fileName = [NSString stringWithFormat:@"%@.zip",DocumentDirectory.shareDocumentDirectory.mediaFolder];
    NSURL *fileURL = [[[DocumentDirectory shareDocumentDirectory] directoryPath]URLByAppendingPathComponent:fileName];
    NSLog(@"%@",fileURL);
    if ([filemanager fileExistsAtPath:fileURL.path]) {
        return fileURL.path;
    } else {
        return @"";
    }
}

- (void)uploadMediaWithPath:(NSString *)zipPath {
    
    NSString *hostName = [NSString stringWithFormat:@"%@%@", [[Configuration shareConfiguration] ftpHostName], DocumentDirectory.shareDocumentDirectory.mediaFolder];
    [FTPHelper sharedInstance].delegate = self;
    [FTPHelper sharedInstance].uname = [[Configuration shareConfiguration] ftpUserName];
    [FTPHelper sharedInstance].pword = [[Configuration shareConfiguration] ftpPassword];
//    [FTPHelper sharedInstance].urlString = [[Configuration shareConfiguration] ftpHostName];
    [FTPHelper sharedInstance].urlString = hostName;
    [FTPHelper upload:zipPath];
}

- (void) dataUploadFinished: (NSNumber *) bytes {
    
    [[DocumentDirectory shareDocumentDirectory] removeZipPathWithUserName:[[UserManager sharedUserManager]userName]];
    
    //Remove All Array Elements
    [self.imagesArray removeAllObjects];
    [self.tableView reloadData];
//    alertView(@"Images or Documents Uploaded", @"Images or Documents Uploaded Successfully", nil, @"Ok", nil, 0);
}

- (void) dataUploadFailed: (NSString *) reason {
    alertView(@"Data Upload Failed", reason, nil, @"Ok", nil, 0);
}

#pragma  mark - Picker Selection methods

- (void)raiseGrievance
{
    [(UILabel *)[self.view viewWithTag:kGrievanceStausLabelTag] setHidden:YES];

    self.selectedSegment = 0;
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:kHeaderScrollTag];
    [scroll setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    [(UIView *)[self.view viewWithTag:kRaiseGrievanceLineTag]setHidden:NO];
    [(UIView *)[self.view viewWithTag:kGrievanceTrackLineTag]setHidden:YES];
    [(UIView *)[self.view viewWithTag:kGrievanceGuideLineTag]setHidden:YES];
    
    [[[(UILabel*)[self.view viewWithTag:kRaiseGrievanceTag]subviews] objectAtIndex:0]setTextColor:[UIColor blackColor]];
    [[[(UILabel*)[self.view viewWithTag:kGrievanceTrackTag]subviews] objectAtIndex:0]setTextColor:[UIColor lightGrayColor]];
    [[[(UILabel*)[self.view viewWithTag:kGrievanceGuideTag]subviews] objectAtIndex:0]setTextColor:[UIColor lightGrayColor]];
    
    
    
    [self reloadTableView];
    
}

- (void)grievanceTrack
{
    //When Scroll User then HIDE the Table View
    if (self.dropDownViews != nil) {
        [self.dropDownViews removeFromSuperview];
        self.nIDropDown = nil;
    }
    
    [(UILabel *)[self.view viewWithTag:kGrievanceStausLabelTag] setHidden:YES];
    
    self.selectedSegment = 1;
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:kHeaderScrollTag];
    [scroll setContentOffset:CGPointMake([self bounds].size.width / 3.0 + 15.0, 0.0) animated:YES];
    [(UIView *)[self.view viewWithTag:kRaiseGrievanceLineTag]setHidden:YES];
    [(UIView *)[self.view viewWithTag:kGrievanceTrackLineTag]setHidden:NO];
    [(UIView *)[self.view viewWithTag:kGrievanceGuideLineTag]setHidden:YES];
    [[[(UILabel*)[self.view viewWithTag:kRaiseGrievanceTag]subviews] objectAtIndex:0]setTextColor:[UIColor lightGrayColor]];
    [[[(UILabel*)[self.view viewWithTag:kGrievanceTrackTag]subviews] objectAtIndex:0]setTextColor:[UIColor blackColor]];
    [[[(UILabel*)[self.view viewWithTag:kGrievanceGuideTag]subviews] objectAtIndex:0]setTextColor:[UIColor lightGrayColor]];
    [self grievanceTrackHandler];
    
}

- (void)grievanceGuide
{

    [(UILabel *)[self.view viewWithTag:kGrievanceStausLabelTag] setHidden:YES];

    self.selectedSegment = 2;
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:kHeaderScrollTag];
    [scroll setContentOffset:CGPointMake([self bounds].size.width / 3.0 * 2.0 + 30.0, 0.0) animated:YES];
    
    [(UIView *)[self.view viewWithTag:kRaiseGrievanceLineTag]setHidden:YES];
    [(UIView *)[self.view viewWithTag:kGrievanceTrackLineTag]setHidden:YES];
    [(UIView *)[self.view viewWithTag:kGrievanceGuideLineTag]setHidden:NO];
    
    [[[(UILabel*)[self.view viewWithTag:kRaiseGrievanceTag]subviews] objectAtIndex:0]setTextColor:[UIColor lightGrayColor]];
    [[[(UILabel*)[self.view viewWithTag:kGrievanceTrackTag]subviews] objectAtIndex:0]setTextColor:[UIColor lightGrayColor]];
    [[[(UILabel*)[self.view viewWithTag:kGrievanceGuideTag]subviews] objectAtIndex:0]setTextColor:[UIColor blackColor]];
    
    [self.grievanceDetail setValue:[self returynGrievanceGuide] forKey:@"grievanceguide"];
    
    [self reloadTableView];
    
    
}

#pragma  mark - Table View Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.selectedSegment == 0)
        return 3;
    else if(self.selectedSegment == 2)
        return 1;
    else
        return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selectedSegment == 2){
        return 8;
    }else if(self.selectedSegment == 1){
        return [[self.grievanceDetail valueForKey:@"grievancetrack"] count];
    }else if(self.selectedSegment == 0){
        if (section == 1) {
            return 1;
        }else{
            return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectedSegment == 2){
        return 55.0;
        
    }else if(self.selectedSegment == 1){
        return 124.0;
    }else if(self.selectedSegment == 0){
        if (indexPath.section == 1) {
            if([self.imagesArray count]){
                long int isDivison=[self.imagesArray count]/3;
                int isPosition = 10;
                NSMutableArray *height=[[NSMutableArray alloc]init];
                for (int r=0; r< isDivison+1; r++) {
                    [height addObject:[NSString stringWithFormat:@"%d",isPosition]];
                    isPosition = isPosition + 70;
                }
                return isPosition + 10;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }

    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooter = [[UIView alloc]init];
    sectionFooter.backgroundColor = [UIColor clearColor];
    return  sectionFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 10.0;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.selectedSegment == 0)
    {
        return [self raiseGrievanceViewWithSectionType:section];
    }
    else if (self.selectedSegment == 2)
        return [self grievanceGuideHeaderView];
    else
        return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.selectedSegment == 0)
    {
        if (section == 0)
        {
            return 360.0;
//            return 420.0;
        }
        else
        {
            return 70.0f;
        }
    }
    else if (self.selectedSegment == 2)
        return 10.0;
    else
        return 0.0;

}


- (GriveanceTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        GriveanceTableViewCell *cell;
        if (cell == nil)
        {
            cell = [[GriveanceTableViewCell alloc]initWithDelegate:self indexPath:indexPath grievnaceDetails:self.grievanceDetail index:self.selectedSegment imagesArray:self.imagesArray isAttach:self.isAttach selectedArray:self.selectedArray];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        
        
    return cell;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.selectedSegment == 1)
    {
        NSArray *array = [[[self.grievanceDetail valueForKey:@"grievancetrack"]reverseObjectEnumerator]allObjects];
        
        GrievanceTrackViewController *vctr = [[GrievanceTrackViewController alloc]initWithResponse:[array objectAtIndex:indexPath.row] delegate:self];
        [self.navigationController pushViewController:vctr animated:YES];
        
    }
}
/*
//OLD Code
- (void)getChoosedImages:(NSMutableArray *)selectedArray selectedImagesArray:(NSMutableArray *)selectedImagesArray
{
    self.selectedArray = selectedArray;
}
*/
- (void)getChoosedImages:(NSMutableArray *)selectedArray
{
    self.selectedArray = selectedArray;
    NSLog(@"imagesArray1:%@", self.imagesArray);
    NSLog(@"selectedArray:%@", self.selectedArray);
    if (self.selectedArray.count) {
        
        for (int i = 0; i < [self.selectedArray count]; i++) {
            NSString *index = [self.selectedArray objectAtIndex:i];
            [[DocumentDirectory shareDocumentDirectory] removeImageOrPdfWithName:[self.imagesArray objectAtIndex:[index integerValue]-1]];
            [self.imagesArray removeObjectAtIndex:[index integerValue]-1];
        }
        [self.selectedArray removeAllObjects];
//        [self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSLog(@"imagesArray2:%@", self.imagesArray);
}

#pragma mark - TextFiled delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField.keyboardType == numberPadKeyboard)
//    {
//        textField.inputAccessoryView = [[KeyboardHelper sharedKeyboardHelper]tollbar:self.view];
//    }
    //textField.inputAccessoryView = [[KeyboardHelper sharedKeyboardHelper]tollbar:self.view];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.grievanceDetail setValue:textField.text forKey:kComplaintClaimNumber];
    [textField resignFirstResponder];
    
    if ([[[CoreData shareData] getPolicyDetail] count] > 0) {
        NSDictionary *response = [[CoreData shareData] getPolicyDetail];
        NSMutableArray *claimHistoryDetail = [[NSMutableArray alloc]init];
        self.policyDetail = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *policyDetailDic = [[NSMutableDictionary alloc]init];
        NSMutableArray *memberPolicyNumbers = [[NSMutableArray alloc]init];
        
        //NSArray *array = [response valueForKey:@"MemberDetails"];
        if ([[response valueForKey:@"PolicyNumber"] length] > 0)
        {
            [memberPolicyNumbers addObject:[response valueForKey:@"PolicyNumber"]];
        }
        
        [policyDetailDic setValue:memberPolicyNumbers forKey:@"policynumber"];
        [policyDetailDic setValue:[response valueForKey:@"MemberID"] forKey:@"memberiD"];
        [policyDetailDic setValue:[response valueForKey:@"PolicyType"] forKey:kCallerType];
        for (NSDictionary *dictionary in [response valueForKey:@"PolicyDetails"]) {
            MyPolicyModel *home = [MyPolicyModel getPolicyHistoryDetailsByResponse:dictionary];
            [claimHistoryDetail addObject:home];
        }
        [self.policyDetail setValue:policyDetailDic forKey:@"policydetail"];
        [self.policyDetail setValue:claimHistoryDetail forKey:@"claimhistory"];
//        [self policyNumber];
    }else{
        [self showHUDWithMessage:@""];
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
        [param setValue:[[UserManager sharedUserManager] userName] forKey:@"UHID"];
        [[HITPAAPI shareAPI] policyDetailsWithParams:param completionHandler:^(NSDictionary *response, NSError *error){
            [self didReceivePolicyResponse:response error:error];
        }];
    }
}



#pragma TextView Delegates
-(void)textViewDidBeginEditing:(UITextView *)textView
{
//    [[KeyboardHelper sharedKeyboardHelper]animateTextView:textView isUp:YES View:self.view];
    textView.textColor = [UIColor blackColor];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
//    [[KeyboardHelper sharedKeyboardHelper]animateTextView:textView isUp:NO View:self.view];
    [self.grievanceDetail setValue:textView.text forKey:kComplaintRemark];
     [textView resignFirstResponder];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView * _Nonnull)textView
{
    
    if ([textView.text isEqualToString:kComplaintRemarkPlaceholder])
    {
        textView.text = @"";
    }
    
    
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        
        if ([textView.text  isEqual: @""]) {
            textView.text = NSLocalizedString(kComplaintRemarkPlaceholder, @"");
            textView.textColor = [UIColor grayColor];

        }
        
        return NO;
    }
    
    return YES;
}


#pragma mark - 

- (NSArray *)getComplaintSubTypeForComplaintType:(NSString *)complaintType {
    if ([complaintType isEqualToString:@"Health Card Related"]) {
        return self.HealthArray;
    }
    if ([complaintType isEqualToString:@"Claims Related"]) {
        return self.claimArray;
    }
    if ([complaintType isEqualToString:@"Policy Related"]) {
        return self.policyArray;
    }
    if ([complaintType isEqualToString:@"Provider Related"]) {
        return self.providerArray;
    }
    return nil;
}


#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
