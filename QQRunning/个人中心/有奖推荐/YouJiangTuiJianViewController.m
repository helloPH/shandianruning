//
//  YouJiangTuiJianViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "YouJiangTuiJianViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface YouJiangTuiJianViewController ()
@property(nonatomic,strong)UIControl *maskControl;
@property(nonatomic,strong)UIView *shareView;
@end

@implementation YouJiangTuiJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupNewView];
}
#pragma mark -- 界面
-(void)setupNewView{
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom)];
    bgImageView.image = [UIImage imageNamed:@"tuijian_bg"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    UILabel * guiZe =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth/2+30, 200)];
    guiZe.textColor=[UIColor blackColor];
    guiZe.font=Big15Font(self.scale);
    guiZe.numberOfLines=0;
    [bgImageView addSubview:guiZe];
    
    
    NSMutableParagraphStyle *paraStyle02 = [[NSMutableParagraphStyle alloc] init];
    paraStyle02.lineHeightMultiple = 1.5;
    NSDictionary *attrDict02 = @{ NSParagraphStyleAttributeName: paraStyle02,
                                   };
    guiZe.attributedText=[[NSAttributedString alloc]initWithString:@"向好友分享好用的app\n邀请感兴趣的小伙伴们，不妨来这里看看吧！" attributes:attrDict02];
//    guiZe.text=;
    [guiZe sizeToFit];
    guiZe.center=CGPointMake(bgImageView.width/2-10, bgImageView.height/2+20);
    
    
    float buttonWidth = 282/2.25*self.scale;
    float blankWidth = (RM_VWidth - 2*buttonWidth)/3;
    float setX = blankWidth;
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(setX, bgImageView.bottom - 100*self.scale, buttonWidth, 86/2.25*self.scale)];
        [button setBackgroundImage:[UIImage imageNamed:@"tuijian_btn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tuijian_btn"] forState:UIControlStateHighlighted];
        NSString *titleStr = i == 0?@"推荐跑男":@"推荐用户";
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.font = Big14Font(self.scale);
        [button setTitleColor:whiteLineColore forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ShareEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:button];
        button.bottom=bgImageView.height-30*self.scale;
        setX = button.right + blankWidth;
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
   
    NSString *qqfri = @"umeng_socialize_qq";
    NSString *qqzone = @"umeng_socialize_qzone";
    NSString *wxfri = @"umeng_socialize_wechat";
    NSString *wxzone = @"umeng_socialize_wxcircle";
    
    
    
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
    
//    //取消按钮
//    UIButton * cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(RM_ButtonPadding, setY+RM_Padding*2, view.width - RM_ButtonPadding*2, RM_ButtonHeight)];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font=Big15Font(self.scale);
//    [cancelBtn setTitleColor:whiteLineColore forState:UIControlStateNormal];
//    [cancelBtn setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
//    [view addSubview:cancelBtn];
//    cancelBtn.layer.cornerRadius = RM_CornerRadius;
//    cancelBtn.clipsToBounds = YES;
//    [cancelBtn addTarget:self action:@selector(dismissViewEvent) forControlEvents:UIControlEventTouchUpInside];
//    setY=cancelBtn.bottom+RM_Padding*2;
    
    view.height=setY+10;
    return view;
}
-(void)fen:(UIButton *)button
{
    [self.view endEditing:YES];
    [self dismissViewEvent];
    [self shareButtonEvent:button];
}
-(void)shareButtonEvent:(UIButton *)sender{
    UMSocialPlatformType type;
//
    if ([sender.titleLabel.text isEqualToString:@"QQ"]){
        type = UMSocialPlatformType_QQ;
    }else if ([sender.titleLabel.text isEqualToString:@"QQ空间"]){
        type = UMSocialPlatformType_Qzone;
    }else if ([sender.titleLabel.text isEqualToString:@"微信"]){
        type = UMSocialPlatformType_WechatSession;
    }else if ([sender.titleLabel.text isEqualToString:@"朋友圈"]){
        type = UMSocialPlatformType_WechatTimeLine;
    }
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
            if (error.code==2008) {
                [self ShowOKAlertWithTitle:@"提示" Message:@"未安装此应用!" WithButtonTitle:@"确定" Blcok:^{
                    
                }];
            }
            
            
           
            
//            [CoreSVP showMessageInCenterWithMessage:[NSString stringWithFormat:@"%@",error]];
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
    self.TitleLabel.text = @"我要邀请";
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
