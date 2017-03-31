//
//  RegisterViewController.m
//  SJSD
//
//  Created by 软盟 on 16/4/26.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "RegisterViewController.h"
#import "QieHuanCityViewController.h"
#import "ShenFenRenZhengViewController.h"
#import "CellView.h"
#import "YanButton.h"
#import "RegistXieYiViewController.h"
#import "ShouYeViewController.h"
#import "TextContentViewController.h"


//#import "ZhuCeXieYiViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSArray *placeholderArray;
@property (nonatomic,strong) NSArray *imageArray;

@property (nonatomic,strong)NSString *cityId;
@property (nonatomic,strong)NSString *quId;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *tel;
@property (nonatomic,strong) UIButton *agreeXieYiBtn;
@property (nonatomic,strong)NSMutableDictionary * geoDic;

@property (nonatomic,strong) QieHuanCityViewController *cityVC;

@property (nonatomic,strong)UIView *grayV;
@end

@implementation RegisterViewController
-(NSArray *)placeholderArray
{
    if (!_placeholderArray) {
        _placeholderArray = @[@"请填写手机号",@"请填写验证码",@"设置6-20位字母、数字或符号组合",@"请选择省市"];
    }
    return _placeholderArray;
}
-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = @[@"zc_shouji",@"zc_yanzhengma",@"zc_mima",@"zc_shengshi"];
    }
    return _imageArray;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupNewView];
    [self newGrayV];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"QuYuTongZhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark -- 界面
