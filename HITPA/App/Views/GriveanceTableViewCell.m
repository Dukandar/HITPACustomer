//
//  GriveanceTableViewCell.m
//  HITPA
//
//  Created by Bhaskar C M on 12/18/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "GriveanceTableViewCell.h"
#import "Configuration.h"
#import "Utility.h"
#import "Greveance.h"
#import "DocumentDirectory.h"

NSString * const kGriveanceReuseIdentifier     = @"griveance";

@implementation GriveanceTableViewCell

- (instancetype)initWithDelegate:(id<griveanceTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath grievnaceDetails:(NSMutableDictionary *)grievnaceDetails index:(NSInteger)index imagesArray:(NSMutableArray *)imagesArray isAttach:(BOOL) isAttach selectedArray:(NSMutableArray *)selectedArray
{
    
    self.selectedArray = selectedArray;
    self.imagesArray = imagesArray;
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGriveanceReuseIdentifier];
    
    if (self)
    {
        self.delegate = delegate;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self griveanceTableViewCellWithGrievnaceDetails:grievnaceDetails indexPath:indexPath index:index imagesArray:imagesArray isAttach:isAttach];
        
    }
    
    
    return self;
}

- (void)griveanceTableViewCellWithGrievnaceDetails:(NSMutableDictionary *)grievnaceDetails indexPath:(NSIndexPath *)indexPath index:(NSInteger)index imagesArray:(NSMutableArray *)imagesArray isAttach:(BOOL) isAttach
{
    if(grievnaceDetails == nil)
    {
        [self createComplaintLabelWithText:[self.selectedArray objectAtIndex:indexPath.row]];
    }
    else
        [self createGriveanceListViewWithIndexPath:indexPath grievnaceDetails:grievnaceDetails index:index imagesArray:imagesArray isAttach:isAttach];
    
}


