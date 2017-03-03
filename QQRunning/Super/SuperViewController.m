//
//  SuperViewController.m
//  MissAndFound
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "CellView.h"



@interface SuperViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong) AlertBlock alertBlock;
@property (nonatomic,strong) qiangDanSuccessBlock successBlock;
@property (nonatomic,strong) OKAlertBlock okAlertBlock;
@property (nonatomic,strong) cancleAlertBlock cancleAlertBlock;
//弹出的视图
@property (nonatomic,strong) UIView *tanChuView;
@property (nonatomic,strong) UIImageView *bgView;

@property (nonatomic,strong) UIImageView * kongImg;

@property (nonatomic,strong) UIView * progressView;
@end
@implementation SuperViewController

#define grayViewWidth 500/2.25*self.scale
- (void)viewDidLoad {
    [super viewDidLoad];
   
    _appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
      [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
       _scale=RM_Scale;
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor = superBackgroundColor;

    self.orderTitles=@[@"闪电买",@"闪电送",@"闪电取",@"闪电摩的",@"闪电帮",@"代排队"];
    
    
    self.NavImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RM_VWidth, 64)];
    self.NavImg.userInteractionEnabled = YES;
    self.NavImg.clipsToBounds = YES;
    self.NavImg.backgroundColor = whiteLineColore;
    [self.view  addSubview:self.NavImg];

    self.TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45*self.scale, 20, self.view.width-90*self.scale, 44)];
    self.TitleLabel.textColor = blackTextColor;
    self.TitleLabel.textAlignment = 1;
    self.TitleLabel.font = Big17BoldFont(self.scale);
    self.TitleLabel.backgroundColor = clearColor;
    [self.NavImg addSubview:self.TitleLabel];
    
    _Navline=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-0.5, self.view.width, 0.5)];
    _Navline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:_Navline];
//    _Navline.hidden = YES;
    
//    self.fd_prefersNavigationBarHidden = YES;
}
-(void)showMessage:(NSString *)message{
    if ([[NSString stringWithFormat:@"%@",message] isEmptyString]) {
        return;
    }
    if (self.HUD) {
        [self.HUD removeFromSuperview ];
    }
    self.HUD = [MBProgressHUD showHUDAddedTo:self.appdelegate.window animated:YES];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = message;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hide:NO afterDelay:2.0];
}


-(void)startDownloadDataWithMessage:(NSString *)message{
//    if (self.HUD) {
//        [self.HUD removeFromSuperview ];
//    }
//    self.HUD = [MBProgressHUD showHUDAddedTo:self.appdelegate.window animated:YES];
//    self.HUD.mode = MBProgressHUDModeIndeterminate;
//    if ([[NSString stringWithFormat:@"%@",message] isEmptyString]) {
//        message=@"正在加载...";
//    }
//    self.HUD.labelText = message;
//    self.HUD.removeFromSuperViewOnHide = YES;
//    
//    self.HUD.hidden=YES;
    
    
    
    if (_progressView) {
        _progressView=nil;
        [_progressView removeFromSuperview];
    }
    _progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, RM_VHeight)];
    [self.appdelegate.window addSubview:_progressView];
    _progressView.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];

    _progressView.center=CGPointMake(self.appdelegate.window.width/2, self.appdelegate.window.height/2);
    
//    UIView * bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
//    bgView.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
//    bgView.center=_progressView.center;
//    [_progressView addSubview:bgView];
    
    
    
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_progressView addSubview:img];
    img.center=CGPointMake(_progressView.width/2, _progressView.height/2);
    [img setAnimationImages:@[[UIImage imageNamed:@"a111"],
                              [UIImage imageNamed:@"a222"],
                              [UIImage imageNamed:@"a333"],
                              [UIImage imageNamed:@"a444"],
                              [UIImage imageNamed:@"a555"]]];
    [img startAnimating];
    
    
    if ([[NSString stringWithFormat:@"%@",message] isEmptyString]) {
        message=@"跑男拼命加载中...";
    }
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom, _progressView.width, 20)];
    title.font=DefaultFont(self.scale);
    title.textColor=mainColor;
    title.text=message;
    title.textAlignment=NSTextAlignmentCenter;
    [_progressView addSubview:title];
    
}