-(void)setupNewView
{
    float setY = RM_Padding+self.NavImg.bottom;
    for (int i = 0; i < self.placeholderArray.count; i ++) {
        CellView *Cell = [[CellView alloc] initWithFrame:CGRectMake(0, setY, self.view.width, 44*self.scale)];
        Cell.topline.hidden = i!=0;
        [Cell setShotLine:i != self.placeholderArray.count - 1 ];
        Cell.backgroundColor=whiteLineColore;
        
        UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, Cell.height/2-11*self.scale, 22*self.scale, 22*self.scale)];
        Img.image = [UIImage imageNamed:self.imageArray[i]];
        Img.contentMode=UIViewContentModeCenter;
        [Cell addSubview:Img];
        
        UIImageView *shuXian = [[UIImageView alloc] initWithFrame:CGRectMake(Img.right + 10*self.scale, Img.top, 0.5, Img.height)];
        shuXian.backgroundColor = blackLineColore;
        [Cell addSubview:shuXian];

        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake(shuXian.right+10*self.scale, 5*self.scale, Cell.width-shuXian.right-40*self.scale, Cell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
        textF.placeholder=_placeholderArray[i];
        textF.delegate=self;
        textF.tag=10+i;
        textF.secureTextEntry = i == 2;
        [Cell addSubview:textF];
        [self.view addSubview:Cell];
        
        if (i == 0) {
            textF.keyboardType=UIKeyboardTypeNumberPad;
            [textF setMaxLength:RM_TelLength];
            
            
//            YanButton *MSMBtn=[[YanButton alloc]initWithFrame:CGRectMake(Cell.width-110*self.scale, Cell.height/2- 50/2.25*self.scale/2, 100*self.scale, 50/2.25*self.scale)];
           YanButton *MSMBtn=  [YanButton insButtonWithFrame:CGRectMake(Cell.width-110*self.scale, Cell.height/2- 50/2.25*self.scale/2, 100*self.scale, 50/2.25*self.scale) title:@"获取验证码" time:120];
            
            
             MSMBtn.titleLabel.font=DefaultFont(self.scale);
            [MSMBtn setTitleColor:mainColor forState:UIControlStateNormal];
            MSMBtn.tag=5;
//            [MSMBtn setBackgroundImage:[UIImage setImgNameBianShen:@"yanzhenema_btn"] forState:UIControlStateNormal];
            [MSMBtn addTarget:self action:@selector(MSMButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [Cell addSubview:MSMBtn];
            textF.frame=CGRectMake(shuXian.right+10*self.scale, 5*self.scale, MSMBtn.left-Img.right-25*self.scale, Cell.height-10*self.scale);
        }else if (i == 2){
            [textF setMaxLength:RM_PwdMaxLength];
        }
        
        if(i==1)
        {
            textF.keyboardType=UIKeyboardTypeNumberPad;
            [textF setMaxLength:RM_CodeLength];
            
 
        }
        setY=Cell.bottom;
        
        if (i == _placeholderArray.count-1) {
            Cell.tag = 200;
            
            textF.hidden=YES;
            Cell.contentLabel.text=_placeholderArray[i];
            Cell.contentLabel.textColor=grayTextColor;
            Cell.contentLabel.textAlignment=NSTextAlignmentRight;
            Cell.contentLabel.right=Cell.width-50;
//            textF.userInteractionEnabled = YES;
           
//            textF.enabled=NO;
            
            [Cell ShowRight:YES];
 
            
//            UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(Cell.width - 10*self.scale - 70*self.scale, 0, Cell.width - 70*self.scale, Cell.height)];
//            addressLabel.text = @"请选择城市";
//            addressLabel.tag = 100;
//            addressLabel.textColor = grayTextColor;
//            addressLabel.userInteractionEnabled = NO;
//            addressLabel.font = DefaultFont(self.scale);
//            [Cell addSubview:addressLabel];
//            UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(addressLabel.left-20*self.scale, 12*self.scale, 20*self.scale, 20*self.scale)];
//            locationImageView.tag = 300;
//            locationImageView.image = [UIImage imageNamed:@"dl17_"];
//            [Cell addSubview:locationImageView];
//          
            UIButton *chooseCityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Cell.width, Cell.height)];
            chooseCityBtn.backgroundColor = clearColor;
            [chooseCityBtn addTarget:self action:@selector(chooseCityBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            [Cell addSubview:chooseCityBtn];
        }
    }
    
    UIImageView *bottomLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 0.5)];
    bottomLine.backgroundColor=blackLineColore;
    [self.view addSubview:bottomLine];
    
    
    //同意来吧送货服务天款和声明
    _agreeXieYiBtn = [[UIButton alloc] initWithFrame:CGRectMake(10*self.scale, bottomLine.bottom+15*self.scale, 20*self.scale, 20*self.scale)];
    _agreeXieYiBtn.selected = YES;
    [_agreeXieYiBtn setImage:[UIImage imageNamed:@"tongyi"] forState:UIControlStateSelected];
    [_agreeXieYiBtn setImage:[UIImage imageNamed:@"choose_04"] forState:UIControlStateNormal];

    _agreeXieYiBtn.titleLabel.font = SmallFont(self.scale);
    [_agreeXieYiBtn setTitle:@"我同意并接受" forState:UIControlStateNormal];
    [_agreeXieYiBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    
    
    [_agreeXieYiBtn addTarget:self action:@selector(TYSMBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_agreeXieYiBtn sizeToFit];
    
    
    
    [self.view addSubview:_agreeXieYiBtn];
    
    UIButton *xieYiBtn = [[UIButton alloc] initWithFrame:CGRectMake(_agreeXieYiBtn.right+2*self.scale, _agreeXieYiBtn.top, 200*self.scale, _agreeXieYiBtn.height)];
    [xieYiBtn setTitle:@"《闪电飞侠服务条款》" forState:UIControlStateNormal];
    xieYiBtn.titleLabel.font = SmallFont(self.scale);
    [xieYiBtn setTitleColor:blueTextColor forState:UIControlStateNormal];
    [xieYiBtn addTarget:self action:@selector(xieYiButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieYiBtn];
    [xieYiBtn sizeToFit];
    xieYiBtn.centerY=_agreeXieYiBtn.centerY;

    
    
    UIButton *RegisterBtn=[[UIButton alloc]initWithFrame:CGRectMake(RM_ButtonPadding, _agreeXieYiBtn.bottom+10*self.scale, self.view.width-RM_ButtonPadding*2, RM_ButtonHeight)];
    [RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    RegisterBtn.backgroundColor = blackLineColore;
    RegisterBtn.layer.cornerRadius = RM_CornerRadius;
    RegisterBtn.clipsToBounds = YES;
    RegisterBtn.tag=7;
//    RegisterBtn.userInteractionEnabled = NO;
    [RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RegisterBtn.titleLabel.font=Big15Font(self.scale);
    [RegisterBtn addTarget:self action:@selector(RegisterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RegisterBtn];
  }
#pragma mark -- 点击事件
-(void)MSMButtonEvent:(YanButton *)button
{
    [self.view endEditing:YES];
    UITextField *telText=(UITextField *)[self.view viewWithTag:10];
    NSString *tel=[telText.text trimString];
    UITextField *yanText=(UITextField *)[self.view viewWithTag:11];
    
    if (![tel isValidateMobile]){
        [CoreSVP showMessageInCenterWithMessage:@"请输入正确的手机号"];
        return;
    }
    NSDictionary * dic = @{@"phone":tel,@"type":@"0"};
    
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getVerifyCodeWithDic:dic WithBlock:^(id model, NSString *ret,NSString *msg){
        [self stopDownloadData];
    
        if (CODE(ret)) {
            [button startTimer];
            _code=[model[@"vilidCode"] getValiedString];
            button.code=[model[@"vilidCode"] getValiedString];
//            yanText.text=[model[@"vilidCode"] getValiedString];
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        }
    }];
    
}

-(void)RegisterButtonEvent:(UIButton *)button
{
    [self.view endEditing:YES];

    //手机号
    UITextField *telText=(UITextField *)[self.view viewWithTag:10];
    NSString *tel=[telText.text trimString];
    if (![tel isValidateMobile]){
        [CoreSVP showMessageInCenterWithMessage:@"请输入正确的手机号"];
        return;
    }
//    //验证码
//    UITextField *codeText=(UITextField *)[self.view viewWithTag:11];
//    NSString *telcode=[codeText.text trimString];
//    if (![telcode isEqualToString:_code] || telcode.length!=RM_CodeLength) {
//        [CoreSVP showMessageInCenterWithMessage:@"请输入正确的验证码"];
//        return;
//    }
    //密码
    UITextField *PwdText=(UITextField *)[self.view viewWithTag:12];
    NSString *pwd=[PwdText.text trimString];
    if (pwd.length<RM_PwdMinLength) {
       [CoreSVP showMessageInCenterWithMessage:@"设置6-20位字母、数字或符号组合"];
        return;
    }
//    UILabel *addrText = (UILabel *)[self.view viewWithTag:100];
//    NSString *addr = [addrText.text trimString];
//    if ([addr isEqualToString:@"请选择城市"]) {
//        [CoreSVP showMessageInCenterWithMessage:@"请选择城市"];
//        return;
//    }
    
    
    NSDictionary * dic=@{@"Phone":tel,
                         @"Pwd":pwd,
                         @"CityId":_quId,
//                         @"Longtitude":@"",
//                         @"Latitude":@""
                         };
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject registWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
    
        if (CODE(ret)) {
            NSDictionary * dic=@{@"Phone":tel,@"Pwd":pwd};
            [self startDownloadDataWithMessage:nil];
            [AnalyzeObject loginWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopDownloadData];
                if (CODE(ret)) {
                    [[Stockpile sharedStockpile] setUserAccount:tel];
                    [[Stockpile sharedStockpile] setUserPassword:pwd];
                    [[Stockpile sharedStockpile] setUserID:[NSString stringWithFormat:@"%@",[model objectForKey:@"PeiSongId"]]];
                }else{
                    [CoreSVP showMessageInCenterWithMessage:msg];
                }
                
            }];
            
            ShenFenRenZhengViewController *VC = [ShenFenRenZhengViewController new];
            VC.ID=[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].userID];
            VC.biaoJi=0;
            [self.navigationController pushViewController:VC animated:YES];
            
            
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        }
    }];
}
-(void)TYSMBtnEvent:(UIButton *)button
{
    button.selected = !button.selected;
    //手机号
    UITextField *phoneTextField=(UITextField *)[self.view viewWithTag:10];
    NSString *phone = [phoneTextField.text trimString];
    //验证码
    UITextField *codeTextField=(UITextField *)[self.view viewWithTag:11];
    NSString *code = [codeTextField.text trimString];
    //密码
    UITextField *passwordTextField=(UITextField *)[self.view viewWithTag:12];
    NSString *password = [passwordTextField.text trimString];
    //所在城市
//    UILabel *TextAddr = (UILabel *)[self.view viewWithTag:100];
    //注册按钮
    UIButton *registBtn=(UIButton *)[self.view viewWithTag:7];
    
    //&& ![TextAddr.text isEqualToString:@"请选择城市"]
    if (_agreeXieYiBtn.selected) {
        if (phone.length == RM_TelLength && code.length==RM_CodeLength && password.length>=RM_PwdMinLength ) {
            registBtn.backgroundColor = mainColor;
            registBtn.userInteractionEnabled=YES;
        }else{
            registBtn.backgroundColor = blackLineColore;
            registBtn.userInteractionEnabled=NO;
        }
    }
    else
    {
        registBtn.backgroundColor = blackLineColore;
        registBtn.userInteractionEnabled=NO;
    }
    
}
-(void)xieYiButtonEvent:(UIButton *)button
{
    [self.navigationController pushViewController:[TextContentViewController insWithTitle:@"注册协议" parameter:@"1" type:ContentTypeWeb] animated:YES];
}
-(void)chooseCityBtnEvent:(UIButton *)button
{
    [self ColseKeyboard];
    if (_cityVC) {
        [_cityVC.view removeFromSuperview];
        _cityVC = nil;
    }
    
    _cityVC = [[QieHuanCityViewController  alloc] init];
    _cityVC.view.left = self.view.width;
    
    
    
//    __block RegisterViewController * weakSelf = self;
//    _cityVC.block=^(NSString * city){
//        //所在城市
//        UITextField *TextF = (UITextField *)[weakSelf.view viewWithTag:13];
//        TextF.text=city;
//        
//        
//        
//    };
    [self.view addSubview:_cityVC.view];
    
    [UIView animateWithDuration:.3 animations:^{
        _grayV.alpha = 1;
        _cityVC.view.left = 44*self.scale;
        
    }];
    
}
#pragma mark --  textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self ColseKeyboard];
    return YES;
}
-(void)ColseKeyboard{
    [self.view endEditing:YES];
}
- (void)newGrayV{
    
    if (_grayV) {
        [_grayV removeFromSuperview];
    }
    
    _grayV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height )];
    _grayV.alpha = 0;
    _grayV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    [self.view addSubview:_grayV];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShouShi:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_grayV addGestureRecognizer:singleRecognizer];
}