- (void)createGriveanceListViewWithIndexPath:(NSIndexPath *)indexPath grievnaceDetails:(NSMutableDictionary *)grievnaceDetails index:(NSInteger)index imagesArray:(NSMutableArray *)imagesArray isAttach:(BOOL) isAttach
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    if (index == 2) {
        
        NSArray *array = [grievnaceDetails valueForKey:@"grievanceguide"];
        
        CGFloat xPos = 0.0;
        CGFloat yPos = 5.0;
        CGFloat height = 55.0;
        CGFloat width = frame.size.width;
        UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewMain.tag = indexPath.row;
        viewMain.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewMain];
        
        xPos = 10.0;
        width = frame.size.width - xPos;
        UILabel *statusDetails = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:[NSString stringWithFormat:@"%@",[array objectAtIndex:indexPath.row]] fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        statusDetails.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
        statusDetails.numberOfLines = 3;
        [viewMain addSubview:statusDetails];
        
    } else if (index == 0) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.contentView.backgroundColor = [UIColor redColor];
        if (indexPath.section == 1) {
            int isPosition=68;
            if([imagesArray count] > 0) {
                
                long int isDivison=[imagesArray count]/3,m=0;
                isPosition=68;
                NSMutableArray *array_height=[[NSMutableArray alloc]init];
                for (int r=0; r< isDivison+1; r++) {
                    [array_height addObject:[NSString stringWithFormat:@"%d",isPosition]];
                    isPosition=isPosition+80;
                }
                
                for (int k=0; k < isDivison+1; k++) {
                    
                    int i=0;
                    for (int t=0; t < 3; t++) {
                        if(m < [imagesArray count]) {
                            UIView *viewImages=[[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/3*i+20, [[array_height objectAtIndex:k] integerValue]-60, 80, 70)];
                            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 2, 50, 50)];
                            UILabel * labelImageName = [[UILabel alloc]initWithFrame:CGRectMake(3, 52, 80, 18)];
//                            labelImageName.textAlignment = NSTextAlignmentCenter;
                            labelImageName.numberOfLines = 0;
                            labelImageName.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaFontWithSize:14.0] : [[Configuration shareConfiguration] hitpaFontWithSize:8.0];
                            UIButton *btnsel=[[UIButton alloc]initWithFrame:CGRectMake(56, 2, 25, 18)];
                            btnsel.tag=m+1;
                            btnsel.layer.cornerRadius = 3.0f;
                            btnsel.layer.borderColor=[[UIColor grayColor]CGColor];
//                            btnsel.layer.borderWidth=1.0f;
                            btnsel.layer.masksToBounds=YES;
                            [btnsel setBackgroundImage:[UIImage imageNamed:@"icon_cancel.png"] forState:UIControlStateNormal];
                            [btnsel addTarget:self action:@selector(imgSel:) forControlEvents:UIControlEventTouchUpInside];
//                            imageView.image=[[imagesArray objectAtIndex:m]valueForKey:[NSString stringWithFormat:@"Image_%ld",m+1]]; //OLD Code
                            NSString *imageName = [imagesArray objectAtIndex:m];
                            //To check Image Type
                            if ([imageName containsString:@".jpg"] || [imageName containsString:@".png"] || [imageName containsString:@".jpeg"]) {
                                NSData *imageData = [[DocumentDirectory shareDocumentDirectory] getImageOrPdfWithName:imageName];
                                UIImage *image = [[UIImage alloc]initWithData:imageData];
                                imageView.image = image;
                                labelImageName.text = imageName;
                            } else {
                                imageView.image = [UIImage imageNamed:@"doc_icon.png"];
                                labelImageName.text = imageName;
                            }
                    
                            [viewImages addSubview:imageView];
                            [viewImages addSubview:labelImageName];
                            [viewImages addSubview:btnsel];
                            viewImages.backgroundColor=[UIColor clearColor];
//                            viewImages.backgroundColor=[UIColor blueColor];
                            [self.contentView addSubview:viewImages];
                            i++;
                            m++;
                        }
                    }
                }
            }
        }
    } else {
        
        NSArray *array = [[[grievnaceDetails valueForKey:@"grievancetrack"]reverseObjectEnumerator]allObjects];
        Greveance *grievanceDetail = (Greveance *)[array objectAtIndex:indexPath.row];
        CGFloat xPos = 0.0;
        CGFloat yPos = 5.0;
        CGFloat height = 120.0;
        CGFloat width = frame.size.width;
        UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewMain.tag = indexPath.row;
        viewMain.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewMain];
        
        xPos = 0.0;
        yPos = 0.0;
        width = 5.0;
        height = viewMain.frame.size.height;
        UIView *leftLine = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        leftLine.backgroundColor = [UIColor colorWithRed:(25.0/255.0) green:(102.0/255.0) blue:(149.0/255.0) alpha:1.0f];
        [viewMain addSubview:leftLine];
        
        //From Left to Right Logo, Time & Date Space
        //        xPos = 5.0;
        xPos = 12.0;
        width = 100.0;
        UIView *logoAndTime = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        logoAndTime.backgroundColor = [UIColor clearColor];
        [viewMain addSubview:logoAndTime];
        
        yPos = 7.0;
        width = 53.0;
        height = 45.0;
        xPos = ((logoAndTime.frame.size.width - width)/2) - 5.0;
        UIImageView *logo = [[UIImageView
                              alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        logo.image = [UIImage imageNamed:@"icon_hitpalogo"];
        [logoAndTime addSubview:logo];
        NSString *dateStr = grievanceDetail.grievanceReqDate;
        //Date and Time
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
        NSDate *grievanceReqDate = [dateFormat dateFromString:dateStr];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        NSString *grievanceReqDateString = [dateFormat stringFromDate:grievanceReqDate];
        
        //        NSString *raiseDateAndTime = [NSString stringWithFormat:@"%@",[dateFormat dateFromString:dateStr]];
        //        NSCalendar *calendar = [NSCalendar currentCalendar];
        //        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[dateFormat dateFromString:dateStr]];
        //        NSInteger hour = [components hour];
        //        NSInteger minute = [components minute];
        //        NSArray *dateArray = [raiseDateAndTime componentsSeparatedByString:@" "];
        //        NSString *raiseDate = [NSString stringWithFormat:@"%@-%@-%@",[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2],[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1],[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0]];
        //        NSString *raiseTime = [NSString stringWithFormat:@"%ld:%ld",hour,minute];
        
        
        //        timeFormatter.dateFormat = @"HH:mm";
        //        NSDate *timeDate = [timeFormatter dateFromString:raiseTime];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"hh:mm:ss a";
        NSString *timeString = [timeFormatter stringFromDate:grievanceReqDate];
        
        NSString *strDate = grievanceDetail.grievanceReqDate;
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *rDate = [dateFormat dateFromString:strDate];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        NSString *dateString = [dateFormat stringFromDate:rDate];
        
        xPos = 4.0;
        width = logoAndTime.frame.size.width;
        yPos = logo.frame.origin.y + 48.0;
        height = 40.0;
        UILabel *date = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[NSString stringWithFormat:@"%@\n\n%@",timeString,grievanceReqDateString] fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        [date setNumberOfLines:0];
        [date sizeToFit];
        [logoAndTime addSubview:date];
        
        xPos = logoAndTime.frame.size.width + 9.0;
        yPos = 8.0;
        width = viewMain.frame.size.width - logoAndTime.frame.size.width;
        height = 37.0;
        UILabel *grievanceNumber = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:grievanceDetail.serviceRequestId fontSize:14.0 fontColor:[UIColor colorWithRed:(25.0/255.0) green:(102.0/255.0) blue:(149.0/255.0) alpha:1.0f] alignment:NSTextAlignmentLeft];
        grievanceNumber.font = frame.size.width>320?[[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0]:[[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0];
        [grievanceNumber setNumberOfLines:2];
        [grievanceNumber sizeToFit];
        [viewMain addSubview:grievanceNumber];
        
        yPos = grievanceNumber.frame.size.height + 8.0;
        width = frame.size.width - xPos;
        height = 20.0;
        UILabel *grievance = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"The complaint has been raised for:" fontSize:14.0 fontColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        grievance.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:15.0];
        grievance.numberOfLines = 2;
        [grievance sizeToFit];
        [viewMain addSubview:grievance];
        
        height = 34.0;
        yPos = grievance.frame.origin.y + grievance.frame.size.height + 2.0;
        UILabel *payment = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:grievanceDetail.serviceRequestType fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        payment.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:15.0];
        [payment setNumberOfLines:2];
        [payment sizeToFit];
        [viewMain addSubview:payment];
        
        yPos = payment.frame.origin.y + payment.frame.size.height - 4.0;
        height = frame.size.width > 320 ? 33.0:25.0;
        width = 57.0;
        UILabel *status = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:@"Status:" fontSize:14.0 fontColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        status.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:15.0];
        [viewMain addSubview:status];
        
        yPos = payment.frame.origin.y + payment.frame.size.height - 4.0;
        xPos = status.frame.origin.x + status.frame.size.width;
        height = frame.size.width > 320 ? 33.0:25.0;
        width = frame.size.width - xPos;
        UILabel *statusDetails = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:grievanceDetail.serviceRequestStatus fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        statusDetails.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:15.0];
        [viewMain addSubview:statusDetails];
    }
}