-(void)stopDownloadData{
//    [self.HUD hide:NO];
    [_progressView removeFromSuperview];
    
}
-(void)ShowOKAlertWithTitle:(NSString *)title Message:(NSString *)message WithButtonTitle:(NSString *)btnTitle Blcok:(OKAlertBlock)okBlock{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (!btnTitle || [btnTitle trimString].length == 0) {
        btnTitle = @"确定";
    }
    UIAlertAction *OKAlertAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       _okAlertBlock = okBlock;
        _okAlertBlock();
    }];
    [OKAlertAction setValue:mainColor forKey:@"titleTextColor"];
    [alertController addAction:OKAlertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)ShowOKAndCancleAlertWithTitle:(NSString *)title Message:(NSString *)message WithOKButtonTitle:(NSString *)OKtitle WithCancleButtonTitle:(NSString *)cancletitle OKBlcok:(OKAlertBlock)okBlock CanleBlock:(cancleAlertBlock)cancleBlock{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (!OKtitle || [OKtitle trimString].length == 0) {
        OKtitle = @"确定";
    }
    if (!cancletitle || [cancletitle trimString].length == 0) {
        cancletitle = @"取消";
    }
    UIAlertAction *OKAlertAction = [UIAlertAction actionWithTitle:OKtitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _okAlertBlock = okBlock;
        _okAlertBlock();
    }];
    UIAlertAction *cancleAlertAction = [UIAlertAction actionWithTitle:cancletitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _cancleAlertBlock = cancleBlock;
        _cancleAlertBlock();
    }];
    [OKAlertAction setValue:mainColor forKey:@"titleTextColor"];
    [cancleAlertAction setValue:blackTextColor forKey:@"titleTextColor"];
    [alertController addAction:cancleAlertAction];
    [alertController addAction:OKAlertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)setName:(NSString *)name{
    self.navigationController.title=name;
}
-(void)CancelOrderMessage:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles: @"我不想买了",@"信息填写错误，重新拍",@"其他原因",nil];
    [alert show];
    _alertBlock=block;
}
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block{
    
    if (!delegate && !block) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
        [alert show];
        _alertBlock=block;
    }
  
}
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate OKText:(NSString *)oktext CancelText:(NSString *)cancel Block:(AlertBlock)block{
    if ([cancel isEmptyString]) {
        cancel=@"取消";
    }
    if([oktext isEmptyString]){
        oktext=@"确定";
    }
    if (!delegate && !block) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:oktext otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles: oktext,nil];
        [alert show];
        _alertBlock=block;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (_alertBlock) {
        _alertBlock(buttonIndex);
    }
}
-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone{
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines=0;
    label.text=text;

    label.font=fone;
    [label sizeToFit];
    
    return label.size;
}
-(NSDictionary *)Style{
    NSDictionary *style=@{
                          @"body":[UIFont systemFontOfSize:12*self.scale],
                          @"Big":[UIFont systemFontOfSize:14*self.scale],
                          @"red":redTextColor,
                          @"pink":pinkTextColor,
                          @"org":orangeTextColor,
                          @"pink13":@[pinkTextColor,[UIFont systemFontOfSize:13*self.scale]],
                          @"pink14":@[pinkTextColor,[UIFont systemFontOfSize:14*self.scale]],
                          @"orange":@[[UIColor colorWithRed:255/255.0 green:132/225.0 blue:0/255.0 alpha:1],[UIFont fontWithName:@"HelveticaNeue" size:15*self.scale]],
                          @"Org10":@[orangeTextColor,[UIFont systemFontOfSize:10*self.scale]],
                          
                          @"red12":@[[UIColor redColor],[UIFont systemFontOfSize:12*self.scale]],
                          @"red13":@[[UIColor redColor],[UIFont systemFontOfSize:13*self.scale]],
                          @"red15":@[redTextColor,[UIFont systemFontOfSize:15*self.scale]],
                          
                          @"gray10":@[grayTextColor,[UIFont systemFontOfSize:10*self.scale]],
                          @"gray11":@[grayTextColor,[UIFont systemFontOfSize:11*self.scale]],
                          @"gray12":@[grayTextColor,[UIFont systemFontOfSize:12*self.scale]],
                          @"gray13":@[grayTextColor,[UIFont fontWithName:@"HelveticaNeue" size:13*self.scale ]],
                          
                          @"black11":@[blackTextColor,[UIFont systemFontOfSize:11*self.scale]],
                          @"black12":@[blackTextColor,[UIFont systemFontOfSize:12*self.scale]],
                          @"black13":@[blackTextColor,[UIFont systemFontOfSize:13*self.scale]],
                          @"black14":@[blackTextColor,[UIFont systemFontOfSize:14*self.scale]],
                          @"black15":@[blackTextColor,[UIFont systemFontOfSize:15*self.scale]],
                          @"black20":@[blackTextColor,[UIFont systemFontOfSize:20*self.scale]],
                          
                          @"main12":@[mainColor,[UIFont systemFontOfSize:12*self.scale]],
                          @"main13":@[mainColor,[UIFont systemFontOfSize:13*self.scale]],
                          @"main15":@[mainColor,[UIFont systemFontOfSize:15*self.scale]],
                          @"main20":@[mainColor,[UIFont systemFontOfSize:20*self.scale]],
                          
                          @"blue12":@[blueTextColor,[UIFont systemFontOfSize:12*self.scale]],
                          @"blue13":@[blueTextColor,[UIFont systemFontOfSize:13*self.scale]],
                          @"blue15":@[blueTextColor,[UIFont systemFontOfSize:15*self.scale]],
                          
                          @"white10":@[whiteLineColore,[UIFont systemFontOfSize:10*self.scale]],
                          @"white12":@[whiteLineColore,[UIFont systemFontOfSize:12*self.scale]],
                          @"white14":@[whiteLineColore,[UIFont systemFontOfSize:14*self.scale]],
                          @"white18":@[whiteLineColore,[UIFont systemFontOfSize:18*self.scale]],
                          @"white20":@[whiteLineColore,[UIFont systemFontOfSize:20*self.scale]],
                          
                          @"orang20":@[matchColor,[UIFont systemFontOfSize:20*self.scale]],
                          @"orang15":@[matchColor,[UIFont systemFontOfSize:15*self.scale]],
                          @"orang14":@[matchColor,[UIFont systemFontOfSize:14*self.scale]],
                          };
    return style;
}
-(NSDateComponents *)SplitDate:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:date];
    return comps;
}
#pragma mark -- 弹出视图