- (void)ShouShi:(UITapGestureRecognizer *)ShouShi{
    
    [UIView animateWithDuration:.3 animations:^{
        
        _grayV.alpha = 0;
        _cityVC.view.left = self.view.right;
    }];
}
#pragma mark -- 通知
- (void)tongzhi:(NSNotification *)text{
    NSLog(@"text  %@",text);
    NSLog(@"object:%@",text.object);
    NSLog(@"info:%@",text.userInfo);
    
    _cityId = [NSString stringWithFormat:@"%@",text.object[@"id"]];
    _quId = [NSString stringWithFormat:@"%@",text.userInfo[@"id"]];
    
    if (!_geoDic) {
        _geoDic = [NSMutableDictionary dictionary];
    }
    [_geoDic removeAllObjects];
    [_geoDic setObject:text.object forKey:@"province"];
    [_geoDic setObject:text.userInfo forKey:@"city"];
    
    NSLog(@"_geoDic  %@",_geoDic);
    if (_cityVC) {
        _grayV.alpha = 0;
        [_cityVC.view removeFromSuperview];
        _cityVC = nil;
    }
    
    //获取最后一个cell
    CellView *cell = (CellView *)[self.view viewWithTag:200];
    //创建一个Label用于计算字符串的长度
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 20*self.scale, 20)];
    label.font = DefaultFont(self.scale);
    label.text = [NSString stringWithFormat:@"%@  %@",text.object[@"name"],text.userInfo[@"name"]];
    label.numberOfLines = 0;
    [label sizeToFit];
    
    NSLog(@"label  %f",label.width);
    
    //获取区域标签
    UILabel *lab = (UILabel *)[self.view viewWithTag:100];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:300];
    
    NSLog(@"lab    %f",lab.width);
    if (lab.width != label.width) {
        lab.frame = CGRectMake(cell.width - 10*self.scale - label.width, 0, label.width, cell.height);
        lab.textColor = blackTextColor;
        imageView.frame = CGRectMake(lab.left-20*self.scale, 12*self.scale, 20*self.scale, 20*self.scale);
    }
    lab.text = [NSString stringWithFormat:@"%@  %@",text.object[@"name"],text.userInfo[@"name"]];
    
    
    
    UIButton *registBtn=(UIButton *)[self.view viewWithTag:7];
    if ([label.text isEqualToString:@"请选择省市"]) {
        registBtn.enabled = NO;
    }
    else
    {
        registBtn.enabled = YES;
        cell.contentLabel.textColor=blackTextColor;
        cell.contentLabel.text=[NSString stringWithFormat:@"%@ %@",(text.object)[@"name"],(text.userInfo)[@"name"]];
    }
    
}
-(void)TextFieldChange{
    
    
    //手机号
    UITextField *phoneTextField=(UITextField *)[self.view viewWithTag:10];
    NSString *phone = [phoneTextField.text trimString];
    //验证码
    UITextField *codeTextField=(UITextField *)[self.view viewWithTag:11];
    NSString *code = [codeTextField.text trimString];
    //密码
    UITextField *passwordTextField=(UITextField *)[self.view viewWithTag:12];
    NSString *password = [passwordTextField.text trimString];
    //所在城市
//    UILabel *TextAddr = (UILabel *)[self.view viewWithTag:100];
  //&& ![TextAddr.text isEqualToString:@"请选择城市"]
    UIButton *registBtn=(UIButton *)[self.view viewWithTag:7];
    
    if (phone.length == RM_TelLength && code.length==RM_CodeLength && password.length>=RM_PwdMinLength && _agreeXieYiBtn.selected ) {
        registBtn.backgroundColor = mainColor;
        registBtn.userInteractionEnabled=YES;
    }else{
        registBtn.backgroundColor = blackLineColore;
        registBtn.userInteractionEnabled=NO;
    }
    
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"注册";
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
