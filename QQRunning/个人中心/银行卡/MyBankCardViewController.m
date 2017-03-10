//
//  MyBankCardViewController.m
//  QQRunning
//
//  Created by 软盟 on 2017/1/4.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "BangDingCardViewController.h"
#import "CellView.h"

@interface MyBankCardViewController ()
@property (nonatomic,strong)CellView  *bankCardBgView;
@property (nonatomic,strong)UIButton  * manageBtn;


@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong) UIView *maskView;
@end

@implementation MyBankCardViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupNewNavi];
    [self setupNewView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
       [self reshData];
}
-(void)initData{
    _dataDic=[NSMutableDictionary dictionary];
}
-(void)reshData{
    NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID};
    [self startDownloadDataWithMessage:nil];
    
    [AnalyzeObject getBankCardInfoWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        [_dataDic removeAllObjects];
        if (CODE(ret)) {
            [_dataDic addEntriesFromDictionary:model];
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        }
        [self refreshView];
    }];
    
}
-(void)setupNewView{
    //银行卡视图
    _bankCardBgView = [[CellView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom)];
    _bankCardBgView.hidden = YES;
    _bankCardBgView.backgroundColor = clearColor;
    [self.view addSubview:_bankCardBgView];

    
    UIImageView  *bankCardView = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding, RM_Padding, _bankCardBgView.width - 2*RM_Padding, 80*self.scale)];
    bankCardView.backgroundColor = mainColor;
    bankCardView.image=[UIImage imageNamed:@"bg_yhk"];
    bankCardView.layer.cornerRadius = RM_CornerRadius;
    bankCardView.clipsToBounds = YES;
    [_bankCardBgView addSubview:bankCardView];
    
    UIImageView * kuijie = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20*self.scale, 45, 10)];
    kuijie.image=[UIImage imageNamed:@"biaoqian"];
    kuijie.contentMode=UIViewContentModeCenter;
    [bankCardView addSubview:kuijie];
    kuijie.right=bankCardView.width-10*self.scale;
    
    UIImageView * cardLogo=[[UIImageView alloc]initWithFrame:CGRectMake(RM_Padding, RM_Padding, 36*self.scale, 36*self.scale)];
    [bankCardView addSubview:cardLogo];
    cardLogo.backgroundColor=[UIColor lightGrayColor];
    cardLogo.layer.cornerRadius=cardLogo.height/2;
    cardLogo.layer.masksToBounds=YES;
    [cardLogo setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    cardLogo.width=30*self.scale;
    cardLogo.hidden=YES;
    
    
    UILabel *cardNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardLogo.right+RM_Padding, RM_Padding*2, bankCardView.width - RM_Padding*3-cardLogo.right, 20*self.scale)];
    cardNameLabel.tag = 10;
    cardNameLabel.font = Big17Font(self.scale);
    cardNameLabel.textColor = whiteLineColore;
    [bankCardView addSubview:cardNameLabel];
    
    UILabel *cardKindLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardNameLabel.left, cardNameLabel.bottom, cardNameLabel.width, cardNameLabel.height)];
    cardKindLabel.tag = 20;
    cardKindLabel.font = DefaultFont(self.scale);
    cardKindLabel.textColor = whiteLineColore;
    [bankCardView addSubview:cardKindLabel];
    
    UILabel *cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardKindLabel.left, cardKindLabel.bottom+20*self.scale, cardKindLabel.width, cardKindLabel.height)];
    cardNumLabel.tag = 30;
    cardNumLabel.font = Big17Font(self.scale);
    cardNumLabel.textColor = whiteLineColore;
    [bankCardView addSubview:cardNumLabel];
    bankCardView.height=cardNumLabel.bottom+20*self.scale;
    
    //默认视图
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom)];
    _maskView.backgroundColor = clearColor;
    [self.view addSubview:_maskView];
    
    CellView * defaultCell = [[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale, RM_VWidth, 50*self.scale)];
    [_maskView addSubview:defaultCell];
    [defaultCell ShowRight:YES];
    [defaultCell.btn addTarget:self action:@selector(addBankCardEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * leftbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [defaultCell addSubview:leftbtn];
    
    leftbtn.userInteractionEnabled=NO;
    leftbtn.titleLabel.font=DefaultFont(self.scale);
    [leftbtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    
    [leftbtn setTitle:@" 添加银行卡" forState:UIControlStateNormal];
    [leftbtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [leftbtn sizeToFit];
    leftbtn.left=10*self.scale;
    leftbtn.centerY=defaultCell.height/2;
    
}
-(void)addBankCardEvent:(UIButton *)sender{
    BangDingCardViewController * add=[BangDingCardViewController new];
    add.isAdd=YES;
    [self.navigationController pushViewController:add animated:YES];
}
-(void)refreshView{
    NSString * cardNum = [[NSString stringWithFormat:@"%@",_dataDic[@"BankNum"]] getValiedString];
    _bankCardBgView.hidden = [cardNum trimString].length == 0;
    _manageBtn.hidden=_bankCardBgView.hidden;
    _maskView.hidden = !_bankCardBgView.hidden;

    if (!_bankCardBgView.hidden) {
        //银行卡名字
        UILabel *cardNameLabel = (UILabel *)[self.view viewWithTag:10];
        cardNameLabel.text = [[NSString stringWithFormat:@"%@",_dataDic[@"BankType"]] getValiedString];
        //银行卡类型
        UILabel *cardKindLabel = (UILabel *)[self.view viewWithTag:20];
        cardKindLabel.text = [[NSString stringWithFormat:@"%@",_dataDic[@"BankKaiHu"]] getValiedString];
        //银行卡号
        UILabel *cardNumLabel = (UILabel *)[self.view viewWithTag:30];
        
        
        NSString * bankNum=[NSString stringWithFormat:@"%@",_dataDic[@"BankNum"]];
        NSString *bankCardNum = [bankNum substringFromIndex:bankNum.length - 4];
        
        cardNumLabel.text = [NSString stringWithFormat:@"**** **** **** %@",bankCardNum];
    }
    //修改button的title
//    UIButton *changeButton = (UIButton *)[self.NavImg viewWithTag:40];
//    NSString *titleStr = [[Stockpile sharedStockpile].defaultBankCardNum trimString].length == 0 ? @"添加" :@"修改";
//    [changeButton setTitle:titleStr forState:UIControlStateNormal];
    
}
-(void)changeButtonEvent:(UIButton *)button{
    [PHPopBox showSheetWithButtonStyles:@[[ControlStyle insWithTitle:@"删除" andColor:nil],
                                          [ControlStyle insWithTitle:@"更换银行卡" andColor:nil]] block:^(NSInteger index) {
                                              if (index==0) {//删除
                                                  NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID};
                                                  
                                                  [self startDownloadDataWithMessage:nil];
                                                  [AnalyzeObject deleBankCardWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                                                      [self stopDownloadData];
                                                      if (CODE(ret)) {
                                                          [self reshData];
                                                      }else{
                                                          [CoreSVP showMessageInCenterWithMessage:msg];
                                                      }
                                                  }];
                                                  
                                              }
                                              if (index==1) {//更换银行卡
                                                  BangDingCardViewController *bangDingCardVC = [BangDingCardViewController new];
                                                  bangDingCardVC.bankInfo=_dataDic;
                                                  bangDingCardVC.isAdd=NO;
                                                  [self.navigationController pushViewController:bangDingCardVC animated:YES];
                                              }
                                          }];
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"银行卡";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.TitleLabel.right , self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    changeButton.right=self.NavImg.width-RM_Padding;
    changeButton.tag = 40;
    NSString *titleStr =@"管理";
    
//    [[Stockpile sharedStockpile].defaultBankCardNum trimString].length == 0 ? @"添加" :@"修改";
    [changeButton setTitle:titleStr forState:UIControlStateNormal];
    [changeButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    changeButton.titleLabel.font = Big15Font(self.scale);
    [changeButton addTarget:self action:@selector(changeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:changeButton];
    _manageBtn=changeButton;
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