-(void)nullTap:(UITapGestureRecognizer *)tap{
    
}
-(void)ShowQiangDanResultMessage:(NSString *)message WithCode:(tanChuView)code WithBlock:(qiangDanSuccessBlock)block{
    _successBlock = block;
    //灰色的视图
    _tanChuView = [[UIView alloc] initWithFrame:self.view.frame];
    _tanChuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    


    
    
    [self.appdelegate.window addSubview:_tanChuView];
    
    
    
    //整个弹出的视图
    float bgViewHeight = (163/2.25*self.scale + 30*self.scale + 30*self.scale + 10*self.scale*3);
    float erWeiMaWidth = 130*self.scale;
    if (code == tanChuViewWithErWeiMa2) {
        bgViewHeight = (163/2.25*self.scale +RM_Padding + erWeiMaWidth + RM_Padding + 30*self.scale + RM_Padding);
    }else if (code == tanChuViewWithGetShouYi){
        bgViewHeight = 543/2.25*self.scale;
    }
    
//    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nullTap:)];
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - grayViewWidth)/2.0, (self.view.height - bgViewHeight)/2, grayViewWidth, bgViewHeight)];
    _bgView.backgroundColor = whiteLineColore;
    _bgView.userInteractionEnabled = YES;
//    [_bgView addGestureRecognizer:tap];
    _bgView.layer.cornerRadius=5;
    _bgView.layer.masksToBounds=YES;
