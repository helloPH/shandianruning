//
//  TodayChengJiuViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "TodayChengJiuViewController.h"
#import "CellView.h"
#import "GetShouYiViewController.h"
#import "RunDistanceViewController.h"
#import "FinishOrderViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface TodayChengJiuViewController ()
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *pictureArray;

//分享
@property(nonatomic,strong)UIControl *maskControl;
@property(nonatomic,strong)UIView *shareView;
@end

@implementation TodayChengJiuViewController
-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"完成订单",@"奔跑里程",@"获得收益"];
    }
    return _titleArray;
}
-(NSArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray = @[@"gr_wanchengdingdan",@"gr_benpaolicheng",@"gr_shouyi"];
    }
    return _pictureArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupNewView];
}
#pragma mark -- 界面
-(void)setupNewView{
    float setY = self.NavImg.bottom + RM_Padding;
    for (int i = 0; i < self.titleArray.count; i ++) {
        CellView *cellView = [[CellView alloc] initWithFrame:CGRectMake(0, setY, RM_VWidth, 70*self.scale)];
        cellView.topline.hidden = i != 0;
        [cellView setShotLine:i != self.titleArray.count - 1];
        setY = cellView.bottom;
        [cellView ShowRight:YES];
        [self.view addSubview:cellView];
        
        UIImageView *picture = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding*2, cellView.height/2 - 20*self.scale, 40*self.scale, 40*self.scale)];
        picture.image = [UIImage imageNamed:self.pictureArray[i]];
        [cellView addSubview:picture];
        
        UILabel *decLabel = [[UILabel alloc] initWithFrame:CGRectMake(picture.right + RM_Padding, RM_Padding, cellView.width - picture.right - 2*RM_Padding, (cellView.height-RM_Padding*2)/2)];
        decLabel.text = self.titleArray[i];
        decLabel.font = SmallFont(self.scale);
        decLabel.textColor = blackTextColor;
        [cellView addSubview:decLabel];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(decLabel.left, decLabel.bottom, decLabel.width , decLabel.height)];
        
        NSString * count = @"";
        NSString * measure = @"";

        
        switch (i) {
            case 0:// 完成订单
            {
                count = _type==ChengJiuTypeToday?[Stockpile sharedStockpile].userTodayOrderNum:[Stockpile sharedStockpile].userAllOrderNum;
                measure=@"单";
            }
                break;
            case 1:// 奔跑里程
            {
                
                count = _type==ChengJiuTypeToday?[Stockpile sharedStockpile].userTodayLiCheng:[Stockpile sharedStockpile].userAllJuLi;
                
                measure=@"公里";
            }
                break;
            case 2://  获取收益
            {
                count = _type==ChengJiuTypeToday?[Stockpile sharedStockpile].userTodayShouYi:[Stockpile sharedStockpile].userAllTiCheng;
                measure=@"元";
            }
                break;
                
            default:
                break;
        }
        
        numLabel.attributedText = [[NSString stringWithFormat:@"<black20>%@</black20><black13>%@</black13>",count,measure] attributedStringWithStyleBook:[self Style]];
        [cellView addSubview:numLabel];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellView.width, cellView.height)];
        button.backgroundColor = clearColor;
        button.tag = 10+ i;
        [button addTarget:self action:@selector(clickButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:button];
    }
}
#pragma mark -- 点击事件
-(void)clickButtonEvent:(UIButton *)button{
    if (button.tag == 10) {
        //完成订单
        FinishOrderViewController *finishVC = [FinishOrderViewController new];
        [self.navigationController pushViewController:finishVC animated:YES];
    }else if (button.tag == 11){
        //奔跑里程
        RunDistanceViewController *runVC = [RunDistanceViewController new];
        runVC.chengJiutype = _type;
        [self.navigationController pushViewController:runVC animated:YES];
    }else{
        //获得收益
        GetShouYiViewController *shouYiVC = [GetShouYiViewController new];
        shouYiVC.chengJiutype = _type;
        [self.navigationController pushViewController:shouYiVC animated:YES];
    }
}
#pragma mark -- 分享
-(void)ShareEvent:(UIButton *)button{
    _maskControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    _maskControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [_maskControl addTarget:self action:@selector(dismissViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_maskControl];
    
    _shareView = [self shareView];
    [_maskControl addSubview:_shareView];
    [UIView animateWithDuration:.3 animations:^{
        _maskControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _shareView.bottom=RM_VHeight;
        
        
    }];
    
}
-(UIView *)shareView
{
    NSMutableArray * titls = [NSMutableArray arrayWithObjects:@"QQ",@"QQ空间",@"微信",@"朋友圈", nil];
    
    NSMutableArray * imgs= [NSMutableArray new];
    
    NSString *qqfri = @"chengjiu_share_icon01";
    NSString *qqzone = @"chengjiu_share_icon02";
    NSString *wxfri = @"chengjiu_share_icon03";
    NSString *wxzone = @"chengjiu_share_icon04";
    
    
    
    //    if (![QQApiInterface isQQSupportApi]) {
    //        [titls removeObject:@"QQ"];
    //        [titls removeObject:@"QQ空间"];
    //    }
    
    
    
    //    if (![WXApi isWXAppSupportApi]) {
    //        [titls removeObject:@"微信"];
    //        [titls removeObject:@"朋友圈"];
    //    }
    //
    
    for (NSString *string in titls) {
        
        if ([string isEqualToString:@"QQ"]) {
            [imgs addObject:qqfri];
        }
        if ([string isEqualToString:@"QQ空间"]) {
            [imgs addObject:qqzone];
        }
        if ([string isEqualToString:@"朋友圈"]) {
            [imgs addObject:wxzone];
        }
        if ([string isEqualToString:@"微信"]) {
            [imgs addObject:wxfri];
        }
        
    }
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, RM_VHeight, RM_VWidth, 300*self.scale)];
    view.backgroundColor = whiteLineColore;
    
    UIImageView * topLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 0.5)];
    topLine.backgroundColor=blackLineColore;
    [view addSubview:topLine];
    
    CGFloat setX = 15*self.scale;
    CGFloat setY = 20*self.scale;
    CGFloat buttonWidth = (self.view.width - 120*self.scale)/titls.count;
    
    for (int i = 0; i < titls.count; i ++) {
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(setX, setY, buttonWidth, buttonWidth + 20*self.scale)];
        shareButton.tag = i;
        [shareButton setTitle:titls[i] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(fen:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setTitleColor:clearColor forState:UIControlStateNormal];
        shareButton.backgroundColor = clearColor;
        [view addSubview:shareButton];
        
        //分享的图片
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
        imgView.image=[UIImage imageNamed:imgs[i]];
        imgView.layer.cornerRadius=buttonWidth/2;
        imgView.clipsToBounds=YES;
        imgView.centerX=buttonWidth/2;
        [shareButton addSubview:imgView];
        //分享的标题
        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom, buttonWidth, 20*self.scale)];
        title.centerX=imgView.centerX;
        title.font=Small11Font(self.scale);
        title.textAlignment=NSTextAlignmentCenter;
        title.text=titls[i];
        [shareButton addSubview:title];
        setX = shareButton.right + 30*self.scale;
    }
    setY += buttonWidth + 20*self.scale;
    
    //取消按钮
    UIButton * cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(RM_ButtonPadding, setY+RM_Padding*2, view.width - RM_ButtonPadding*2, RM_ButtonHeight)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=Big15Font(self.scale);
    [cancelBtn setTitleColor:whiteLineColore forState:UIControlStateNormal];
    cancelBtn.backgroundColor = blackLineColore;
    [view addSubview:cancelBtn];
    cancelBtn.layer.cornerRadius = RM_CornerRadius;
    cancelBtn.clipsToBounds = YES;
    [cancelBtn addTarget:self action:@selector(dismissViewEvent) forControlEvents:UIControlEventTouchUpInside];
    setY=cancelBtn.bottom+RM_Padding*2;
    
    view.height=setY;
    return view;
}
-(void)fen:(UIButton *)button
{
    [self.view endEditing:YES];
    [self dismissViewEvent];
    [self shareButtonEvent:button];
}
-(void)shareButtonEvent:(UIButton *)sender{
    [CoreSVP showMessageInCenterWithMessage:[NSString stringWithFormat:@"点击了第 %ld 个按钮",sender.tag+1]];
         UMSocialPlatformType type;
    
        if ([sender.titleLabel.text isEqualToString:@"QQ"]){
            type = UMSocialPlatformType_QQ;
        }else if ([sender.titleLabel.text isEqualToString:@"QQ空间"]){
            type = UMSocialPlatformType_Qzone;
        }else if ([sender.titleLabel.text isEqualToString:@"微信"]){
            type = UMSocialPlatformType_WechatSession;
        }else if ([sender.titleLabel.text isEqualToString:@"朋友圈"]){
            type = UMSocialPlatformType_WechatTimeLine;
        }
    
        [self ShareByDiffrentWayWithType:type
                                    Text:@"这是文字内容"
                                  images:[UIImage imageNamed:@"1024"]
                                     Url:[NSURL URLWithString:@"https://www.baidu.com"]
                                   Title:@"这是标题"];
}
-(void)ShareByDiffrentWayWithType:(UMSocialPlatformType)type Text:(NSString *)text images:(UIImage *)image Url:(NSURL *)url Title:(NSString *)title
{
    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
}
//-(void)panduan:(SSDKResponseState)state{
//    switch (state) {
//        case SSDKResponseStateSuccess:
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                message:nil
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//            [alertView show];
//            break;
//        }
//        case SSDKResponseStateFail:
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil, nil];
//            [alert show];
//            break;
//        }
//        default:
//            break;
//    }
//
//}

-(void)dismissViewEvent{
    [UIView animateWithDuration:.3 animations:^{
        _maskControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _shareView.top=RM_VHeight;
        
    }completion:^(BOOL finished) {
        
        [_maskControl removeFromSuperview];
        _shareView=nil;
        
    }];
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = _type == ChengJiuTypeToday ? @"今日成就" : @"累计成就";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
//    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
//    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
//    [shareButton setTitleColor:blackTextColor forState:UIControlStateNormal];
//    shareButton.titleLabel.font = Big15Font(self.scale);
//    [shareButton addTarget:self action:@selector(ShareEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:shareButton];
    
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
