//
//  LoginViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/23.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "ShouYeViewController.h"
#import "CellView.h"
#import "JPUSHService.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;

@end

@implementation LoginViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupNewView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)setupNewNavi{
        self.TitleLabel.text = @"账号登录";
    
    
    UIButton *registButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth-50*self.scale,self.TitleLabel.top, 40*self.scale, self.TitleLabel.height)];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    registButton.titleLabel.font=DefaultFont(self.scale);
    [registButton addTarget:self action:@selector(registButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:registButton];

}
#pragma mark -- 界面
-(void)setupNewView{
    
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight-self.NavImg.bottom)];
    _mainScrollView.backgroundColor=clearColor;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CloseKeyBoard)];
    [_mainScrollView addGestureRecognizer:tap];
    [self.view addSubview:_mainScrollView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RM_VWidth, RM_VWidth*0.41)];
    backImageView.image = [UIImage imageNamed:@"zc_bg"];
    [_mainScrollView addSubview:backImageView];
    
    CGFloat setY=backImageView.height-60*self.scale;
    for (int i = 0 ; i < 2; i ++) {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, setY, 0, 0)];
        [backImageView addSubview:label];
        
        label.textColor=blackTextColor;
        label.font=i==0?Big14Font(self.scale):Small10Font(self.scale);
        label.text=i==0?@"欢迎登录闪电跑腿跑男版":@"Wellcome to the Lightning Run errand";

        [label sizeToFit];
        label.centerX=backImageView.width/2;
        setY=label.bottom;
    }
    
    
    
    
     setY = backImageView.bottom;
    for (int i = 0; i < 2; i ++) {
        
        CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44*self.scale)];
        [_mainScrollView addSubview:Cell];
        Cell.backgroundColor=[UIColor whiteColor];
