//
//  BangDingCardViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "BangDingCardViewController.h"
#import "CellView.h"
#import "BangDingKindOfBanKCardViewController.h"
@interface BangDingCardViewController ()

@end

@implementation BangDingCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupNewView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark -- 界面
-(void)setupNewView{
    UILabel *decLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, self.NavImg.bottom, RM_VWidth - 2*RM_Padding, 30*self.scale)];
    decLabel.text = @"请绑定持卡人本人的银行卡";
    decLabel.font = SmallFont(self.scale);
    decLabel.textColor = grayTextColor;
    [self.view addSubview:decLabel];
    
    NSArray *titleArray = @[@"持卡人",@"卡  号"];
    NSArray *placeholderArray = @[@"请输入持卡人姓名",@"请输入银行卡号"];
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
        if (i == 0) {
            [textField setMaxLength:RM_NameLength];
        }else{
            
            textField.ry_inputType = RYIntInputType;
            textField.ry_interval = 4;
            [textField setMaxLength:RM_BankCardLength];
        }
        [tiXianCell addSubview:textField];
        setY = tiXianCell.bottom;
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
#pragma mark -- 点击事件
-(void)TextFieldChange{
    UITextField *nameTextField = (UITextField *)[self.view viewWithTag:10];
    NSString *name = [nameTextField.text trimString];
    UITextField *cardNumTextField = (UITextField *)[self.view viewWithTag:11];
    NSString *cardNum = [cardNumTextField.text trimString];
    
    UIButton *nextStepButton = (UIButton *)[self.view viewWithTag:1];
    if (name.length > 0 && cardNum.length > 16) {
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

-(void)nextStepButtonEvent:(UIButton *)button{
    //姓名
    UITextField *nameLabel = (UITextField *)[self.view viewWithTag:10];
    NSString *name = [nameLabel.text trimString];
    if ([name isEmptyString]) {
        [CoreSVP showMessageInCenterWithMessage:@"请输入姓名"];
        return;
    }
    //银行卡号
    UITextField *bankCardNumLabel = (UITextField *)[self.view viewWithTag:11];
    NSString *bankCardNum = [bankCardNumLabel.text trimString];
    if (![bankCardNum isValidateBank]) {
        [CoreSVP showMessageInCenterWithMessage:@"请输入正确的银行卡账号"];
        return;
    }
    
    
    [self closeKeyboard];
    BangDingKindOfBanKCardViewController *bangDingCardKindVC = [BangDingKindOfBanKCardViewController new];
    bangDingCardKindVC.userName=name;
    bangDingCardKindVC.bankCardNum=bankCardNum;
    bangDingCardKindVC.isAdd=_isAdd;
    [self.navigationController pushViewController:bangDingCardKindVC animated:YES];
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
