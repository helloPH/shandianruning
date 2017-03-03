//
//  ForgetPasswordViewController.m
//  拼妈
//
//  Created by 软盟 on 16/3/7.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "CellView.h"
#import "YanButton.h"

@interface ForgetPasswordViewController()<UITextFieldDelegate>
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *tel;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@end
@implementation ForgetPasswordViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupNewNavi];
    [self setupNewView];
    
    /*监听TextField的变化*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


#pragma mark -- 界面
-(void)setupNewView{
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mainScrollView.backgroundColor = clearColor;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ColseKeyboard)];
    [_mainScrollView addGestureRecognizer:tap];
    [self.view addSubview:_mainScrollView];
    float SetY=RM_Padding;
    NSArray *nameArr = @[@"手机号",@"验证码",@"新密码",@"确认密码"];
    NSArray *Arr=@[@"请输入注册时使用的手机号",@"请输入验证码",@"设置6-20位字母，数字或符号组合",@"请重复输入密码"];
    for (int i=0; i<Arr.count; i++)
    {
        CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, SetY, self.view.width, 44*self.scale)];
        Cell.backgroundColor=[UIColor whiteColor];
        Cell.titleLabel.text=nameArr[i];
        Cell.titleLabel.font=DefaultFont(self.scale);
        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake( Cell.titleLabel.right, 5*self.scale, Cell.width- Cell.titleLabel.right-10*self.scale, Cell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
        textF.placeholder=Arr[i];
        textF.secureTextEntry=(i==2 || i==3);
        textF.tag = 10 + i;
        textF.delegate=self;
        Cell.topline.hidden = i!=0;
        [Cell setShotLine:i != Arr.count - 1 ];
        [Cell addSubview:textF];
        if (i == 0) {
            [textF setMaxLength:RM_TelLength];
            textF.keyboardType = UIKeyboardTypeNumberPad;
        }else if (i == 1){
            [textF setMaxLength:RM_CodeLength];
            textF.keyboardType = UIKeyboardTypeNumberPad;
            
            
            
            YanButton * MSMBtn=[YanButton insButtonWithFrame:CGRectMake(Cell.width-110*self.scale, Cell.height/2- 50/2.25*self.scale/2, 100*self.scale, 50/2.25*self.scale) title:@"获取验证码" time:120];
            MSMBtn.titleLabel.font=DefaultFont(self.scale);
            [MSMBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [MSMBtn setTitleColor:matchColor forState:UIControlStateNormal];
            MSMBtn.tag = 5;

            [MSMBtn addTarget:self action:@selector(getYZM:) forControlEvents:UIControlEventTouchUpInside];
            [Cell addSubview:MSMBtn];
            
            textF.frame=CGRectMake(Cell.titleLabel.right, 5*self.scale, MSMBtn.left-Cell.titleLabel.right-25*self.scale, Cell.height-10*self.scale);
        }else{
            [textF setMaxLength:RM_PwdMaxLength];
        }
        
        [_mainScrollView addSubview:Cell];
        SetY=Cell.bottom;
    }
    
    UIButton *foundButton=[[UIButton alloc]initWithFrame:CGRectMake(RM_ButtonPadding, SetY+10*self.scale, RM_VWidth - RM_ButtonPadding*2, RM_ButtonHeight)];
    foundButton.backgroundColor = blackLineColore;
    [foundButton setTitle:@"提交" forState:UIControlStateNormal];
    [foundButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    foundButton.titleLabel.font=Big15Font(self.scale);
    foundButton.layer.cornerRadius = RM_CornerRadius;
    foundButton.clipsToBounds = YES;
    foundButton.userInteractionEnabled=NO;
    foundButton.tag = 7;
    [foundButton addTarget:self action:@selector(foundButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:foundButton];
    _mainScrollView.contentSize=CGSizeMake(self.view.width, foundButton.bottom+15*self.scale);
}
#pragma mark - 按钮事件
/*获取验证码*/
-(void)getYZM:(YanButton *)sender{
    [self.view endEditing:YES];
    UITextField *telText=(UITextField *)[self.view viewWithTag:10];
    
    UITextField *yanText=(UITextField *)[self.view viewWithTag:11];
    NSString *tel=[telText.text trimString];
    if (![tel isValidateMobile])
    {
        [CoreSVP showMessageInCenterWithMessage:@"请输入有效的手机号"];
        return;
    }
    NSDictionary * dic=@{@"phone":tel,
                         @"type":@"1"};
    [self startDownloadDataWithMessage:nil];
   [AnalyzeObject getVerifyCodeWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
       [self stopDownloadData];
       if (CODE(ret)) {
           _code=model[@"vilidCode"];
           [sender startTimer];
            yanText.text=model[@"vilidCode"];
       }else{
           [CoreSVP showMessageInCenterWithMessage:msg];
       }
   }];
    
}