//        Cell.titleLabel.text=nameArr[i];
//        Cell.titleLabel.font=DefaultFont(self.scale);
        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake(0, 5*self.scale, Cell.width- Cell.titleLabel.right-10*self.scale, Cell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
        textF.placeholder = i == 0 ? @"请输入手机号" : @"请输入密码" ;
        textF.secureTextEntry=i==1;
        textF.tag = 10 + i;
        textF.delegate=self;
        Cell.topline.hidden = i!=0;
        [Cell setShotLine:i != 2 - 1 ];
        [Cell addSubview:textF];
        
        
        
        
        
//        UITextField *textField = [[UITextField alloc]  initWithFrame:CGRectMake(0, setY, self.view.width, 40*self.scale)];
//        textField.backgroundColor = [UIColor whiteColor];
//        textField.textColor = [UIColor blackColor];
//        textField.font = DefaultFont(self.scale);
//        textField.placeholder = i == 0 ? @"请输入手机号" : @"请输入密码" ;
//        textField.tag = 10+i;
//        textField.delegate = self;
        if (i==0) {
            [textF setMaxLength:RM_TelLength];
            textF.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            textF.secureTextEntry = YES;
            [textF setMaxLength:RM_PwdMaxLength];
        }
        UIImage *image = i == 0 ? [UIImage imageNamed:@"zc_shouji"] : [UIImage imageNamed:@"zc_mima"];
        UIImageView *leftVN = [[UIImageView alloc] initWithImage:image];
        leftVN.contentMode = UIViewContentModeCenter;
        leftVN.frame = CGRectMake(0*self.scale, 0, 35*self.scale, 35*self.scale);
        textF.leftViewMode = UITextFieldViewModeAlways;
        textF.leftView = leftVN;
        [Cell addSubview:textF];
        
        
//        UIView * line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 0.5*self.scale)];
//        line.bottom=textF.height;
//        [textF addSubview:line];
//        if (i==0) {
//            line.left=15*self.scale;
//            line.width=RM_VWidth-30*self.scale;
//        }
//        
        setY = Cell.bottom;
    }
    //登录按钮
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20*self.scale, setY+30*self.scale, self.view.width - 40*self.scale, 35*self.scale)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = RM_CornerRadius ;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = mainColor;
    [loginBtn setTitleColor:whiteLineColore forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Big15Font(self.scale);
    [loginBtn addTarget:self action:@selector(loginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:loginBtn];
//    //注册按钮
//    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginBtn.left-10*self.scale, loginBtn.bottom, 70*self.scale, 30*self.scale)];
//    [registBtn setTitle:@"免费注册" forState:UIControlStateNormal];
//    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    registBtn.titleLabel.font = DefaultFont(self.scale);
//    [registBtn addTarget:self action:@selector(registButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [_mainScrollView addSubview:registBtn];
    //忘记密码按钮
    UIButton *forgotPasswordBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginBtn.right - 65*self.scale, loginBtn.bottom, 70*self.scale, 30*self.scale)];
    [forgotPasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgotPasswordBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    forgotPasswordBtn.titleLabel.font = DefaultFont(self.scale);
    [forgotPasswordBtn addTarget:self action:@selector(forgotPasswordBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:forgotPasswordBtn];
    
    _mainScrollView.contentSize=CGSizeMake(self.view.width, loginBtn.bottom+20*self.scale);
}
#pragma mark -- 点击事件
-(void)loginButtonEvent:(UIButton *)sender
{
    [self.view endEditing:YES];
    UITextField *TextFf = (UITextField *)[self.view viewWithTag:10];
    UITextField *TextPwd = (UITextField *)[self.view viewWithTag:11];
    NSString *tel = [TextFf.text trimString];
    NSString *Pwd=[TextPwd.text trimString];
    if (![tel isValidateMobile]) {
       [CoreSVP showMessageInCenterWithMessage:@"请输入正确的手机号"];
        return;
    }
    if (Pwd.length < RM_PwdMinLength) {
        [CoreSVP showMessageInCenterWithMessage:@"请输入有效的密码"];
        return;
    }
    
    
    NSDictionary * dic=@{@"Phone":tel,@"Pwd":Pwd};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject loginWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            [[Stockpile sharedStockpile] setUserAccount:tel];
            [[Stockpile sharedStockpile] setUserPassword:Pwd];
            
            [self showTiShi:[NSString stringWithFormat:@"%@",model[@"Status"]]];
            
            if ([[NSString stringWithFormat:@"%@",model[@"Status"]] isEqualToString:@"0"]) {
                [[Stockpile sharedStockpile]setIsLogin:NO];
                return;
            }
            [self TapNextViewWith:model];
        }else{
            if (msg==nil || [msg isEmptyString]) {
              msg=[NSString stringWithFormat:@"登录失败,错误代码%@",model[@"Status"]];
            };
             [CoreSVP showMessageInCenterWithMessage:msg];
        }
       
    }];

    
    
}
-(void)showTiShi:(NSString *)status{
  
    
    
    switch ([status integerValue]) {
        case 0:
            [CoreSVP showMessageInCenterWithMessage:@"资料正在审核中，请耐心等待！"];
            break;
        case 1:
                [CoreSVP showMessageInCenterWithMessage:@"登录成功,请等待工作人员与你联系,前往闪电培训课堂"];
            break;
        case 2:
                [CoreSVP showMessageInCenterWithMessage:@"申请失败"];
            break;
        case 3:
                [CoreSVP showMessageInCenterWithMessage:@"登录成功"];
            break;
        case 4:
                [CoreSVP showMessageInCenterWithMessage:@"注册已成功，请前往完善个人资料"];
            break;
        default:
               [CoreSVP showMessageInCenterWithMessage:[NSString stringWithFormat:@"位置状态%@",status]];
         
            break;
    }
    
}
-(void)TapNextViewWith:(id)models
{

    
#pragma mark -------------------------------------- 账号信息
    
    [[Stockpile sharedStockpile] setIsLogin:YES];
    
    //  用户 资料 和 地理资料
    [[Stockpile sharedStockpile] setDefaultAddressId:[NSString stringWithFormat:@"%@",[models objectForKey:@"CityId"]]];
    [[Stockpile sharedStockpile] setUserID:[NSString stringWithFormat:@"%@",[models objectForKey:@"PeiSongId"]]];
    [[Stockpile sharedStockpile] setUserRealName:[NSString stringWithFormat:@"%@",[models objectForKey:@"Name"]]];
    [[Stockpile sharedStockpile] setUserLogo:[NSString stringWithFormat:@"%@",[models objectForKey:@"Image"]]];
    [[Stockpile sharedStockpile] setUserPhone:[NSString stringWithFormat:@"%@",[models objectForKey:@"Phone"]]];

    
    //   账户 情况
    [[Stockpile sharedStockpile] setUserYuE:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllMoney"]]];
    [[Stockpile sharedStockpile] setUserRank:[NSString stringWithFormat:@"%@",[models objectForKey:@"XingJi"]]];
    [[Stockpile sharedStockpile] setUserJiFen:[NSString stringWithFormat:@"%@",[models objectForKey:@"Jifen"]]];
    
    
    
    [[Stockpile sharedStockpile] setUserStatus:[[NSString stringWithFormat:@"%@",[models objectForKey:@"Status"]] integerValue]];
    
    [[Stockpile sharedStockpile] setIsWork:[[NSString stringWithFormat:@"%@",[models objectForKey:@"OnOff"]] boolValue]];

    //银行信息
    [[Stockpile sharedStockpile] setDefaultBankName:@""];
    [[Stockpile sharedStockpile] setDefaultBankCardNum:@""];
    [[Stockpile sharedStockpile] setDefaultBankCardKind:@""];
    
    // 订单情况
    // 总的
    [[Stockpile sharedStockpile] setUserAllOrderNum:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllOrder"]]];
    [[Stockpile sharedStockpile] setUserAllTiCheng:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllTiCheng"]]];
    [[Stockpile sharedStockpile] setUserAllJieDanJinE:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllMoney"]]];
    [[Stockpile sharedStockpile] setUserAllJuLi:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllJuLi"]]];
    
   // 今日
    [[Stockpile sharedStockpile] setUserTodayOrderNum:[NSString stringWithFormat:@"%@",[models objectForKey:@"DayOrderNum"]]];
    [[Stockpile sharedStockpile] setUserTodayShouYi:[NSString stringWithFormat:@"%@",[models objectForKey:@"DayOrderShouYi"]]];
    [[Stockpile sharedStockpile] setUserTodayLiCheng:[NSString stringWithFormat:@"%@",[models objectForKey:@"DayOrderLiCheng"]]];
    // 打开推送
    [self.appdelegate turnOnNotification];
  //

    dispatch_async(dispatch_get_main_queue(), ^{
        [[Stockpile sharedStockpile] setIsLogin:YES];
        ShouYeViewController *shouYeVC = [ShouYeViewController new];
        [self.navigationController pushViewController:shouYeVC animated:YES];
    });

}

-(void)registButtonEvent:(UIButton *)sender
{
    RegisterViewController *registVC = [RegisterViewController new];
    [self.navigationController pushViewController:registVC animated:YES];
}
-(void)forgotPasswordBtnEvent:(UIButton *)sender
{
    ForgetPasswordViewController *forgotVC = [ForgetPasswordViewController new];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

-(void)CloseKeyBoard{
    [self.view endEditing:YES];
}
#pragma mark -- 通知
-(void)keyboardChangeFrame:(NSNotification *)notification
{
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _mainScrollView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, rect.origin.y-self.NavImg.bottom);
    }];
}
-(void)TextFieldChange
{
    UITextField *phoneTextField=(UITextField *)[self.view viewWithTag:10];
    if (phoneTextField.text.length>11) {
        phoneTextField.text=[phoneTextField.text substringToIndex:11];
    }
    UITextField *passwordTextField=(UITextField *)[self.view viewWithTag:11];
    if (passwordTextField.text.length>20) {
        passwordTextField.text=[passwordTextField.text substringToIndex:20];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
}
@end
