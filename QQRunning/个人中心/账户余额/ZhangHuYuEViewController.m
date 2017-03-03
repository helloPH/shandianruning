//
//  ZhangHuYuEViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "ZhangHuYuEViewController.h"
#import "CellView.h"
#import "TiXianJiLuTableViewCell.h"
#import "TiXianViewController.h"
#import "BangDingCardViewController.h"
#import "TiXianJuLuViewController.h"
#import "TiXianGuiZeViewController.h"

@interface ZhangHuYuEViewController()
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ZhangHuYuEViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self setupNewNavi];
    [self reshData];
}
-(void)initData{
    _dataDic = [NSMutableDictionary dictionary];
}
-(void)reshData{
    NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getBankCardInfoWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        [_dataDic removeAllObjects];
        if (CODE(ret)) {
            [_dataDic addEntriesFromDictionary:model];
            NSLog(@"%@",_dataDic);
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        }
         [self setupTopView];
    }];
    
    
}
-(void)reshView{
    
}
#pragma mark -- 界面
-(void)setupTopView
{
    NSString * yuE=[[NSString stringWithFormat:@"%@",_dataDic[@"Money"]] isEmptyString]?@"0":[NSString stringWithFormat:@"%@",_dataDic[@"Money"]];
    
    
    /// 顶部的view
    UIImageView * topImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VWidth*0.3)];
    topImg.image=[UIImage imageNamed:@"zhanghu_bg"];
    [self.view addSubview:topImg];
    
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 40)];
    label.attributedText = [[NSString stringWithFormat:@"<white12>当前账户余额（元）</white12>\n\n<white20>%@</white20>", yuE] attributedStringWithStyleBook:[self Style]];
    label.numberOfLines=2;
    label.centerY=topImg.height/2-10*self.scale;
    label.textAlignment=NSTextAlignmentCenter;
    
    [topImg addSubview:label];
    
    
    UIImageView * centerImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, label.bottom, 130, 17.5)];
    centerImg.centerX=topImg.width/2;
    centerImg.image=[UIImage imageNamed:@"zhanghu_01"];
    centerImg.top=label.bottom;
    [topImg addSubview:centerImg];
    
    
    
    CGFloat setY=topImg.bottom;
    for (int i =0 ; i < 2; i ++) {
        CellView * cell=[[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 40*self.scale)];
        [self.view addSubview:cell];
        
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(RM_Padding, 0, 20, 17.5)];
        [cell addSubview:imgView];
        imgView.centerY=cell.height/2;
        imgView.image=[UIImage imageNamed:i==0?@"tixian":@"tixianguize"];
        
        cell.titleLabel.left=imgView.right+RM_Padding/2;
        cell.titleLabel.text=i==0?@"账户提现":@"提现规则";
        
        [cell ShowRight:YES];
        
        if (i==0) {
            cell.contentLabel.right=cell.RightImg.left;
            cell.contentLabel.textAlignment=NSTextAlignmentRight;
            cell.contentLabel.textColor=mainColor;
            NSInteger approveWithDraw=0;
            if (minYuE < [yuE integerValue]) {
                approveWithDraw=([yuE integerValue]-minYuE)/Intergral * Intergral;
            }
            cell.contentLabel.text=[NSString stringWithFormat:@"可提现￥%ld",(long)approveWithDraw];
            cell.shotLine=YES;
            [cell.btn addTarget:self action:@selector(tiXianButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [cell.btn addTarget:self action:@selector(tiXianGuiZeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
    
        setY=cell.bottom;
    }
    
    
}


#pragma mark -- 点击事件
//提现规则
-(void)tiXianGuiZeButtonEvent:(UIButton *)button{
    TiXianGuiZeViewController * guize=[TiXianGuiZeViewController new];
    [self.navigationController pushViewController:guize animated:true];
}
//提现
-(void)tiXianButtonEvent:(UIButton *)button{
   
    NSString * bankNum=[[NSString stringWithFormat:@"%@",_dataDic[@"BankNum"]] getValiedString];
    if ([bankNum trimString].length == 0) {
        [self ShowAlertTitle:@"您还未绑定银行卡\n是否现在绑定？" Message:nil Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                BangDingCardViewController * add=[BangDingCardViewController new];
                add.isAdd=YES;
                [self.navigationController pushViewController:add animated:YES];
            }
        }];
        return;
    }
    TiXianViewController *tixianVC = [TiXianViewController new];
    NSString * yuE=[[NSString stringWithFormat:@"%@",_dataDic[@"Money"]]isEmptyString]?@"0":[NSString stringWithFormat:@"%@",_dataDic[@"Money"]];
    tixianVC.yuE=[yuE integerValue];
    tixianVC.bankName=[[NSString stringWithFormat:@"%@",_dataDic[@"Name"]] getValiedString];
    tixianVC.bankCardNum=[[NSString stringWithFormat:@"%@",_dataDic[@"BankNum"]] getValiedString];
    [self.navigationController pushViewController:tixianVC animated:YES];
    
    
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"账户余额";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
    UIButton *tiXianGuiZeButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - self.TitleLabel.height*2-RM_Padding, self.TitleLabel.top, self.TitleLabel.height*2, self.TitleLabel.height)];
    [tiXianGuiZeButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    [tiXianGuiZeButton setTitle:@"提现明细" forState:UIControlStateNormal];
    tiXianGuiZeButton.titleLabel.font = Big15Font(self.scale);
    [tiXianGuiZeButton addTarget:self action:@selector(tixianJuLuEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:tiXianGuiZeButton];
}
-(void)tixianJuLuEvent:(UIButton *)sender{
    TiXianJuLuViewController * tixianjilu=[TiXianJuLuViewController new];
    [self.navigationController pushViewController:tixianjilu animated:YES];
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