/*重置密码事件*/
-(void)foundButtonEvent:(id)sender{
    [self.view endEditing:YES];
    
    //手机
    UITextField *telText=(UITextField *)[self.view viewWithTag:10];
    NSString *tel=[telText.text trimString];
    if (![tel isValidateMobile])
    {
        [CoreSVP showMessageInCenterWithMessage:@"请输入有效的手机号"];
        return;
    }
    //验证码
    UITextField *codeText=(UITextField *)[self.view viewWithTag:11];
    NSString *telcode=[codeText.text trimString];
    if (![telcode isEqualToString:_code] || telcode.length<1) {
        [CoreSVP showMessageInCenterWithMessage:@"输入验证码有误"];
        return;
    }
    //新密码
    UITextField *NPwdText=(UITextField *)[self.view viewWithTag:12];
    UITextField *RPwdText=(UITextField *)[self.view viewWithTag:13];
    NSString *nPwd=[NPwdText.text trimString];
    NSString *rPwd = [RPwdText.text trimString];
    if (nPwd.length < RM_PwdMinLength || rPwd.length < RM_PwdMinLength) {
        [CoreSVP showMessageInCenterWithMessage:@"密码格式错误"];
        return;
    }
    if(![rPwd isEqualToString:nPwd]) {
        [CoreSVP showMessageInCenterWithMessage:@"两次密码不一致"];
        return;
    }
    
    NSDictionary * dic = @{@"Phone":tel,
                           @"NewPwd":nPwd};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject findPassWordWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
        [CoreSVP showMessageInCenterWithMessage:msg];
    }];
    

}

#pragma mark - TextField
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self ColseKeyboard];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self ColseKeyboard];
    return YES;
}
-(void)ColseKeyboard{
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
-(void)TextFieldChange{
    
    //手机号
    UITextField *TextFf=(UITextField *)[self.view viewWithTag:10];
    NSString *tel=[TextFf.text trimString];
    //验证码
    UITextField *TextCode=(UITextField *)[self.view viewWithTag:11];
    NSString *code = [TextCode.text trimString];
    //密码
    UITextField *TextPwd=(UITextField *)[self.view viewWithTag:12];
    NSString *nPwd = [TextPwd.text trimString];
    //新密码
    UITextField *TextRPwd=(UITextField *)[self.view viewWithTag:13];
    NSString *rPwd = [TextRPwd.text trimString];
    
    UIButton *LoginBtn=(UIButton *)[self.view viewWithTag:7];
    if (tel.length == RM_TelLength && code.length == RM_CodeLength && nPwd.length>=RM_PwdMinLength && rPwd.length>=RM_PwdMinLength) {
        LoginBtn.userInteractionEnabled=YES;
        LoginBtn.backgroundColor = mainColor;
    }else{
        LoginBtn.userInteractionEnabled=NO;
        LoginBtn.backgroundColor = blackLineColore;
    }
    
}

#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"设置";
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
