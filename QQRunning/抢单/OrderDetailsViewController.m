//
//  OrderDetailsViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/24.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "orderDaoHangViewController.h"
#import "CellView.h"
@interface OrderDetailsViewController()



@end

@implementation OrderDetailsViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self setupNewNavi];
    [self reshData];
}
#pragma mark -- 界面
-(void)initData{

        _dataDic=[NSMutableDictionary  dictionary];
   
}
-(void)reshData{
    NSDictionary * dic = @{@"OrderId":_orderId};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getUnFinishOrderDetailWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
//        [_dataDic removeAllObjects];
        if (CODE(ret)) {
            [_dataDic addEntriesFromDictionary:model];
            [self setupNewView];
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        }
    }];
    
    
}

-(void)setupNewView{
  
    
    UIImageView * sepImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_Padding/2)];
    sepImg.image=[UIImage imageNamed:@"tiaowen"];
    [self.view addSubview:sepImg];

    CellView *topView = [[CellView alloc] initWithFrame:CGRectMake(0, sepImg.bottom, RM_VWidth, 40*self.scale)];
    topView.topline.hidden = NO;
    [topView setShotLine:YES];
    topView.titleLabel.text = @"订单详情";
    topView.titleLabel.font = Big14Font(self.scale);
    topView.contentLabel.text = [[NSString stringWithFormat:@"%@",_dataDic[@"DownOrderTime"]] getValiedString];
    topView.contentLabel.textColor = matchColor;
    topView.contentLabel.font = SmallFont(self.scale);
    topView.contentLabel.textAlignment = 2;
    [self.view addSubview:topView];
    
    CellView *contentView = [[CellView alloc] initWithFrame:CGRectMake(0, topView.bottom, RM_VWidth, 40*self.scale)];
    contentView.bottomline.hidden = NO;
    [self.view addSubview:contentView];


    
    NSArray *titleArray;
    /*                                          买送取                                             */
    //订单编号
    NSString * orderNum = [[NSString stringWithFormat:@"%@",_dataDic[@"OrderNum"]] getValiedString];
    //下单时间
    NSString * xiaDanTime = [[NSString stringWithFormat:@"%@",_dataDic[@"DownOrderTime"]] getValiedString];
    
    
    //起
    NSString * qiDiZhi = [[NSString stringWithFormat:@"%@",_dataDic[@"QIAddress"]] getValiedString];
    NSString * qiPerson = [[NSString stringWithFormat:@"%@",_dataDic[@"QIPerSon"]] getValiedString];
    NSString * qiTel = [[NSString stringWithFormat:@"%@",_dataDic[@"QITel"]] getValiedString];

    //终
    NSString * zhongDiZhi = [[NSString stringWithFormat:@"%@",_dataDic[@"ZhongAddress"]] getValiedString];
    NSString * zhongPerson = [[NSString stringWithFormat:@"%@",_dataDic[@"ZhongPerSon"]] getValiedString];
    NSString * zhongTel = [[NSString stringWithFormat:@"%@",_dataDic[@"ZhongTel"]] getValiedString];
    
    
    // 取
    NSString * quJuLi = [[NSString stringWithFormat:@"%@",_dataDic[@"QuJuLi"]] getValiedString];
    NSString * quTime = [[NSString stringWithFormat:@"%@",_dataDic[@"QuHuoTime"]] getValiedString];
    // 送
    NSString * songJuLi = [[NSString stringWithFormat:@"%@",_dataDic[@"SongJuLi"]] getValiedString];
    
    
    // 支付 金额
    NSString * zhiJiE = [[NSString stringWithFormat:@"%@",_dataDic[@"ZhiPrice"]] getValiedString];
    // 购买商品
    NSString * GoodsName = [[NSString stringWithFormat:@"%@",_dataDic[@"GoodsName"]] getValiedString];
    //商品金额
    NSString * goodsMoney = [[NSString stringWithFormat:@"%@",_dataDic[@"GoodsMoney"]] getValiedString];
    // 加价
    NSString * addMoney = [[NSString stringWithFormat:@"%@",_dataDic[@"AddMoney"]] getValiedString];
    //订单金额
    NSString * orderMoney = [NSString stringWithFormat:@"%.2f",[goodsMoney floatValue]+[addMoney floatValue]];
    orderMoney = [[NSString stringWithFormat:@"%@",_dataDic[@"Money"]] getValiedString];
    

    
    //物品类型
    NSString * goodsType = @"其它类型";
    NSInteger  goodsTypeIndex = [[[NSString stringWithFormat:@"%@",_dataDic[@"Type"]] getValiedString] integerValue];
    if (goodsTypeIndex >= 0  &&  goodsTypeIndex < self.orderTitles.count) {
        goodsType=self.orderTitles[goodsTypeIndex];
    }
    
    
    // 保温箱
    NSString * baoWenXiang = [[NSString stringWithFormat:@"%@",_dataDic[@"BaoWenBox"]] getValiedString];
    // 保价
    NSString * baojia = [[NSString stringWithFormat:@"%@",_dataDic[@"BaoJia"]] getValiedString];
    // 备注留言
    NSString * liuYan = [[NSString stringWithFormat:@"%@",_dataDic[@"Desc"]] getValiedString];
    

    /*                             帮忙                                 */
    //帮时长
   NSString * bangShiChang = [[NSString stringWithFormat:@"%@",_dataDic[@"BangShiChang"]] getValiedString];
    //帮信息
    NSString * bangXinXi = [[NSString stringWithFormat:@"%@",_dataDic[@"BangXinxi"]] getValiedString];
    
    NSLog(@"%@",_dataDic);
    self.orderType=[[NSString stringWithFormat:@"%@",_dataDic[@"Type"]] integerValue];
    NSString * isYiShui = [[NSString stringWithFormat:@"%@",_dataDic[@"IsYiSui"]] isEqualToString:@"0"]?@"其他物品":@"易碎物品";

    if (self.orderType==OrderTypeBuy) {
        titleArray= @[@{@"title":@"订单编号",@"value":orderNum},
                      @{@"title":@"下单时间",@"value":xiaDanTime},
                      @{@"title":@"购买地址",@"value":qiDiZhi},
                      @{@"title":@"收货地址",@"value":zhongDiZhi},
                      @{@"title":@"收货电话",@"value":qiTel},
                      @{@"title":@"物品类型",@"value":isYiShui},
                      @{@"title":@"购买商品",@"value":GoodsName},
                      @{@"title":@"订单金额",@"value":orderMoney},
                      @{@"title":@"商品金额",@"value":goodsMoney},
                      @{@"title":@"订单里程",@"value":songJuLi},
                      @{@"title":@"物品类型",@"value":goodsType},
                      @{@"title":@"保 温 箱",@"value":baoWenXiang},
                      @{@"title":@"备注留言",@"value":liuYan}];
    }
    
    if (self.orderType==OrderTypeBring || self.orderType==OrderTypeTake) {
        
        titleArray= @[@{@"title":@"订单编号",@"value":orderNum},
            @{@"title":@"下单时间",@"value":xiaDanTime},
            @{@"title":@"取货地址",@"value":qiDiZhi},
            @{@"title":@"收货地址",@"value":zhongDiZhi},
            @{@"title":@"取货人",@"value":qiPerson},
            @{@"title":@"取货电话",@"value":qiTel},
            @{@"title":@"收货人",@"value":zhongPerson},
            @{@"title":@"收货电话",@"value":zhongTel},
            @{@"title":@"物品类型",@"value":isYiShui},
            @{@"title":@"购买商品",@"value":GoodsName},
            @{@"title":@"订单金额",@"value":orderMoney},
            @{@"title":@"商品金额",@"value":goodsMoney},
            @{@"title":@"订单里程",@"value":songJuLi},
            @{@"title":@"物品类型",@"value":goodsType},
            @{@"title":@"保价",@"value":baojia},
            @{@"title":@"备注留言",@"value":liuYan}];
    }
    
    if (self.orderType==OrderTypeHelp) {
        titleArray= @[@{@"title":@"订单编号",@"value":orderNum},
                      @{@"title":@"下单时间",@"value":xiaDanTime},
                      @{@"title":@"帮忙信息",@"value":bangXinXi},
                      @{@"title":@"帮忙地点",@"value":qiDiZhi},
                      @{@"title":@"联 系 人",@"value":qiPerson},
                      @{@"title":@"联系电话",@"value":qiTel},
                      @{@"title":@"帮忙类型",@"value":bangXinXi},
                      @{@"title":@"帮忙时间",@"value":bangShiChang},
                      @{@"title":@"订单金额",@"value":orderMoney},
                      @{@"title":@"订单里程",@"value":quJuLi},
                      @{@"title":@"备注留言",@"value":liuYan}];
    }
    
    if (self.orderType==OrderTypeQueueUp) {
        titleArray= @[@{@"title":@"订单编号",@"value":orderNum},
                      @{@"title":@"下单时间",@"value":xiaDanTime},
                      @{@"title":@"排队信息",@"value":bangXinXi},
                      @{@"title":@"排队地点",@"value":qiDiZhi},
                      @{@"title":@"排队时间",@"value":xiaDanTime},
                      @{@"title":@"帮忙时间",@"value":bangShiChang},
                      @{@"title":@"订单金额",@"value":orderMoney},
                      @{@"title":@"订单里程",@"value":quJuLi},
                      @{@"title":@"备注留言",@"value":liuYan}];
    }
    if (self.orderType==OrderTypeMotocycleTaxi) {
        titleArray= @[@{@"title":@"订单编号",@"value":orderNum},
                      @{@"title":@"下单时间",@"value":xiaDanTime},
                      @{@"title":@"上车地址",@"value":qiDiZhi},
                      @{@"title":@"下车地址",@"value":zhongDiZhi},
                      @{@"title":@"订单金额",@"value":orderMoney},
                      @{@"title":@"订单里程",@"value":quJuLi},
                      @{@"title":@"备注留言",@"value":liuYan}];
    }
    
    
    
    
    float setY = RM_Padding;
    for (int i = 0; i < titleArray.count; i ++) {
        CellView *cell = [[CellView alloc] initWithFrame:CGRectMake(0, setY, contentView.width, 20*self.scale)];
        cell.topline.hidden = YES;
        cell.bottomline.hidden = YES;
        cell.titleLabel.text = titleArray[i][@"title"];
        cell.titleLabel.textColor = grayTextColor;
        cell.content = titleArray[i][@"value"];
        [contentView addSubview:cell];
        setY = cell.bottom;
    }
    contentView.height = setY +RM_Padding;
    
}
#pragma mark -- 点击事件
-(void)orderMapButtonEvent:(UIButton *)button{
    orderDaoHangViewController *orderMapVC = [orderDaoHangViewController new];
    orderMapVC.longitude=[[NSString stringWithFormat:@"%@",_dataDic[@"ZhongLng"]] floatValue];
    orderMapVC.latitude = [[NSString stringWithFormat:@"%@",_dataDic[@"ZhongLat"]] floatValue];
    
    [self.navigationController pushViewController:orderMapVC animated:YES];
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"订单详情";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
    UIButton *orderMapButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - self.TitleLabel.height*2, self.TitleLabel.top, self.TitleLabel.height*2, self.TitleLabel.height)];
    [orderMapButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    [orderMapButton setTitle:@"订单地图" forState:UIControlStateNormal];
    orderMapButton.titleLabel.font = Big15Font(self.scale);
    [orderMapButton addTarget:self action:@selector(orderMapButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:orderMapButton];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
