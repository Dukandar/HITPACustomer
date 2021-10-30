//
//  QuickGuideController.m
//  HITPA
//
//  Created by Bhaskar C M on 12/7/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "QuickGuideController.h"
#import "Configuration.h"
#import <QuartzCore/QuartzCore.h>
#import "DownloadFormTableViewCell.h"
#import "Helper.h"
#import "HITPAAPI.h"
#import "UserManager.h"
#import "Utility.h"
#import "DocumentDirectory.h"
#import "PDFViewController.h"

@interface QuickGuideController () <UIPickerViewDataSource,UIPickerViewDelegate,downloadFormTableViewCell>

@property (nonatomic, strong)   UITextView      *   detailTextView;
@property (nonatomic, strong)   UIView          *   toggleView;
@property (nonatomic, strong)   UIView          *   lineView;
@property (nonatomic)           CGRect              quickguideFrame;
@property (nonatomic, strong)   UIPickerView    *   picker;
@property (nonatomic, strong)   NSMutableArray  *   pickerIndex;
@property (nonatomic, strong)   NSMutableArray  *   emailArray;
@property (nonatomic, strong)   NSMutableArray  *   downloadForms;
@property (nonatomic, readwrite)   NSInteger        selectedSection;

@property (nonatomic, strong)   UIImageView *backgroundImageView;
@end

@implementation QuickGuideController

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Customer Guide", nil);
//    self.view.backgroundColor =[UIColor colorWithRed:62.0/255.0 green:86.0/255.0 blue:132.0/255 alpha:1.0];
//    self.view.backgroundColor = [UIColor colorWithRed:62/255.0 green:86/255.0 blue:132/255.0 alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.emailArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"", nil];
    self.downloadForms = [[NSMutableArray alloc]initWithObjects:@"Cashless Forms",@"Claim Form",@"Claim CheckList",@"KYC Form",@"Non Payable Items List",@"NEFT RTGS Form",nil];
    [self quickguideDesign];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + 50.0, frame.size.width, frame.size.height - 120.0);
    [self.view layoutIfNeeded];
    
}

- (void)quickguideDesign
{
    self.quickguideFrame = [self bounds];
    CGFloat xPos , yPos , width , height;
    
    //Toggle View
    xPos   = 0.0 ;
    yPos   = 0.0;
    width  = self.quickguideFrame.size.width;
    height = 50.0;
    self.toggleView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    self.toggleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toggleView];
    
    xPos = -75.0;
    yPos = 0.0;
    width = self.quickguideFrame.size.width + 150.0;
    height = 45.0;
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(- M_PI/2);
    rotate = CGAffineTransformScale(rotate, 1.0, 1.0);
    [self.picker setTransform:rotate];
    self.picker.frame = CGRectMake(xPos, yPos, width , height);
    [self.toggleView addSubview:self.picker];
    
    // text view data
    xPos    = 0.0 ;
    yPos    = self.toggleView.frame.origin.y + self.toggleView.frame.size.height + 16.0 ;
    width   = self.quickguideFrame.size.width;
    height  = self.quickguideFrame.size.height - (self.toggleView.frame.size.height + 20.0 + 44.0 + 20.0);
    self.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    self.detailTextView.editable = NO;
    [self.view addSubview:self.detailTextView];
    [self.tableView setHidden:YES];
    [self emergencyNetworked];
    [self.picker selectRow:1 inComponent:0 animated:NO];
    [self belowView:@"Emergency Networked"];
    
}


- (void)belowView:(NSString *)Header
{
    CGFloat xPos , yPos ,width ,height;
    
    if ([Header isEqualToString:@"Planned Networked"])
    {
        xPos   =  self.quickguideFrame.size.width/3.6;
        
    }
    else if ([Header isEqualToString:@"Emergency Networked"])
    {
        xPos   =  self.quickguideFrame.size.width/4;
        
    }
    else if ([Header isEqualToString:@"Planned Non Networked"])
    {
        xPos   =  self.quickguideFrame.size.width/4.1;
        
    }
    else if ([Header isEqualToString:@"Emergency Non Networked"])
    {
        xPos   =  self.quickguideFrame.size.width/5;
        
    }
    else {
        //download forms
        xPos   =  self.quickguideFrame.size.width/3.4;
    }
    
    CGSize size = [Header sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:16]}];
    yPos   = 45.0;
    width  = size.width;
    xPos = (self.quickguideFrame.size.width - width)/2.0;
    height = 1.5;
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    self.lineView.backgroundColor =[UIColor colorWithRed:6.0/255.0 green:106.0/255.0 blue:99.0/255 alpha:1.0];
    self.lineView.hidden = NO;
    [self.toggleView addSubview:self.lineView];
    
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen]bounds];
}