//     _bgView.tag=1111;
    [_tanChuView addSubview:_bgView];
    


    
    
    ///  上方删除键
    UIButton * deleImg=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [_tanChuView addSubview:deleImg];
    [deleImg addTarget:self action:@selector(removeTan) forControlEvents:UIControlEventTouchUpInside];
    [deleImg setBackgroundImage:[UIImage imageNamed:@"sy_delete"] forState:UIControlStateNormal];
    deleImg.right=_bgView.right-RM_Padding*2;
    deleImg.bottom=_bgView.top-RM_Padding*2;
    

    
    //上方蓝色视图
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, 163/2.25*self.scale)];
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:topImageView];
    
    topImageView.image = [UIImage ImageForColor:mainColor];
    topImageView.contentMode=UIViewContentModeScaleAspectFill;
    topImageView.clipsToBounds=YES;
    topImageView.height=topImageView.width*0.25;
    
    //中间图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(topImageView.width/2 - 110/2.25*self.scale/2, topImageView.height/2 - 110/2.25*self.scale/2, 110/2.25*self.scale, 110/2.25*self.scale)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [topImageView addSubview:imageView];

    //        imageView.image = [UIImage imageNamed:@"paizhao"];
    imageView.contentMode=UIViewContentModeCenter;
    imageView.center=CGPointMake(topImageView.width/2, topImageView.height/2);
    
    
    //中间描述Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, topImageView.bottom+RM_Padding, _bgView.width, 30*self.scale)];
    label.font = Big14Font(self.scale);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    [_bgView addSubview:label];

    
    //点击button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_bgView.width / 2 - 50*self.scale, label.bottom+RM_Padding, 80*self.scale, 30*self.scale)];
    button.layer.cornerRadius = button.height/2;
    button.centerX=_bgView.width/2;
    button.clipsToBounds = YES;
    button.titleLabel.font = DefaultFont(self.scale);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(liJiPeiSongEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:button];
    if(code == tanChuViewWithQiangDanFaile){
        _tanChuView.tag=1111;
        deleImg.hidden=YES;
        topImageView.image = [UIImage ImageForColor:underLineColor];
        imageView.image = [UIImage imageNamed:@"qiangdanshibai"];
        label.text=@"抢单失败";
        [button setTitle:@"再接再厉" forState:UIControlStateNormal];
    }else if(code == tanChuViewWithQiangDanSucess) {
//        _tanChuView.tag=1111;
        deleImg.hidden=YES;
        imageView.image = [UIImage imageNamed:@"qiangdanchenggong"];
        label.text=@"抢单成功";
        [button setTitle:@"立即配送" forState:UIControlStateNormal];
    }else if(code == tanChuViewWithTakePhoto){
        deleImg.hidden=YES;
        _bgView.height=_bgView.width*0.6;
        imageView.image = [UIImage imageNamed:@"paizhao"];
        label.top=topImageView.bottom+RM_Padding;
        label.text=@"请上传您的凭证照片";
//        _tanChuView.tag=1111;
        button.top=label.bottom+RM_Padding;
        [button setTitle:@"拍照" forState:UIControlStateNormal];
        _bgView.height=button.bottom+RM_Padding;
        
    }else if(code == tanChuViewWithErWeiMa1 || code == tanChuViewWithErWeiMa2){
//        topImageView.image = [UIImage imageNamed:@"tanchuang_bj"];
//        imageView.image = [UIImage imageNamed:@"tanchuang_icon01"];
//        label.hidden = YES;
//        button.hidden = YES;
        _tanChuView.tag=1111;
        topImageView.hidden=YES;
        button.hidden=YES;
        topImageView.height=RM_Padding;
      
        
        UIImageView *erWeiMaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_bgView.width/2 - erWeiMaWidth/2, topImageView.bottom + RM_Padding, erWeiMaWidth, erWeiMaWidth)];
        [erWeiMaImageView setImageWithURL:[NSURL URLWithString:message] placeholderImage:[UIImage imageNamed:@""]];
        erWeiMaImageView.backgroundColor = mainColor;
        [_bgView addSubview:erWeiMaImageView];
        
        UILabel *erWeiMalabel = [[UILabel alloc] initWithFrame:CGRectMake(0, erWeiMaImageView.bottom+RM_Padding, _bgView.width, 30*self.scale)];
        erWeiMalabel.textAlignment = NSTextAlignmentCenter;
        erWeiMalabel.text = @"扫一扫 有惊喜";
        erWeiMalabel.font = DefaultFont(self.scale);
        erWeiMalabel.textColor = blackTextColor;
        [_bgView addSubview:erWeiMalabel];
        
        _bgView.height=erWeiMalabel.bottom+RM_Padding;

        
        NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID,
                               @"Flag":code == tanChuViewWithErWeiMa1?@"1":@"0"};
        
        [self startDownloadDataWithMessage:nil];
        [AnalyzeObject getErWeiMaWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            
            if (CODE(ret)) {
                [erWeiMaImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,model[@"QRHref"]]] placeholderImage:[UIImage ImageForColor:[UIColor lightGrayColor]]];
            }else{
                [CoreSVP showMessageInCenterWithMessage:@"二维码获取失败"];
            }
        }];
        
    }else{
        deleImg.hidden=YES;
        topImageView.hidden=YES;
        _bgView.clipsToBounds=NO;
        _bgView.layer.masksToBounds=NO;
        _bgView.width=200;
        _bgView.center=self.view.center;
        _bgView.contentMode=UIViewContentModeCenter;
        _bgView.image= [UIImage imageNamed:@"ruzhang"];
        _bgView.backgroundColor=clearColor;
        
    
        
        
        button.layer.cornerRadius=5;
        button.layer.masksToBounds=NO;
        button.layer.borderColor=mainColor.CGColor;
        button.layer.borderWidth=0.5;
        [button setTitleColor:mainColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage ImageForColor:clearColor] forState:UIControlStateNormal];
        
        
        button.frame = CGRectMake(RM_Padding*2, _bgView.height/2 + 45*self.scale, _bgView.width - RM_Padding*4, 30*self.scale);
        [button setTitle:@"返回首页" forState:UIControlStateNormal];
        [button setTitleColor:mainColor forState:UIControlStateNormal];
        button.layer.borderColor = mainColor.CGColor;
        
        label.frame = CGRectMake(0, button.top - RM_Padding - 60*self.scale, _bgView.width, 60*self.scale);
        label.numberOfLines = 2;
        label.attributedText = [[NSString stringWithFormat:@"<black13>恭喜你本次收入</black13><orang20>%@</orang20><black13>元!\n继续加油哦！</black13>",message] attributedStringWithStyleBook:[self Style]];
        label.textAlignment = NSTextAlignmentCenter;
    }
}
-(void)liJiPeiSongEvent:(UIButton *)button{
    [self removeTan];
    if (_successBlock) {
        _successBlock();
    }

}
-(void)removeTan{
    if (_tanChuView) {
        [_tanChuView removeFromSuperview];
        _tanChuView = nil;
    }
}
-(void)commitKnockOffBlock:(AlertBlock)shougongBlock{
    //灰色的视图
    _alertBlock=shougongBlock;
    _tanChuView = [[UIView alloc] initWithFrame:self.view.frame];
    _tanChuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self.view addSubview:_tanChuView];
    
    
    
    // 可见的白色区域
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth*0.7,RM_VWidth*0.7)];
    [_tanChuView addSubview:bgView];
    bgView.center=_tanChuView.center;
    bgView.backgroundColor=whiteLineColore;
    bgView.layer.cornerRadius=5;
    bgView.layer.masksToBounds=YES;
    
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, bgView.width, 30*self.scale)];
    [bgView addSubview:label];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=DefaultFont(self.scale);
    label.textColor=blackTextColor;
    label.text=@"确定收工吗？";
    
    
    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(0, label.bottom+10*self.scale, bgView.width, bgView.height-label.bottom-60*self.scale)];
    [bgView addSubview:img];
    img.image=[UIImage imageNamed:@"tangkuang_shougong"];
    img.contentMode=UIViewContentModeScaleAspectFit;
    
    
    
    
    
    // 底部 按钮
    CellView * bottomView=[[CellView alloc]initWithFrame:CGRectMake(0, 0, bgView.width, 40*self.scale)];
    bottomView.topline.hidden=NO;
    [bgView addSubview:bottomView];
