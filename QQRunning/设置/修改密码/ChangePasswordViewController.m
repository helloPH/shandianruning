//
//  ChangePasswordViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CellView.h"
@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *contentArray;
@end

@implementation ChangePasswordViewController
-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"旧密码",@"新密码",@"重复新密码"];
    }
    return _titleArray;
}
-(NSArray *)contentArray{
    if (!_contentArray) {
        _contentArray = @[@"请输入旧密码",@"请输入新密码",@"请重复输入新密码"];
    }
    return _contentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupNewView];

}
-(void)setupNewView{
    float setY = self.NavImg.bottom;
    for (int i = 0; i < self.titleArray.count; i ++) {
        CellView *cell = [[CellView alloc] initWithFrame:CGRectMake(0, setY, RM_VWidth, RM_CellHeigth)];
        cell.titleLabel.text = self.titleArray[i];
        [cell setShotLine:i != self.titleArray.count - 1];
        if (i == self.contentArray.count - 1) {
            cell.bottomline.hidden = NO;
        }
        [self.view addSubview:cell];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(cell.titleLabel.right+RM_Padding, 0, cell.width - cell.titleLabel.right, cell.height)];
        textField.placeholder = self.contentArray[i];
        textField.keyboardType=UIKeyboardTypeAlphabet;
        textField.tag = 10+i;
        textField.delegate=self;
        textField.font = DefaultFont(self.scale);
        [textField setMaxLength:RM_PwdMaxLength];
        [cell addSubview:textField];
        setY = cell.bottom;
    }
    
    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_ButtonPadding, setY + 30*self.scale, RM_VWidth - RM_ButtonPadding*2, RM_ButtonHeight)];
    [changeButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [changeButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    changeButton.titleLabel.font = Big15Font(self.scale);
    [changeButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
    [changeButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateHighlighted];
    changeButton.userInteractionEnabled = NO;
    
    changeButton.layer.cornerRadius = RM_CornerRadius;
    changeButton.clipsToBounds = YES;
    changeButton.tag = 1;
    [changeButton addTarget:self action:@selector(changePasswordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
}
#pragma mark -- 点击事件
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * currentText =[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    UITextField *oldPasswordTextField = (UITextField *)[self.view viewWithTag:10];
    UITextField *newPasswordTextField = (UITextField *)[self.view viewWithTag:11];
    UITextField *reNewPasswordTextField = (UITextField *)[self.view viewWithTag:12];
    
    
    
    NSString *oldPwd = [oldPasswordTextField.text trimString];
    NSString *newPwd = [newPasswordTextField.text trimString];
    NSString *reNewPwd = [reNewPasswordTextField.text trimString];
    
    switch (textField.tag) {
        case 10:
            oldPwd=currentText;
            break;
        case 11:
            newPwd=currentText;
            break;
        case 12:
            reNewPwd=currentText;
            break;
        default:
            break;
    }
    
    
    UIButton *changeButton = (UIButton *)[self.view viewWithTag:1];
    if (oldPwd.length == 0 || newPwd.length == 0 || reNewPwd.length == 0) {
        [changeButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
        [changeButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateHighlighted];
        changeButton.userInteractionEnabled = NO;
    }else
    {
        [changeButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateNormal];
        [changeButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateHighlighted];
        changeButton.userInteractionEnabled = YES;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITextField *oldPasswordTextField = (UITextField *)[self.view viewWithTag:10];
    UITextField *newPasswordTextField = (UITextField *)[self.view viewWithTag:11];
    UITextField *reNewPasswordTextField = (UITextField *)[self.view viewWithTag:12];
    NSString *oldPwd = [oldPasswordTextField.text trimString];
    NSString *newPwd = [newPasswordTextField.text trimString];
    NSString *reNewPwd = [reNewPasswordTextField.text trimString];
    
    UIButton *changeButton = (UIButton *)[self.view viewWithTag:1];
    if (oldPwd.length == 0 || newPwd.length == 0 || reNewPwd.length == 0) {
        [changeButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
        [changeButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateHighlighted];
        changeButton.userInteractionEnabled = NO;
    }else
    {
        [changeButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateNormal];
        [changeButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateHighlighted];
        changeButton.userInteractionEnabled = YES;
    }

}

-(void)changePasswordButtonEvent:(UIButton *)button{
    [self closeKeyboard];
    
    UITextField *oldPasswordTextField = (UITextField *)[self.view viewWithTag:10];
    UITextField *newPasswordTextField = (UITextField *)[self.view viewWithTag:11];
    UITextField *reNewPasswordTextField = (UITextField *)[self.view viewWithTag:12];
    NSString *oldPwd = [oldPasswordTextField.text trimString];
    NSString *newPwd = [newPasswordTextField.text trimString];
    NSString *reNewPwd = [reNewPasswordTextField.text trimString];
    if (![newPwd isEqualToString:reNewPwd]) {
        [CoreSVP showMessageInCenterWithMessage:@"两次输入的密码不一样"];
        return;
    }
    
    NSDictionary * dic =@{@"PeiSongId":[Stockpile sharedStockpile].userID,
                          @"OldPwd":oldPwd,
                          @"NewPwd":newPwd};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject updatePasswordWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
         [CoreSVP showMessageInCenterWithMessage:msg];
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self closeKeyboard];
}
-(void)closeKeyboard{
    [self.view endEditing:YES];
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"修改密码";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
