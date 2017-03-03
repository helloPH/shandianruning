//
//  TiXianViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "TiXianViewController.h"
#import "CellView.h"
#warning 现在还没有绑定过银行卡这只是用于测试  待有接口时请按流程走
#import "BangDingCardViewController.h"
@interface TiXianViewController ()

@end

@implementation TiXianViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupNewView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark -- 界面
-(void)setupNewView{
    
    
    
    CellView *bankView = [[CellView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, 60*self.scale)];
    bankView.backgroundColor = whiteLineColore;
    bankView.bottomline.hidden = NO;
    bankView.tag = 20;
    bankView.hidden = YES;
    [self.view addSubview:bankView];
    
    UIImageView *bankLogo = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding, bankView.height/2 - 18*self.scale, 36*self.scale, 36*self.scale)];
    bankLogo.layer.cornerRadius = bankLogo.height/2;
    bankLogo.clipsToBounds = YES;
    bankLogo.image = [UIImage imageNamed:@"chengjiu_icon03"];
    [bankView addSubview:bankLogo];
    bankLogo.backgroundColor=mainColor;
    bankLogo.width=0;
    
    
    UILabel *bankNameLable = [[UILabel alloc] initWithFrame:CGRectMake(bankLogo.right + RM_Padding, RM_Padding, bankView.width - bankLogo.right - 2*RM_Padding, 20*self.scale)];
    bankNameLable.tag = 30;
    bankNameLable.textColor = blackTextColor;
    bankNameLable.font = DefaultFont(self.scale);
    [bankView addSubview:bankNameLable];
    
    UILabel *bankNumLable = [[UILabel alloc] initWithFrame:CGRectMake(bankNameLable.left, bankNameLable.bottom, bankNameLable.width, bankNameLable.height)];
    bankNumLable.tag = 40;
    bankNumLable.font = DefaultFont(self.scale);
    bankNumLable.textColor = grayTextColor;
    [bankView addSubview:bankNumLable];
    //moneyCell下边的视图
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom)];
    bottomBgView.tag = 50;
    bottomBgView.backgroundColor = superBackgroundColor;
    [self.view addSubview:bottomBgView];
    
    CellView *moneyCell = [[CellView alloc] initWithFrame:CGRectMake(0, RM_Padding, RM_VWidth, 40*self.scale)];
    moneyCell.titleLabel.text = @"金额";
    moneyCell.topline.hidden = NO;
    moneyCell.bottomline.hidden = NO;
    [bottomBgView addSubview:moneyCell];
    
    UITextField *moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(moneyCell.titleLabel.right, moneyCell.height/2 - 15*self.scale, moneyCell.width - moneyCell.titleLabel.right - RM_Padding , 30*self.scale)];
    moneyTextField.tag = 10;
    moneyTextField.font = DefaultFont(self.scale);
    moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTextField.placeholder = @"请输入充值金额";
    [moneyCell addSubview:moneyTextField];
    
    UILabel *yuELabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, RM_Padding + moneyCell.bottom, RM_VWidth - 2*RM_Padding, 20*self.scale)];
    
    NSInteger approveWithDraw=0;
    if (minYuE < _yuE) {
        approveWithDraw=(_yuE-minYuE)/Intergral * Intergral;
    }

    yuELabel.attributedText = [[NSString stringWithFormat:@"<main15>•</main15><black11>  账户余额%ld元，可提现金额</black11><blue13>%@</blue13><black11>元</black11>",(long)_yuE,@(approveWithDraw)] attributedStringWithStyleBook:[self Style]];
    [bottomBgView addSubview:yuELabel];
    
    UILabel *minMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(yuELabel.left, yuELabel.bottom, yuELabel.width, yuELabel.height)];
    minMoneyLabel.attributedText = [[NSString stringWithFormat:@"<main15>•</main15><black11>  账户余额不低于%@元，可提现金额为%@的整数倍</black11>",@(minYuE),@(Intergral)] attributedStringWithStyleBook:[self Style]];
    [bottomBgView addSubview:minMoneyLabel];
   
    UIButton *tiXianButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_ButtonPadding, minMoneyLabel.bottom + RM_Padding, RM_VWidth - RM_ButtonPadding*2, RM_ButtonHeight)];
    [tiXianButton setTitle:@"确认提现" forState:UIControlStateNormal];
    [tiXianButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    tiXianButton.titleLabel.font = Big15Font(self.scale);
    [tiXianButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
    [tiXianButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateHighlighted];
    tiXianButton.userInteractionEnabled = NO;
    tiXianButton.layer.cornerRadius = RM_CornerRadius;
    tiXianButton.clipsToBounds = YES;
    tiXianButton.tag = 1;
    [tiXianButton addTarget:self action:@selector(tiXianButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBgView addSubview:tiXianButton];
}
-(void)refreshView{
    CellView *bankView = (CellView *)[self.view viewWithTag:20];
//    bankView.hidden = [[Stockpile sharedStockpile].defaultBankCardNum trimString].length == 0;
    bankView.hidden=NO;
    
    UIView *bottomBgView = (UIView *)[self.view viewWithTag:50];
    if (bankView.hidden) {
        bottomBgView.frame = CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom);
    }else{
        //银行卡所属银行
        UILabel *bankNameLable = (UILabel *)[bankView viewWithTag:30];
        bankNameLable.text = _bankName;
        //银行卡号
        UILabel *bankCardNumLable = (UILabel *)[bankView viewWithTag:40];
        NSString *bankCardNum = [_bankCardNum substringFromIndex:_bankCardNum.length - 4];
        bankCardNumLable.text = [NSString stringWithFormat:@"尾号：%@",bankCardNum];
        bottomBgView.frame = CGRectMake(0, bankView.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom - bankView.height);
    }
    
}
#pragma mark -- 点击事件
-(void)TextFieldChange{
    UITextField *moneyTextField = (UITextField *)[self.view viewWithTag:10];
    NSString *money = [moneyTextField.text trimString];
    UIButton *tiXianButton = (UIButton *)[self.view viewWithTag:1];
    if (money.length > 0) {
        [tiXianButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateNormal];
        [tiXianButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateHighlighted];
        tiXianButton.userInteractionEnabled = YES;
    }else
    {
        [tiXianButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
        [tiXianButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateHighlighted];
        tiXianButton.userInteractionEnabled = NO;
    }
    
}

-(void)tiXianButtonEvent:(UIButton *)button{
    [self closeKeyboard];

    
    NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject withdrawWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            
        }else{
            
        }
        [CoreSVP showMessageInCenterWithMessage:msg];
    }];
    
    
//    BangDingCardViewController *bangDingCardVC = [BangDingCardViewController new];
//    [self.navigationController pushViewController:bangDingCardVC animated:YES];
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
    self.TitleLabel.text = @"提现";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
    
//    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.TitleLabel.right , self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
//    changeButton.right=self.NavImg.width-RM_Padding;
//    changeButton.tag = 40;
//    NSString *titleStr = [[Stockpile sharedStockpile].defaultBankCardNum trimString].length == 0 ? @"添加" :@"修改";
//    [changeButton setTitle:titleStr forState:UIControlStateNormal];
//    [changeButton setTitleColor:blackTextColor forState:UIControlStateNormal];
//    changeButton.titleLabel.font = Big15Font(self.scale);
//    [changeButton addTarget:self action:@selector(changeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:changeButton];

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