-(IBAction)imgSel:(id)sender {

    [(UIButton *)[self.contentView viewWithTag:[(id)sender tag]] setBackgroundImage:[UIImage imageNamed:@"icon_check.png"] forState:UIControlStateNormal];
    [self.selectedArray addObject:[NSString stringWithFormat:@"%ld",(long)[(id)sender tag]]];
    
    if ([self.delegate respondsToSelector:@selector(getChoosedImages:)])
    {
        [self.delegate getChoosedImages:self.selectedArray];
    }
}

/* // OLD Code
- (void)createGriveanceListViewWithIndexPath:(NSIndexPath *)indexPath grievnaceDetails:(NSMutableDictionary *)grievnaceDetails index:(NSInteger)index imagesArray:(NSMutableArray *)imagesArray isAttach:(BOOL) isAttach
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    
    if (index == 2) {
        
        NSArray *array = [grievnaceDetails valueForKey:@"grievanceguide"];
        
        CGFloat xPos = 0.0;
        CGFloat yPos = 5.0;
        CGFloat height = 55.0;
        CGFloat width = frame.size.width;
        UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewMain.tag = indexPath.row;
        viewMain.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewMain];
        
        xPos = 10.0;
        width = frame.size.width - xPos;
        UILabel *statusDetails = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:[NSString stringWithFormat:@"%@",[array objectAtIndex:indexPath.row]] fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        statusDetails.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
        statusDetails.numberOfLines = 3;
        [viewMain addSubview:statusDetails];
        
        
    }else if (index == 0){
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if (indexPath.section == 1) {
            int isPosition=68;
            if(isAttach && [imagesArray count] > 0){
                
                long int isDivison=[imagesArray count]/3,m=0;
                isPosition=68;
                NSMutableArray *array_height=[[NSMutableArray alloc]init];
                for (int r=0; r< isDivison+1; r++) {
                    [array_height addObject:[NSString stringWithFormat:@"%d",isPosition]];
                    isPosition=isPosition+80;
                }
                
                for (int k=0; k < isDivison+1; k++) {
                    
                    int i=0;
                    for (int t=0; t < 3; t++) {
                        if(m < [imagesArray count]){
                            UIView *viewImages=[[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/3*i+20, [[array_height objectAtIndex:k] integerValue]-60, 80, 70)];
                            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 2, 50, 50)];
                            UIButton *btnsel=[[UIButton alloc]initWithFrame:CGRectMake(56, 2, 25, 18)];
                            btnsel.tag=m+1;
                            btnsel.layer.cornerRadius=3.0f;
                            btnsel.layer.borderColor=[[UIColor grayColor]CGColor];
                            btnsel.layer.borderWidth=1.0f;
                            btnsel.layer.masksToBounds=YES;
                            [btnsel addTarget:self action:@selector(imgSel:) forControlEvents:UIControlEventTouchUpInside];
                            imageView.image=[[imagesArray objectAtIndex:m]valueForKey:[NSString stringWithFormat:@"Image_%ld",m+1]];
                            [viewImages addSubview:imageView];
                            [viewImages addSubview:btnsel];
                            viewImages.backgroundColor=[UIColor clearColor];
                            [self.contentView addSubview:viewImages];
                            i++;
                            m++;
                        }
                    }
                }
            }
            
        }
        
        
    }else{
        
        NSArray *array = [[[grievnaceDetails valueForKey:@"grievancetrack"]reverseObjectEnumerator]allObjects];
        Greveance *grievanceDetail = (Greveance *)[array objectAtIndex:indexPath.row];
        CGFloat xPos = 0.0;
        CGFloat yPos = 5.0;
        CGFloat height = 120.0;
        CGFloat width = frame.size.width;
        UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewMain.tag = indexPath.row;
        viewMain.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewMain];
        
        xPos = 0.0;
        yPos = 0.0;
        width = 5.0;
        height = viewMain.frame.size.height;
        UIView *leftLine = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        leftLine.backgroundColor = [UIColor colorWithRed:(25.0/255.0) green:(102.0/255.0) blue:(149.0/255.0) alpha:1.0f];
        [viewMain addSubview:leftLine];
        
        //From Left to Right Logo, Time & Date Space
//        xPos = 5.0;
        xPos = 12.0;
        width = 100.0;
        UIView *logoAndTime = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        logoAndTime.backgroundColor = [UIColor clearColor];
        [viewMain addSubview:logoAndTime];
        
        yPos = 7.0;
        width = 53.0;
        height = 45.0;
        xPos = ((logoAndTime.frame.size.width - width)/2) - 5.0;
        UIImageView *logo = [[UIImageView
                              alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        logo.image = [UIImage imageNamed:@"icon_hitpalogo"];
        [logoAndTime addSubview:logo];
        NSString *dateStr = grievanceDetail.grievanceReqDate;
        //Date and Time
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
        NSDate *grievanceReqDate = [dateFormat dateFromString:dateStr];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        NSString *grievanceReqDateString = [dateFormat stringFromDate:grievanceReqDate];

//        NSString *raiseDateAndTime = [NSString stringWithFormat:@"%@",[dateFormat dateFromString:dateStr]];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[dateFormat dateFromString:dateStr]];
//        NSInteger hour = [components hour];
//        NSInteger minute = [components minute];
//        NSArray *dateArray = [raiseDateAndTime componentsSeparatedByString:@" "];
//        NSString *raiseDate = [NSString stringWithFormat:@"%@-%@-%@",[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2],[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1],[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0]];
//        NSString *raiseTime = [NSString stringWithFormat:@"%ld:%ld",hour,minute];
        
        
//        timeFormatter.dateFormat = @"HH:mm";
//        NSDate *timeDate = [timeFormatter dateFromString:raiseTime];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"hh:mm:ss a";
        NSString *timeString = [timeFormatter stringFromDate:grievanceReqDate];
        
        NSString *strDate = grievanceDetail.grievanceReqDate;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *rDate = [dateFormat dateFromString:strDate];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        NSString *dateString = [dateFormat stringFromDate:rDate];

        
        xPos = 4.0;
        width = logoAndTime.frame.size.width;
        yPos = logo.frame.origin.y + 48.0;
        height = 40.0;
        UILabel *date = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[NSString stringWithFormat:@"%@\n\n%@",timeString,grievanceReqDateString] fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        [date setNumberOfLines:0];
        [date sizeToFit];
        [logoAndTime addSubview:date];
        
        xPos = logoAndTime.frame.size.width + 9.0;
        yPos = 8.0;
        width = viewMain.frame.size.width - logoAndTime.frame.size.width;
        height = 37.0;
        UILabel *grievanceNumber = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:grievanceDetail.serviceRequestId fontSize:14.0 fontColor:[UIColor colorWithRed:(25.0/255.0) green:(102.0/255.0) blue:(149.0/255.0) alpha:1.0f] alignment:NSTextAlignmentLeft];
        grievanceNumber.font = frame.size.width>320?[[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0]:[[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0];
        [grievanceNumber setNumberOfLines:2];
        [grievanceNumber sizeToFit];
        [viewMain addSubview:grievanceNumber];
        
        
        yPos = grievanceNumber.frame.size.height + 8.0;
        width = frame.size.width - xPos;
        height = 20.0;
        UILabel *grievance = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"The complaint has been raised for:" fontSize:14.0 fontColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        grievance.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:15.0];
        grievance.numberOfLines = 2;
        [grievance sizeToFit];
        [viewMain addSubview:grievance];
        
        height = 34.0;
        yPos = grievance.frame.origin.y + grievance.frame.size.height + 2.0;
        UILabel *payment = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:grievanceDetail.serviceRequestType fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        payment.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:15.0];
        [payment setNumberOfLines:2];
        [payment sizeToFit];
        [viewMain addSubview:payment];
        
        yPos = payment.frame.origin.y + payment.frame.size.height - 4.0;
        height = frame.size.width > 320 ? 33.0:25.0;
        width = 57.0;
        UILabel *status = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:@"Status:" fontSize:14.0 fontColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        status.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:15.0];
        [viewMain addSubview:status];
        
        yPos = payment.frame.origin.y + payment.frame.size.height - 4.0;
        xPos = status.frame.origin.x + status.frame.size.width;
        height = frame.size.width > 320 ? 33.0:25.0;
        width = frame.size.width - xPos;
        UILabel *statusDetails = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:grievanceDetail.serviceRequestStatus fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        statusDetails.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:15.0];
        [viewMain addSubview:statusDetails];
        
    }
    
    
}

-(IBAction)imgSel:(id)sender{
    
    UIButton *btn = (UIButton*) sender;
    
    for (int i=0; i <[self.selectedArray count]; i++) {
        if(btn.tag ==[[self.selectedArray objectAtIndex:i]integerValue]){
            if(i==0){
                [(UIButton *)[self.contentView viewWithTag:[(id)sender tag]] setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [self.selectedArray removeObjectAtIndex:0];
            }else{
                [(UIButton *)[self.contentView viewWithTag:[(id)sender tag]] setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [self.selectedArray removeObjectAtIndex:i-1];
            }
            NSMutableArray *array_Images=[[NSMutableArray alloc]init];
            for (int i=0; i <[self.selectedArray count]; i++) {
                NSString *str_Id=[self.selectedArray objectAtIndex:i];
                for (int j=0; j<[self.imagesArray count]; j++) {
                    if([str_Id isEqualToString:[NSString stringWithFormat:@"%d",j+1]]){
                        NSMutableDictionary *dic_Images=[[NSMutableDictionary alloc]init];
                        [dic_Images setValue:[[self.imagesArray objectAtIndex:j] valueForKey:[NSString stringWithFormat:@"Image_%d",j+1]] forKey:[NSString stringWithFormat:@"Image_%d",i+1]];
                        [array_Images addObject:dic_Images];
                        
                    }
                }
            }
            self.selectedImagesArray=array_Images;
            
            
            return;
        }
    }
    
    [(UIButton *)[self.contentView viewWithTag:[(id)sender tag]] setBackgroundImage:[UIImage imageNamed:@"icon_check.png"] forState:UIControlStateNormal];
    [self.selectedArray addObject:[NSString stringWithFormat:@"%ld",(long)[(id)sender tag]]];
    
    
    NSMutableArray *array_Images=[[NSMutableArray alloc]init];
    for (int i=0; i <[self.selectedArray count]; i++) {
        NSString *str_Id=[self.selectedArray objectAtIndex:i];
        for (int j=0; j<[self.imagesArray count]; j++) {
            if([str_Id isEqualToString:[NSString stringWithFormat:@"%d",j+1]]){
                NSMutableDictionary *dic_Images=[[NSMutableDictionary alloc]init];
                [dic_Images setValue:[[self.imagesArray objectAtIndex:j] valueForKey:[NSString stringWithFormat:@"Image_%d",j+1]] forKey:[NSString stringWithFormat:@"Image_%d",i+1]];
                [array_Images addObject:dic_Images];
                
            }
        }
    }
    
    self.selectedImagesArray=array_Images;
    
    
    if ([self.delegate respondsToSelector:@selector(getChoosedImages:selectedImagesArray:)])
    {
        [self.delegate getChoosedImages:self.selectedArray selectedImagesArray:self.selectedImagesArray];
    }
    
}
*/
- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration
                   shareConfiguration]hitpaFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
}

- (UIView *)createViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    return view;
    
}

- (void)createComplaintLabelWithText:(NSString *)text {
    CGRect frame = self.frame;
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat height = 44.0;
    CGFloat width = frame.size.width;
    UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMain.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:viewMain];
    
    xPos = 10.0;
    width = frame.size.width - xPos;
    UILabel *statusDetails = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:text fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    statusDetails.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
    [viewMain addSubview:statusDetails];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
