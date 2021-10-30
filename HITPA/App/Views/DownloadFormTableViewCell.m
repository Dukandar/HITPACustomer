//
//  DownloadFormTableViewCell.m
//  HITPA
//
//  Created by Selma D. Souza on 28/07/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import "DownloadFormTableViewCell.h"
#import "Configuration.h"
#import "Constants.h"
//#import "KeyboardHelper.h"

NSString *  const kDownloadFormReuseIdentifier    = @"formCell";

@implementation DownloadFormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath emailTxt:(NSString *)emailTxt delegate:(id<downloadFormTableViewCell>)delegate
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDownloadFormReuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = delegate;
        [self createFormListViewWithIndexPath:indexPath emailTxt:emailTxt];
    }
    return self;
}

- (void)createFormListViewWithIndexPath:(NSIndexPath *)indexPath emailTxt:(NSString *)emailTxt
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 5.0;
    CGFloat height = 40.0;
    CGFloat width = frame.size.width;
    UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMain.backgroundColor = [UIColor clearColor];
    viewMain.tag = indexPath.section;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:viewMain];
    
    xPos   = 10.0;
    yPos   = 7.0;
    width  = (frame.size.width * 0.6) - (2 * xPos);
    height = viewMain.frame.size.height - 5.0;
    UITextField *textField  = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [textField setFont:[[Configuration shareConfiguration] hitpaFontWithSize:14.0]];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"Enter Email Id";
    if (![emailTxt isEqualToString:@""]) {
        textField.text = emailTxt;
    }
    [viewMain addSubview:textField];
    textField.tag = indexPath.section;
    textField.delegate = self;
    [textField.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [textField.layer setBorderWidth:0.5];
    [textField.layer setCornerRadius:5.0];
    [textField.layer setMasksToBounds:YES];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, textField.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    
    xPos = textField.frame.origin.x + textField.frame.size.width + 10.0;
    width = (frame.size.width * 0.4) - 10.0;
    UIButton *sendButton = [self createButtonWithFrame:CGRectMake(xPos, yPos, width, height) title:NSLocalizedString(@"Send", @"")];
    sendButton.tag = indexPath.section;
    [sendButton addTarget:self action:@selector(sendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [viewMain addSubview:sendButton];
    
}

- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button.titleLabel setFont:[[Configuration shareConfiguration]hitpaFontWithSize:16.0]];
    button.layer.cornerRadius = 4.0;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOpacity = 0.5;
    button.layer.shadowRadius = 2;
    button.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    return button;
    
}

- (void)sendButtonTapped:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(emailPdf:)])
    {
        [self.delegate emailPdf:sender.tag];
        UITextField *textField = (UITextField *)self.contentView.superview;
        textField.text = @"";
    }
}


#pragma mark - Textfield Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [[KeyboardHelper sharedKeyboardHelper]animateTextField:textField isUp:YES View:textField.superview.superview.superview.superview.superview.superview];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [[KeyboardHelper sharedKeyboardHelper]animateTextField:textField isUp:NO View:textField.superview.superview.superview.superview.superview.superview];
    if ([self.delegate respondsToSelector:@selector(updateEnteredEmailID:section:)])
    {
        [self.delegate updateEnteredEmailID:textField.text section:textField.tag];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