#pragma mark - PickerView Delegates

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    [[self.picker.subviews objectAtIndex:1] setHidden:TRUE];
    [[self.picker.subviews objectAtIndex:2] setHidden:TRUE];
    self.pickerIndex = [NSMutableArray arrayWithCapacity:4];
    [self.pickerIndex addObject:@"Planned Networked"];
    [self.pickerIndex addObject:@"Emergency Networked"];
    [self.pickerIndex addObject:@"Planned Non Networked"];
    [self.pickerIndex addObject:@"Emergency Non Networked"];
    [self.pickerIndex addObject:@"Download Forms"];
    UILabel * pickerLabel = [[UILabel alloc]init];
    pickerLabel.textColor = [UIColor blackColor];
    pickerLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:16.0];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.frame = CGRectZero;
    pickerLabel.text = [NSString stringWithFormat:@"%@", [self.pickerIndex objectAtIndex:(row%5)]];
    CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI/2);
    rotate = CGAffineTransformScale(rotate, 1.0, 1.0);
    [pickerLabel setTransform:rotate];
    pickerLabel.frame = CGRectMake(0.0, 0.0, 30, [self bounds].size.width/1.5);
    return pickerLabel;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return ([[UIScreen mainScreen]bounds].size.width)/1.5;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    self.lineView.hidden =YES;
    NSString *retriveData = [self.pickerIndex objectAtIndex:(row%5)];
    if ([retriveData isEqualToString:@"Planned Networked"])
    {
        [self.detailTextView setHidden:NO];
        [self.tableView setHidden:YES];
        [self plannedNetworked];
    }
    else if ([retriveData isEqualToString:@"Emergency Networked"])
    {
        [self.detailTextView setHidden:NO];
        [self.tableView setHidden:YES];
        [self emergencyNetworked];
    }
    else if ([retriveData isEqualToString:@"Planned Non Networked"])
    {
        [self.detailTextView setHidden:NO];
        [self.tableView setHidden:YES];
        [self plannednonNetworked];
    }
    else if ([retriveData isEqualToString:@"Emergency Non Networked"])
    {
        [self.detailTextView setHidden:NO];
        [self.tableView setHidden:YES];
        [self emergencynonNetworked];
        
        
    }
    else if ([retriveData isEqualToString:@"Download Forms"])
    {
        [self.detailTextView setHidden:YES];
        [self.tableView setHidden:NO];
        [self reloadTableView];

    }
    [self belowView:retriveData];
    [self pickerViewLoaded:nil];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 16384;
}

-(void)pickerViewLoaded: (id)blah {
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%5;
    [self.picker selectRow:[self.picker selectedRowInComponent:0]%5+base10 inComponent:0 animated:false];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

#pragma mark - Picker Segment
- (void)plannedNetworked
{
    
    NSString * plannedData = [NSString stringWithFormat:@"Inform TPA/Insurance Company about hospitalization in advance along with\n a) Details of illness and Nature of treatment\n b) Estimated cost of treatment\n c) Proposed date of admission\n\nIf Cash less facility is approved\n a) Carry Health Card and Photo ID\n b) Submit Pre-Authorisation received from TPA/Insurance Company to Hospital\n c) Get admitted\n d) At the time of discharge\n    > Verify and sign\n\t- Original hospital bills\n\t- Investigation reports\n\t- Discharge summary\n     > Pay for expenses/bills not covered by Policy terms and conditions\ne) Hospital will submit the claim to TPA/Insurance Company\n\nIf Cash less facility is not approved,\n a) Carry Health Card and Photo ID\n b) Get admitted\n c) At the time of discharge\n  i) Settle hospital bills in full\n  ii) Collect hospital bills, investigation reports and discharge summary\n d) Submit claim to TPA/Insurance Company with all original documents\n"];
    
    NSMutableAttributedString * plannedString = [[NSMutableAttributedString alloc] initWithString:plannedData];
    [plannedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:NSMakeRange(74,108)];
    [plannedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:NSMakeRange(219,385)];
    [plannedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:NSMakeRange(642,260)];
    self.detailTextView.attributedText = plannedString;
    self.detailTextView.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14];
    
}