//    img.height=bottomView.top-10*self.scale - img.top;
    
    bottomView.bottom=bgView.height;
    for (int i = 0; i < 2 ; i ++) {
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(i * bottomView.width/2, 0, bottomView.width/2, bottomView.height)];
        [bottomView addSubview:btn];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(commitKnock:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font=DefaultFont(self.scale);
        [btn setTitleColor:i==0?blackTextColor:mainColor forState:UIControlStateNormal];
        [btn setTitle:i==0?@"再转一会":@"确定收工" forState:UIControlStateNormal];
        if (i==1) {
            UIImageView * sepLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bottomView.topline.height, btn.height)];
            [btn addSubview:sepLine];
            sepLine.backgroundColor=blackLineColore;
            
        }
        
    }
}
-(void)commitKnock:(UIButton *)sender {
    if (_alertBlock) {
        _alertBlock(sender.tag-100);
    }
    [self removeTan];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    BOOL isV=YES;
    for (UITouch * touch in touches.allObjects) {
        if (touch.view.tag==1111) { ///  点击的view  的tag值 为 1111时 不能被移除
            NSLog(@"%d",touch.view.tag);
            isV=NO;
        }
    }
    if (isV) {
        [self removeTan];
    }
}

#pragma mark -- 空数据
-(void)kongShuJuWithSuperView:(UIView *)view datas:(NSMutableArray *)datas{
    if (_kongImg) {
        [_kongImg removeFromSuperview];
        _kongImg = nil;
    }
    
    if ([datas count]==0 && !_kongImg) {
        _kongImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 130)];
        [view addSubview:_kongImg];
        _kongImg.center=CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
        
        UIImageView * topImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _kongImg.frame.size.width,_kongImg.frame.size.width)];
        topImg.image=[UIImage imageNamed:@"kongshuju"];
        topImg.contentMode=UIViewContentModeScaleAspectFit;
        [_kongImg addSubview:topImg];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, topImg.bottom+10, topImg.width, _kongImg.height-topImg.height)];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=DefaultFont(self.scale);
        label.textColor=blackTextColor;
        label.text=@"暂无数据";
        [_kongImg addSubview:label];
        
        
    }else if ([datas count]!=0 && _kongImg){
        [_kongImg removeFromSuperview];
        _kongImg = nil;
    }
    
    
}

#pragma mark - 屏幕选转
- (BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
/*-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}*/
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_tanChuView removeFromSuperview];
    _tanChuView = nil;
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
