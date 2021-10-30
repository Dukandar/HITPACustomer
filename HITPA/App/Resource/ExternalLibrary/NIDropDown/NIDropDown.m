//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "Configuration.h"


@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@property (nonatomic, readwrite) NSInteger isIndex;
@property (nonatomic, readwrite) BOOL location , isCategory,isContactList;
@property (nonatomic, strong) NSMutableDictionary *category;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;

- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr imgArr:(NSArray *)imgArr direction:(NSString *)direction isIndex:(NSInteger)isIndex
{
    btnSender = b;
    animationDirection = direction;
    self.category = [[NSMutableDictionary alloc]init];
    
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        
        self.list = [NSArray arrayWithArray:arr];
        self.isIndex = isIndex;
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width , 0.0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width + 20.0 , 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(10.0, 6.0, btn.size.width, 0.0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        //table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.backgroundColor = [UIColor clearColor];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor grayColor];
        table.tableFooterView = [UIView new];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width + 18.0, *height);
        }
        table.frame = CGRectMake(10.0, 6.0, btn.size.width, *height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}


-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0.0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0.0);
    }
    table.frame = CGRectMake(10.0, 6.0, btn.size.width, 0.0);
    [UIView commitAnimations];
}

#pragma mark - Table view datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.list count];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [[Configuration shareConfiguration] hitpaFontWithSize:(self.isIndex == 80000)? 16.0 : 12.0];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    if (self.isIndex == 20000)
    {
        HospitalModel *hospital  = (HospitalModel *)[self.list objectAtIndex:indexPath.row];
        
        cell.textLabel.text = hospital.hospitalName;
        cell.detailTextLabel.text=hospital.address;
        
    }else if (self.isIndex == 30000 || self.isIndex == 60000 || self.isIndex == 40000 || self.isIndex == 70000 || self.isIndex == 80000)
    {
        cell.textLabel.text = [self.list objectAtIndex:indexPath.row];
        cell.detailTextLabel.text =@"";
        
    }else if (self.isIndex == 50000)
    {
        cell.textLabel.text = [[self.list objectAtIndex:indexPath.row] valueForKey:@"MemberName"];
        cell.detailTextLabel.text =@"";
        
    }
    
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    
    //    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    //    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    
    for (UIView *subview in btnSender.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    if(self.isIndex == 20000)
        [self.delegate searchhospitaWithDetail:[self.list objectAtIndex:indexPath.row]];
    else if(self.isIndex == 30000)
        [self.delegate complaintType:[self.list objectAtIndex:indexPath.row]];
    else if(self.isIndex == 40000)
        [self.delegate getPolicyNumber:[self.list objectAtIndex:indexPath.row]];
    else if (self.isIndex == 50000)
        [self.delegate memberWithDetails:[self.list objectAtIndex:indexPath.row]];
    else if(self.isIndex == 60000)
        [self.delegate complaintSubType:[self.list objectAtIndex:indexPath.row]];
    else if(self.isIndex == 70000)
        [self.delegate claimType:[self.list objectAtIndex:indexPath.row]];
    else if(self.isIndex == 80000)
        [self.delegate notificationTime:[self.list objectAtIndex:indexPath.row]];
    
    //[self myDelegate];
}

- (void) myDelegate {
    [self.delegate niDropDownDelegateMethod:self];
}

-(void)dealloc {
    //    [super dealloc];
    //    [table release];
    //    [self release];
}

@end
