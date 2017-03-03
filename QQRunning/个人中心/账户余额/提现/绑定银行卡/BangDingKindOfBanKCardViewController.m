//
//  BangDingKindOfBanKCardViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "BangDingKindOfBanKCardViewController.h"
#import "CellView.h"
#import "ZhangHuYuEViewController.h"
#import "MyBankCardViewController.h"

@interface BangDingKindOfBanKCardViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIControl *pickerControl;
@property (nonatomic,strong) UIView *pickerBgView;
@property (nonatomic,strong) UIPickerView* pickerView;

@property (nonatomic,strong) NSMutableArray *bankArray;
@property (nonatomic,strong) NSMutableArray *bankCardArray;

@property (nonatomic,strong) NSString *bankName;
@property (nonatomic,strong) NSString *bankCard;
@end

@implementation BangDingKindOfBanKCardViewController
-(NSMutableArray *)bankArray{
    if (!_bankArray) {
        _bankArray = [@[@"中国建设银行",@"中国邮政储蓄",@"中国工商银行"] mutableCopy];
    }
    return _bankArray;
}
-(NSMutableArray *)bankCardArray{
    if (!_bankCardArray) {
        _bankCardArray = [@[@"储蓄卡",@"信用卡"] mutableCopy];
    }
    return _bankCardArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupNewView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark -- 界面
-(void)setupNewView{
    UILabel *decLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, self.NavImg.bottom, RM_VWidth - 2*RM_Padding, 30*self.scale)];
    decLabel.text = @"请选择银行卡类型";
    decLabel.font = SmallFont(self.scale);
    decLabel.textColor = grayTextColor;
    [self.view addSubview:decLabel];
    
    NSArray *titleArray = @[@"卡 类 型",@"分行名称"];
    NSArray *placeholderArray = @[@"请选择银行卡类型",@"请输入支行名称"];
    float setY =decLabel.bottom;
    for (int i = 0; i < titleArray.count; i ++) {
        CellView *tiXianCell = [[CellView alloc] initWithFrame:CGRectMake(0, setY, self.view.width, 44*self.scale)];
        tiXianCell.topline.hidden = i != 0;
        [tiXianCell setShotLine:i != titleArray.count - 1 ];
        [self.view addSubview:tiXianCell];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, 0, 60*self.scale, tiXianCell.height)];
        label.font = DefaultFont(self.scale);
        label.text = titleArray[i];
        [tiXianCell addSubview:label];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(label.right, 0, tiXianCell.width - label.right - RM_Padding, tiXianCell.height)];
        textField.placeholder = placeholderArray[i];
        textField.font = DefaultFont(self.scale);
        textField.tag = 10 + i;
        [tiXianCell addSubview:textField];
        setY = tiXianCell.bottom;
        
        if (i == 0) {
//            [textField setEnabled:NO];
            textField.userInteractionEnabled=NO;
            textField.enabled=NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBankKindEvnet:)];
            tap.numberOfTapsRequired = 1;
            [tiXianCell addGestureRecognizer:tap];
            [tiXianCell.btn removeFromSuperview];
            
        }
    }
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_ButtonPadding, setY + RM_Padding*2, RM_VWidth - RM_ButtonPadding*2, RM_ButtonHeight)];
    [nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    nextStepButton.titleLabel.font = Big15Font(self.scale);
    [nextStepButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
    [nextStepButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateHighlighted];
    nextStepButton.userInteractionEnabled = NO;
    nextStepButton.layer.cornerRadius = RM_CornerRadius;
    nextStepButton.clipsToBounds = YES;
    nextStepButton.tag = 1;
    [nextStepButton addTarget:self action:@selector(nextStepButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepButton];
}

#pragma mark -- pickerView的代理事件
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.bankArray.count;
    }else{
        return self.bankCardArray.count;
    }

}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.bankArray[row];
    }else{
        return self.bankCardArray[row];
    }
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:clearColor];
        [pickerLabel setFont:Big15Font(self.scale)];
    }
    if (component == 0) {
        pickerLabel.text =self.bankArray[row];
    }else{
        pickerLabel.text = self.bankCardArray[row];
    }
    
    return pickerLabel;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40*self.scale;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return RM_VWidth/2;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.bankName  = [self.bankArray objectAtIndex:row];
    }else{
        self.bankCard  = [self.bankCardArray objectAtIndex:row];
    }
}
#pragma mark -- 点击事件
-(void)TextFieldChange{
    UITextField *nameTextField = (UITextField *)[self.view viewWithTag:10];
    NSString *name = [nameTextField.text trimString];
    UITextField *cardNumTextField = (UITextField *)[self.view viewWithTag:11];
    NSString *cardNum = [cardNumTextField.text trimString];
    
    UIButton *nextStepButton = (UIButton *)[self.view viewWithTag:1];
    if (name.length > 0 && cardNum.length > 0) {
        [nextStepButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateNormal];
        [nextStepButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateHighlighted];
        nextStepButton.userInteractionEnabled = YES;
    }else
    {
        [nextStepButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
        [nextStepButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateHighlighted];
        nextStepButton.userInteractionEnabled = NO;
    }
    
}
#pragma mark -- pickerView界面
-(void)chooseBankKindEvnet:(UITapGestureRecognizer *)tap{
    _pickerControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    _pickerControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [_pickerControl addTarget:self action:@selector(dismissViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pickerControl];
    [self datePickerView];
    [UIView animateWithDuration:.3 animations:^{
        _pickerControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _pickerBgView.bottom=RM_VHeight;
    }];
}
-(void)nextStepButtonEvent:(UIButton *)button{
    [self closeKeyboard];
    
    //卡类型
    UITextField *bankCardKindLabel = (UITextField *)[self.view viewWithTag:10];
    NSString *bankCardKind = [bankCardKindLabel.text trimString];
    if ([bankCardKind isEmptyString]) {
        [CoreSVP showMessageInCenterWithMessage:@"请选择卡类型"];
        return;
    }
    //分行名称
    UITextField *bankKaiHuHangLabel = (UITextField *)[self.view viewWithTag:11];
    NSString *bankKaiHuHang = [bankKaiHuHangLabel.text trimString];
    if ([bankKaiHuHang isEmptyString]) {
        [CoreSVP showMessageInCenterWithMessage:@"请输入分行名称"];
        return;
    }
    
    NSDictionary * dic = @{@"Name":_userName,
                           @"PeiSongId":[Stockpile sharedStockpile].userID,
                           @"BankNum":_bankCardNum,
                           @"BankType":bankCardKind,
                           @"BankKaiHu":bankKaiHuHang};
    if (_isAdd) {
        [self startDownloadDataWithMessage:nil];
        [AnalyzeObject bandingBankCardWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            if (CODE(ret)) {
                [self ShowOKAlertWithTitle:nil Message:@"银行卡绑定成功" WithButtonTitle:@"我知道了" Blcok:^{
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                }];
            }else{
                [CoreSVP showMessageInCenterWithMessage:msg];
            }
        }];
        
        
    }else{
        [self startDownloadDataWithMessage:nil];
        [AnalyzeObject changeBankCardWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            if (CODE(ret)) {
                [self ShowOKAlertWithTitle:nil Message:@"银行卡更换成功" WithButtonTitle:@"我知道了" Blcok:^{
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                }];
            }else{
                [CoreSVP showMessageInCenterWithMessage:msg];
            }
        }];
    }
//    [self ShowOKAlertWithTitle:nil Message:@"绑定成功" WithButtonTitle:@"我知道了" Blcok:^{
//        NSInteger count = [self.navigationController.viewControllers count] - 3;
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count] animated:YES];
//    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self closeKeyboard];
}
-(void)closeKeyboard{
    [self.view endEditing:YES];
}
#pragma mark -- 选择银行
-(void)datePickerView{
    _pickerBgView=[[UIView alloc]initWithFrame:CGRectMake(0, RM_VHeight, RM_VWidth, 300*self.scale)];
    _pickerBgView.backgroundColor = whiteLineColore;
    
    CellView *topMenueBgView = [[CellView alloc] initWithFrame:CGRectMake(0, 0, _pickerBgView.width, 40*self.scale)];
    topMenueBgView.backgroundColor = whiteLineColore;
    topMenueBgView.topline.hidden = NO;
    topMenueBgView.bottomline.hidden = YES;
    [_pickerBgView addSubview:topMenueBgView];
    
    //取消按钮
    UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_Padding, 0, 50*self.scale, topMenueBgView.height)];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:grayTextColor forState:UIControlStateNormal];
    cancleButton.titleLabel.font=DefaultFont(self.scale);
    [cancleButton addTarget:self action:@selector(dismissViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [topMenueBgView addSubview:cancleButton];
    //确定按钮
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(topMenueBgView.width - cancleButton.width - RM_Padding, 0, cancleButton.width , topMenueBgView.height)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:mainColor forState:UIControlStateNormal];
    confirmButton.titleLabel.font=DefaultFont(self.scale);
    [confirmButton addTarget:self action:@selector(confirmButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [topMenueBgView addSubview:confirmButton];
    //描述Label
    UILabel *decLabel = [[UILabel alloc] initWithFrame:CGRectMake(cancleButton.right, 0, confirmButton.left - cancleButton.right, topMenueBgView.height)];
    decLabel.text = @"卡类型";
    decLabel.font = DefaultFont(self.scale);
    decLabel.textColor = grayTextColor;
    decLabel.textAlignment = NSTextAlignmentCenter;
    [topMenueBgView addSubview:decLabel];
    //日期选择视图
    _pickerView = [[ UIPickerView alloc]initWithFrame:CGRectMake(0, topMenueBgView.height, _pickerBgView.width, 200*self.scale)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerBgView addSubview:_pickerView];
    _pickerBgView.height = _pickerView.height + topMenueBgView.height;
    [_pickerControl addSubview:_pickerBgView];
}
-(void)dismissViewEvent{
    self.bankName = nil;
    self.bankCard = nil;
    [UIView animateWithDuration:.3 animations:^{
        _pickerControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _pickerBgView.top=RM_VHeight;
    }completion:^(BOOL finished) {
        [_pickerControl removeFromSuperview];
        _pickerControl=nil;
        [_pickerBgView removeFromSuperview];
        _pickerBgView = nil;
    }];
}
-(void)confirmButtonEvent:(UIButton *)button{
    
    if(!self.bankName){
        self.bankName = [NSString stringWithFormat:@"%@",[self.bankArray  firstObject]];
    }
    if (!self.bankCard) {
        self.bankCard = [NSString stringWithFormat:@"%@",[self.bankCardArray  firstObject]];
    }
//    [[Stockpile sharedStockpile] setDefaultBankName:self.bankName];
//    [[Stockpile sharedStockpile] setDefaultBankCardKind:self.bankCard];
    UITextField *areaF=(UITextField *)[self.view viewWithTag:10];
    areaF.text = [NSString stringWithFormat:@"%@ %@",self.bankName ,self.bankCard];

    [self dismissViewEvent];
}

#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"绑定银行卡";
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