- (void)emergencyNetworked
{
    NSString * plannedData = [NSString stringWithFormat:@"Carry Health Card and Photo ID\n\nGet admitted\n\nComplete and submit‚ Pre-Authorisation‚ request form\n\nIf Cash less facility is approved\na) At the time of discharge\ni) Verify and sign\n- Original hospital bills\n- Investigation reports\n- Discharge summary\nii) Pay for expenses/bills not covered by Policy terms and conditions\nb) Hospital will submit the claim to TPA/Insurance Company\n\nIf Cash less facility is not approved\na) At the time of discharge\ni) Settle hospital bills in full\nii) Collect hospital bills, investigation reports and discharge summary\nb) Submit claim to TPA/Insurance Company with all original documents"];
    NSMutableAttributedString * plannedString = [[NSMutableAttributedString alloc] initWithString:plannedData];
    [plannedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:NSMakeRange(133,246)];
    [plannedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:NSMakeRange(418,202)];
    self.detailTextView.attributedText = plannedString;
    self.detailTextView.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14];
    
}

- (void)plannednonNetworked
{
    NSString * plannedData = [NSString stringWithFormat:@"Inform TPA/Insurance Company about hospitalization in advance along with\na) Details of illness and Nature of treatment\nb) Estimated cost of treatment\nc) Proposed date of admission\n\nGet admitted\n\nAt the time of discharge\na) Settle hospital bills in full\nb) Collect hospital bills, investigation reports and discharge summary\n\nSubmit claim to TPA/Insurance Company with all original documents"];
    NSMutableAttributedString * plannedString = [[NSMutableAttributedString alloc] initWithString:plannedData];
    [plannedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:NSMakeRange(73,106)];
    [plannedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:NSMakeRange(219,171)];
    self.detailTextView.attributedText = plannedString;
    self.detailTextView.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14];
    
}

- (void)emergencynonNetworked
{
    NSString * plannedData = [NSString stringWithFormat:@"Get Admitted\n\nIntimate TPA/Insurance Company , as soon as possible \nAt the time of discharge\na) Settle hospital bills in full\nb) Collect hospital bills, investigation reports and discharge summary\nSubmit claim to TPA/Insurance Company with all original documents"];
    NSMutableAttributedString * plannedString = [[NSMutableAttributedString alloc] initWithString:plannedData];
    [plannedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] range:NSMakeRange(68,194)];
    self.detailTextView.attributedText = plannedString;
    self.detailTextView.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14];
    
}

- (void)downloadPdfTapped:(UITapGestureRecognizer *)sender {
    
    self.selectedSection = sender.view.tag;
    NSString *formName = [self getFormNameForSection:sender.view.tag];
    PDFViewController *vctr = [[PDFViewController alloc]init];
    vctr.formName = formName;
    [self.navigationController pushViewController:vctr animated:true];

}

- (void)didReceiveDownloadPdfResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    NSData *data = (NSData *)[response objectForKey:@"number"];
    if (data.length > 0) {
        NSString *formName = [self getFormNameForSection:self.selectedSection];
        if ([[DocumentDirectory shareDocumentDirectory]writePdfIntoDocumentDirectory:data pdfName:formName]) {
            PDFViewController *vctr = [[PDFViewController alloc]init];
            vctr.data = data;
            vctr.formName = formName;
            [self.navigationController pushViewController:vctr animated:true];
        }else {
            
        }
    }else {
        
    }
    
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.downloadForms.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat )getHeightWithText:(NSString *)text font:(UIFont *)font
{
    
    CGRect frame = [self bounds];
    
    CGFloat xPos = 3.0;
    CGFloat yPos = 5.0;
    CGFloat width = frame.size.width - 12.0;
    CGFloat height = 20.0;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [label setText:[text capitalizedString]];
    [label setFont:font];
    [label setNumberOfLines:0];
    [label sizeToFit];
    
    return label.frame.size.height;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = [self bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat width =  frame.size.width;
    CGFloat height = 50.0;
    UIView *sectionHeader = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor colorWithRed:5/255.0 green:143/255.0 blue:134/255.0 alpha:1.0]];
    sectionHeader.tag = section;
    
    xPos =  10.0;
    yPos =  0.0;
    width = frame.size.width - xPos - 70.0;
    height = sectionHeader.frame.size.height;
    UILabel *sectionTitle = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[self.downloadForms objectAtIndex:section] fontSize:16.0 fontColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    [sectionHeader addSubview:sectionTitle];
    
    xPos = sectionTitle.frame.origin.x + sectionTitle.frame.size.width + 10.0;
    width = sectionHeader.frame.size.width - xPos;
    height = sectionHeader.frame.size.height;
    yPos = 0.0;
    UIView *downloadView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
    downloadView.tag = section;
    [sectionHeader addSubview:downloadView];
    
    UITapGestureRecognizer * downloadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadPdfTapped:)];
    [downloadView addGestureRecognizer:downloadTap];
    
    width = 30.0;
    height = 30.0;
    yPos = (downloadView.frame.size.height - height)/2.0;
    xPos = (downloadView.frame.size.width - width)/2.0;
    UIImageView *rightImageView = [self createImageViewWithFrame:CGRectMake(xPos, yPos, width, height) image:[UIImage imageNamed:@"icon_download.png"]];
    rightImageView.tag = section;
    [downloadView addSubview:rightImageView];
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50.0;
    
}

- (DownloadFormTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DownloadFormTableViewCell *cell;
    
    if(cell == nil)
    {
        
        cell = [[DownloadFormTableViewCell alloc]initWithIndexPath:indexPath emailTxt:self.emailArray[indexPath.section] delegate:self];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:backgroundColor];
    return view;
}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = image;
    return imageView;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration shareConfiguration]hitpaFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
}

- (NSString *)getFormNameForSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Cashless_Form";
            break;
        case 1:
            return @"Claim_Form";
            break;
        case 2:
            return @"Claim_Check_LIst";
            break;
        case 3:
            return @"KYC_FORM";
            break;
        case 4:
            return @"NEFT_RTGS_Form";
            break;
        case 5:
            return @"Non_Payable_Items_List";
            break;
        default:
            return @"";
            break;
    }
}

- (void)emailPdf:(NSInteger)section {
    self.selectedSection = section;
    UITextField * textField = (UITextField *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].subviews[0].subviews[0].subviews[0];
    if (![textField.text isEqual: @""]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setValue:[[UserManager sharedUserManager]authToken] forKey:@"AuthToken"];
        [params setValue:textField.text forKey:@"EmailID"];
        [params setValue:[self getFormNameForSection:section] forKey:@"FormName"];
        
        
        BOOL isValidate =  [[Helper shareHelper]emailValidationWithEmail:textField.text];
        
        if (!isValidate)
        {
            alertView([[Configuration shareConfiguration] appName], @"Enter valid Email ID", nil, @"Ok", nil, 0);
            return ;
            
        }
        
        [self showHUDWithMessage:@""];
        [[HITPAAPI shareAPI] emailDownloadForm:params completionHandler:^(NSDictionary *response ,NSError *error){
            
            [self didReceiveEmailResponse:response error:error];
            
        }];
    }else {
        alertView([[Configuration shareConfiguration] appName], @"Please enter email Id", nil, @"Ok", nil, 0);
        return ;
    }
    
    
}

- (void)updateEnteredEmailID:(NSString *)emailTxt section:(NSInteger)section {
    
    self.emailArray[section] = emailTxt;
    
}

- (void)didReceiveEmailResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    NSString *str = [response objectForKey:@"number"];
    alertView([[Configuration shareConfiguration] appName],str , nil, @"Ok", nil, 0);
    UITextField * textField = (UITextField *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectedSection]].subviews[0].subviews[0].subviews[0];
    textField.text = @"";
    return;
    
}

//#pragma mark - Alertview delegate
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    return;
//}

/*

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
