//
//  UnFinishOrderDetailsViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/24.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "UnFinishOrderDetailsViewController.h"
#import "CellView.h"
#import "OrderDetailsViewController.h"
#import "peiSongZhongTableViewCell.h"
#import "orderDaoHangViewController.h"

#define codeBgViewWidth  [UIScreen mainScreen].bounds.size.width*0.6
#define codeBgViewHeight (163/2.25*self.scale + 30*self.scale + 30*self.scale + 10*self.scale*3)
@interface UnFinishOrderDetailsViewController()<UITableViewDelegate,UITableViewDataSource,peiSongZhongTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *statusButtonTitleArray;
@property (nonatomic,strong) NSArray *contentArray;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *stepArray;


@property (nonatomic,strong) NSMutableDictionary * dataDic;

@property (nonatomic,strong) UIView *codeView;
@property (nonatomic,strong) UIView *grayView;
@property (nonatomic,strong) UITextField *codeTextField;
@property (nonatomic,strong) UIImage * paizhaoImg;


@property (nonatomic,assign) BOOL isDismissCodeView;
@property (nonatomic,assign) CGFloat setY;
//倒计时
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)UILabel * timerLabel;
@property(nonatomic,strong)UILabel * allTimeLabel;
@property(nonatomic,assign)BOOL isQu;

@property(nonatomic,assign)NSInteger willLoadStep;


@property (nonatomic,assign) BOOL isPhoto;
@end

@implementation UnFinishOrderDetailsViewController
-(NSArray *)statusButtonTitleArray{
//    if (!_statusButtonTitleArray) {
    
        
        _statusButtonTitleArray=@[];
        if (self.orderType == OrderTypeBuy || self.orderType == OrderTypeTake || self.orderType == OrderTypeBring) {
            _statusButtonTitleArray = @[@"联系发货人",@"我已到达",@"去拍照",@"我已取货",@"联系收货人",@"我已送达",@"收货验证码"];
        }
        if (self.orderType == OrderTypeHelp || self.orderType == OrderTypeQueueUp) {
                _statusButtonTitleArray = @[@"联系",@"我已到达",@"去拍照",@"我已完成"];
        }
        if (self.orderType == OrderTypeMotocycleTaxi) {
                _statusButtonTitleArray = @[@"出发",@"已送达"];
        }
//    }
    return _statusButtonTitleArray;
}
-(NSArray *)contentArray{
//    if (!_contentArray) {
        _contentArray=@[];
        if (self.orderType == OrderTypeBuy || self.orderType == OrderTypeTake || self.orderType == OrderTypeBring) {
            _contentArray = @[@"请先致电发货人确定地址和时间",
                              @"到达取货地点后点击\n“我已到达”",
                              @"为了避免货物纠纷\n请在取货的时候拍照存证",
                              @"取货后点击\n“我已取货”",
                              @"请先致电收货人确定收货地址和时间",
                              @"到达收货地址后点击\n“我已送达”",
                              @"请向收货人要取短信验证码"];
        }
        if (self.orderType == OrderTypeHelp || self.orderType == OrderTypeQueueUp) {
            _contentArray = @[@"请先致电联系人确定地址和时间",@"到达帮忙地点后点击\n“我已到达”",@"为了避免货物纠纷\n请在到达地点后拍照存证",@"请向收货人要取短信验证码\n我已完成"];
        }
        if (self.orderType == OrderTypeMotocycleTaxi) {
            _contentArray = @[@"请确定确定出发地址和时间",@"到达后点击\n“我已到达”"];
        }
//    }
    return _contentArray;
}
-(NSArray *)titleArray{
//    if (!_titleArray) {
        _titleArray=@[];
        if (self.orderType == OrderTypeBuy || self.orderType == OrderTypeTake || self.orderType == OrderTypeBring) {
            _titleArray = @[@"致电联系人",@"我已到达",@"拍照",@"我已取货",@"致电收货人",@"我已送达",@"输入验证码"];
        }
        if (self.orderType == OrderTypeHelp || self.orderType == OrderTypeQueueUp) {
            _titleArray = @[@"致电联系人",@"我已到达",@"拍照",@"我已完成"];
        }
        if(self.orderType == OrderTypeMotocycleTaxi){
            _titleArray = @[@"我已出发",@"我已完成"];
        }
//    }
    return _titleArray;
}
-(NSArray *)stepArray{
//    if (!_stepArray) {
        _stepArray = @[@"(第一步)",@"(第二步)",@"(第三步)",@"(第四步)",@"(第五步)",@"(第六步)",@"(第七步)"];
//    }
    return _stepArray;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    
    [self setupNewNavi];
    [self setupBottomView];
    [self setupTopView];
    [self setupTableView];
    
    
    [self reshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark -- 界面
-(void)setupTopView
{
    CellView *topView = [[CellView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, 70*self.scale)];
    topView.backgroundColor=mainColor;
    [self.view addSubview:topView];
    
    UIButton * topBtn=[[UIButton alloc]initWithFrame:CGRectMake(RM_Padding, RM_Padding, 70, 40)];
    [topView addSubview:topBtn];
    topBtn.tag=44;
    [topBtn setImage:[UIImage imageNamed:@"didanzhuangtai"] forState:UIControlStateNormal];
    topBtn.titleLabel.numberOfLines=2;
    [topBtn setAttributedTitle:[[NSString stringWithFormat:@"<white14> 订单配送中</white14>\n<white10> 预计%@分送达</white10>",@"00:14:23"]attributedStringWithStyleBook:[self Style]] forState:UIControlStateNormal];
//    self.Style
    [topBtn sizeToFit];
//    self.Style
    
    
    NSArray *titleArray=[NSArray array];
    if (self.orderType == OrderTypeBuy || self.orderType == OrderTypeTake || self.orderType == OrderTypeBring) {
        titleArray  = @[@"取货",@"送货",@"完成"];
    }
    if (self.orderType == OrderTypeHelp || self.orderType == OrderTypeQueueUp) {
        titleArray  = @[@"确定",@"拍照",@"完成"];
    }
    if (self.orderType == OrderTypeMotocycleTaxi) {
        titleArray  = @[@"确定",@"拍照",@"完成"];
    }
    
    
    float blankWidth = 50*self.scale;
    float paddingY = RM_Padding*3 + topBtn.bottom;
    float setX = blankWidth;
    float imageViewWidth = 42/2.25*self.scale;
    imageViewWidth=10*self.scale;
    
    
    float lineWidth = (topView.width  - imageViewWidth*3 - setX*2)/2;
    for (int i =0 ; i < 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(setX, paddingY, imageViewWidth, imageViewWidth)];
//        imageView.image = [UIImage imageNamed:@"peisong_topdian02"];
//        imageView.highlightedImage = [UIImage imageNamed:@"peisong_topdian01"];
        imageView.image=[UIImage ImageForColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        imageView.highlightedImage=[UIImage ImageForColor:[UIColor whiteColor]];
        imageView.layer.cornerRadius=imageView.height/2;
        imageView.layer.borderColor=mainColor.CGColor;
        imageView.layer.masksToBounds=YES;
        imageView.layer.borderWidth=2;
        imageView.tag=100+i;
        [topView addSubview:imageView];
        topView.height=imageView.bottom+RM_Padding*2;

        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(setX+imageViewWidth/2 - 30*self.scale, imageView.bottom, 60*self.scale, topView.height - imageView.bottom)];
        label.highlightedTextColor=[UIColor whiteColor];
        label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        label.tag=110+i;
        label.text = titleArray[i];
        label.font = DefaultFont(self.scale);
        label.textAlignment = 1;
        label.bottom=imageView.top;
        [topView addSubview:label];
        setX = imageView.right + lineWidth;
        

    }
    float setLineX = blankWidth + imageViewWidth;
    for (int i = 0; i < 2; i ++) {
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(setLineX , paddingY+imageViewWidth/2-0.5, lineWidth, 1)];
        line.image=[UIImage ImageForColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        line.highlightedImage=[UIImage ImageForColor:[UIColor whiteColor]];
        line.tag=120+i;
        [topView addSubview:line];
        setLineX = line.right + imageViewWidth;
    }
    
    
    
    CellView *cellView = [[CellView alloc] initWithFrame:CGRectMake(0,topView.bottom, RM_VWidth, 70*self.scale)];
    _setY=cellView.bottom;
    
    cellView.backgroundColor = whiteLineColore;
    cellView.topline.hidden = NO;
    cellView.bottomline.hidden = YES;
    [self.view addSubview:cellView];
    
    UIImageView *timeBgView = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding, RM_Padding,cellView.width-RM_Padding*2, (cellView.width-RM_Padding*2)*0.174)];
    timeBgView.image = [UIImage imageNamed:@"bg_jindu"];
//    timeBgView.contentMode = UIViewContentModeScaleAspectFit;
    timeBgView.clipsToBounds = YES;
    [cellView addSubview:timeBgView];
    
    
    UIImageView *timerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,timeBgView.width/2, timeBgView.height)];
    timerImageView.image = [UIImage imageNamed:@"bg_shijian"];
//    timerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [timeBgView addSubview:timerImageView];
//    timerImageView.tag=1001;
    
    UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, timerImageView.width-RM_Padding, timerImageView.height)];
    timerLabel.text = @"";
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.font = SmallFont(self.scale);
    timerLabel.textColor = blackTextColor;
    timerLabel.attributedText =[[NSString stringWithFormat:@"剩余时间<orang14>%@</orang14>",@"00:00:00 "] attributedStringWithStyleBook:[self Style]];
    [timerLabel sizeToFit];
    timerLabel.centerY=timerImageView.height/2;
    [timerImageView addSubview:timerLabel];
    timerImageView.width=timerLabel.width+15;
    _timerLabel=timerLabel;
//    timerLabel.tag=1002;
    [self timerEvent];
    
    
    UILabel *allTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timerImageView.right, 0, timeBgView.width - timerImageView.width, timeBgView.height)];
    _allTimeLabel=allTimeLabel;
    allTimeLabel.textAlignment = NSTextAlignmentCenter;
    allTimeLabel.font = SmallFont(self.scale);
    allTimeLabel.textColor = blackTextColor;
    
    NSString * contentText=@"";
    if (self.orderType == OrderTypeBuy || self.orderType == OrderTypeTake || self.orderType == OrderTypeBring) {
      contentText=@"分钟内到达取货地点";
    }
    if (self.orderType == OrderTypeHelp || self.orderType == OrderTypeQueueUp) {
       contentText=@"分钟内完成订单任务";
    }
    allTimeLabel.attributedText =[[NSString stringWithFormat:@"请在<orang14>%@</orang14>%@",@"",contentText] attributedStringWithStyleBook:[self Style]];
    
    [timeBgView addSubview:allTimeLabel];
}
#pragma mark  -- 剩余时间 进行计时
-(void)timerEvent{//
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reshTimerView) userInfo:nil repeats:YES];
}
-(void)reshTimerView{
   
    
    NSDate * date = [NSDate date];
    NSTimeInterval nowTimeInterval = [date timeIntervalSince1970];
    
    
    
    NSDateFormatter * formoatter =[NSDateFormatter new];
    formoatter.dateFormat=@"yy-MM-dd HH:mm:ss";
    formoatter.dateFormat=@"MM/dd/yy HH:mm:ss";
    
    
    NSDate * startTime = [formoatter dateFromString:[NSString stringWithFormat:@"%@",_dataDic[@"StartTime"]]];
    NSDate * endTime   = [formoatter dateFromString:[NSString stringWithFormat:@"%@",_dataDic[@"EndTime"]]];
    
    
    
    
//    NSString * qiangOrderTimeString = [NSString stringWithFormat:@"%@",_dataDic[@"QiangDanTime"]];
//    NSDate * qiangOrderTime = [formoatter dateFromString:qiangOrderTimeString];
//    NSTimeInterval  qiangOrderTimeInterval = [qiangOrderTime timeIntervalSince1970];
//    
//    

    NSInteger  dao;
    NSInteger  min;
    min = [endTime timeIntervalSinceDate:startTime]/60;
    dao = [endTime timeIntervalSinceDate:[NSDate date]];
    
    
    
    
    NSString * contentText=@"";
    if (self.orderType == OrderTypeBuy || self.orderType == OrderTypeTake || self.orderType == OrderTypeBring) {
        if (_isQu) {/// 已经取过
            contentText=@"分钟内到达收货地点";
        }else{
            contentText=@"分钟内到达取货地点";
        }
        
    }
    if (self.orderType == OrderTypeHelp || self.orderType == OrderTypeQueueUp) {
        _isQu=NO;
        contentText=@"分钟内完成订单任务";
    }
    
    
    
    _allTimeLabel.attributedText =[[NSString stringWithFormat:@"请在<orang14>%@</orang14>%@",@(min),contentText] attributedStringWithStyleBook:[self Style]];

    NSString * daojishi = [self getTimeTextWithDaoJiShi:dao];
    _timerLabel.attributedText =[[NSString stringWithFormat:@"剩余时间<orang14>%@</orang14>",daojishi] attributedStringWithStyleBook:[self Style]];
    [_timerLabel sizeToFit];
    _timerLabel.width=_timerLabel.width+15*self.scale;
}

-(NSString *)getTimeTextWithDaoJiShi:(NSInteger)daoJiShi{
    if (daoJiShi<=0) {
        daoJiShi=0;
    }
    
    NSInteger second = daoJiShi % 60 ; // 整秒
    NSInteger minute = daoJiShi / 60 % 60 ;  /// 整分钟
    NSInteger hour   = daoJiShi / 60 / 60 % 24 ; // 整小时
//    NSInteger day    = daoJiShi / 60 / 60 / 24 % 30 ;// 整天
    NSMutableArray * dateArray  = [NSMutableArray array];
//    [dateArray addObjectsFromArray:@[@(hour),@(minute),@(second)]];
    
    NSString * hourS =  [NSString stringWithFormat:@"%ld",(long)hour];
    NSString * minuteS = [NSString stringWithFormat:@"%ld",(long)minute];
    NSString * secondS = [NSString stringWithFormat:@"%ld",(long)second];
    if (hourS.length==1) {
        hourS = [@"0" stringByAppendingString:hourS];
    }
    if (minuteS.length==1) {
        minuteS = [@"0" stringByAppendingString:minuteS];
    }
    if (secondS.length==1) {
        secondS = [@"0" stringByAppendingString:secondS];
    }
    
    [dateArray addObjectsFromArray:@[hourS,minuteS,secondS]];
    
//    if (day==0) {
//        [dateArray removeObjectAtIndex:0];
//        if (hour==0) {
//            [dateArray removeObjectAtIndex:0];
//            if (minute==0) {
//                [dateArray removeObjectAtIndex:0];
//            }
//        }
//    }
    
    NSString * timeText = [dateArray componentsJoinedByString:@":"];
    return timeText;
}

-(void)initData{
    _isQu=NO;
    _isPhoto=NO;
    _willLoadStep=2;
    _step=1;
    _dataDic=[NSMutableDictionary dictionary];
}
-(void)setupTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _setY, self.view.width, self.view.height - _setY - 40*self.scale ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = superBackgroundColor;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[peiSongZhongTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
-(void)reshData{
    
    
    NSDictionary * dic = @{@"OrderId":_orderId};
    
    [self startDownloadDataWithMessage:nil];
    
    [_dataDic removeAllObjects];
    [AnalyzeObject getUnFinishOrderDetailWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            [_dataDic addEntriesFromDictionary:model];
       
            _step=[[NSString stringWithFormat:@"%@",_dataDic[@"Status"]] integerValue];
            if (_step>=3) {
                _isQu=YES;
            }
            
            
            self.orderType = [[NSString stringWithFormat:@"%@",_dataDic[@"Type"]] integerValue];
            [self reshView];
        }else{
            [CoreSVP showMessageInBottomWithMessage:msg];
        }
    }];
}
-(void)stepAction{

    NSMutableDictionary * mDic = [NSMutableDictionary dictionaryWithDictionary:
                 @{@"OrderId":[[NSString stringWithFormat:@"%@",_dataDic[@"OrderId"]] getValiedString],
                   @"Status":@(_willLoadStep)}];
    if (_codeTextField.text) {
        [mDic setValue:_codeTextField.text forKey:@"CodeNum"];
    }
    
    if (_paizhaoImg && [[NSString stringWithFormat:@"%@",_dataDic[@"Status"]] isEqualToString:@"3"]) {
        NSData * data = UIImageJPEGRepresentation(_paizhaoImg, .5);
        NSString * imgString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [mDic setValue:imgString forKey:@"Image1"];
    }
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:mDic];
    
    [self startDownloadDataWithMessage:nil];
    
    
    if (self.orderType == OrderTypeBuy || self.orderType == OrderTypeTake || self.orderType == OrderTypeBring) {
        [AnalyzeObject changeOrderStateBuyBringTakeWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            if (CODE(ret)) {
//                _step=[[NSString stringWithFormat:@"%@",model[@"Status"]] integerValue];
//                _shouYi=[NSString stringWithFormat:@"%@",model[@"Money"]];
                
                if (_step==2) {// 在 数据没有更新前 如果 状态为 已到达 则保存当前时间
                   
                }
                if (_step==6) {
                    [self ShowQiangDanResultMessage:[NSString stringWithFormat:@"%@",model[@"Money"]] WithCode:tanChuViewWithGetShouYi WithBlock:^{
            
                        if (_block) {
                            _block();
                        }
                        [self.navigationController popViewControllerAnimated:YES ];
                    }];
                }else{
                    [self reshData];
                }
             
            }else{
                [CoreSVP showMessageInBottomWithMessage:msg];
            }
        }];
    }
    if (self.orderType == OrderTypeHelp || self.orderType == OrderTypeQueueUp) {
      [AnalyzeObject changeOrderStateHelpWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
          [self stopDownloadData];
          if (CODE(ret)) {
//              _step=[[NSString stringWithFormat:@"%@",model[@"Status"]] integerValue];
              
              
              if (_step==10) {
//                  _shouYi=[NSString stringWithFormat:@"%@",model[@"Money"]];
                  [self ShowQiangDanResultMessage:[NSString stringWithFormat:@"%@",model[@"Money"]] WithCode:tanChuViewWithGetShouYi WithBlock:^{
                      if (_block) {
                          _block();
                      }
                      [self.navigationController popViewControllerAnimated:YES ];
                  }];
              }else{
                  [self reshData];
              }
          }else{
              [CoreSVP showMessageInBottomWithMessage:msg];
          }

      }];
    }

    
   
}
-(void)reshView{
    UIButton * topBtn =[self.view viewWithTag:44];
    [topBtn setAttributedTitle:[[NSString stringWithFormat:@"<white14> 订单配送中</white14>\n<white10> 预计%@送达</white10>",_dataDic[@"YuSongDaTime"]]attributedStringWithStyleBook:[self Style]] forState:UIControlStateNormal];
    if (self.orderType==OrderTypeHelp || self.orderType==OrderTypeQueueUp) {
            [topBtn setAttributedTitle:[[NSString stringWithFormat:@"<white14> 待完成  </white14>\n<white10> 立即前往%@</white10>",@""]attributedStringWithStyleBook:[self Style]] forState:UIControlStateNormal];
    }
    [topBtn sizeToFit];
    if (self.orderType ==  OrderTypeHelp || self.orderType == OrderTypeQueueUp) {
        self.TitleLabel.text=@"帮忙中";
    }else{
        self.TitleLabel.text=@"配送中";
    }
    
    
    if (_step==8) {
        [CoreSVP showMessageInCenterWithMessage:@"用户已取消该订单!"];
//        [self ShowAlertTitle:@"提示" Message:@"该订单已被取消" Delegate:self OKText:@"继续查看" CancelText:@"返回主页" Block:^(NSInteger index) {
//            if (index==0) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }];
    }
    
    NSInteger topStep =  0;
    if (_step==7) {
        [self ShowOKAlertWithTitle:@"提示" Message:@"该订单已完成" WithButtonTitle:@"返回首页" Blcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    
//    if (_step==3 && _isPhoto) {
//        _step=10;
//        _isPhoto=NO;
//    }
    NSInteger step = [self tranlate:_step];
   
    
    
    if (self.orderType == OrderTypeBuy || self.orderType == OrderTypeTake || self.orderType == OrderTypeBring) {
        _titleArray = @[@"致电联系人",@"我已到达",@"拍照",@"我已取货",@"致电收货人",@"我已送达",@"输入验证码"];
        if (step > 0) {
            topStep=1;
            if (step > 5) {
                topStep=2;
                if (step > 6) {
                    topStep=3;
                }
            }
        }
//        if (step>1) {
//            _isQu=YES;
//        }else{
//            _isQu=NO;
//        }
    }
    if (self.orderType == OrderTypeHelp || self.orderType == OrderTypeQueueUp) {
        _titleArray = @[@"致电联系人",@"我已到达",@"拍照",@"我已完成"];
        if (step > 0) {
            topStep=1;
            if (step > 2) {
                topStep=2;
                if (step > 3) {
                    topStep=3;
                }
            }
        }
    }
    if(self.orderType == OrderTypeMotocycleTaxi){
        _titleArray = @[@"我已出发",@"我已完成"];
        if (_step > 0) {
            topStep=1;
            if (_step >= 1) {
                topStep=3;
            }
        }
    }
    [self reshProgressWithStep:topStep];
    [_tableView reloadData];
}
#pragma mark --  刷新  顶部带文字的进度条 0 1 2
-(void)reshProgressWithStep:(NSInteger)step{
    UIImageView * point1=[self.view viewWithTag:100];
    point1.highlighted=NO;
    UIImageView * point2=[self.view viewWithTag:101];
    point2.highlighted=NO;
    UIImageView * point3=[self.view viewWithTag:102];
    point3.highlighted=NO;
    
    UILabel * label1=[self.view viewWithTag:110];
    label1.highlighted=NO;
    UILabel * label2=[self.view viewWithTag:111];
    label2.highlighted=NO;
    UILabel * label3=[self.view viewWithTag:112];
    label3.highlighted=NO;
    
    UIImageView * line1=[self.view viewWithTag:120];
    line1.highlighted=NO;
    UIImageView * line2=[self.view viewWithTag:121];
    line2.highlighted=NO;
    
    
    switch (step) {
        case 1:
        {
            point1.highlighted=YES;
            label1.highlighted=YES;
            line1.highlighted=YES;
        }
            break;
        case 2:
        {
            point1.highlighted=YES;
            label1.highlighted=YES;
            line1.highlighted=YES;
            
            point2.highlighted=YES;
            label2.highlighted=YES;
            line2.highlighted=YES;
          
        }
            break;
        case 3:
        {
            point1.highlighted=YES;
            label1.highlighted=YES;
            line1.highlighted=YES;
            
            point2.highlighted=YES;
            label2.highlighted=YES;
            line2.highlighted=YES;
            
            point3.highlighted=YES;
            label3.highlighted=YES;
           
        }
            break;
        default:
            break;
    }
}
-(void)setupBottomView{
    
    CellView *bottomView = [[CellView alloc] initWithFrame:CGRectMake(0, RM_VHeight - 40*self.scale, RM_VWidth, 40*self.scale)];
    bottomView.topline.hidden = NO;
    [self.view addSubview:bottomView];
    
    //导航或者返回首页
    UIButton *daoHangButton = [[UIButton alloc] initWithFrame:CGRectMake(bottomView.right - RM_Padding - 80*self.scale, bottomView.height/2 - 15*self.scale, 80*self.scale, 30*self.scale)];
    [daoHangButton setTitle:@"查看导航" forState:UIControlStateNormal];
    [daoHangButton setTitleColor:mainColor forState:UIControlStateNormal];
    daoHangButton.titleLabel.font = Big14Font(self.scale);
    daoHangButton.layer.borderColor = mainColor.CGColor;
    daoHangButton.layer.borderWidth = 0.5;
    daoHangButton.layer.cornerRadius = RM_CornerRadius;
    daoHangButton.clipsToBounds = YES;
    [daoHangButton addTarget:self action:@selector(daoHangButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:daoHangButton];
    
    
    UIButton *orderDetailsButton = [[UIButton alloc] initWithFrame:CGRectMake(daoHangButton.left - RM_Padding - daoHangButton.width, daoHangButton.top, daoHangButton.width, daoHangButton.height)];
    [orderDetailsButton setTitle:@"订单详情" forState:UIControlStateNormal];
    [orderDetailsButton setTitleColor:grayTextColor forState:UIControlStateNormal];
    orderDetailsButton.titleLabel.font = Big14Font(self.scale);
    orderDetailsButton.layer.borderColor = blackLineColore.CGColor;
    orderDetailsButton.layer.borderWidth = 0.5;
    orderDetailsButton.layer.cornerRadius = RM_CornerRadius;
    orderDetailsButton.clipsToBounds = YES;
    [orderDetailsButton addTarget:self action:@selector(orderDetailsButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:orderDetailsButton];
    
}
#pragma mark -- tableViewCell代理事件
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statusButtonTitleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    peiSongZhongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.leftStepLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1] ;
    cell.stepLabel.text = self.stepArray[indexPath.row];
    cell.contentLabel.text = self.contentArray[indexPath.row];
    [cell.statusButton setTitle:_statusButtonTitleArray[indexPath.row] forState:UIControlStateNormal];

   
    
    //  竖线 是否隐藏
    cell.stepLineUp.hidden=indexPath.row==0?YES:NO;
    cell.stepLineDown.hidden=indexPath.row==self.statusButtonTitleArray.count-1?YES:NO;
    
    
    if (indexPath.row == [self tranlate:_step]){
        cell.statusType = 1;
    }else {
        cell.statusType = 0;
    }
    NSLog(@"%ld",(long)[self tranlate:_step]);
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = 0;
    cell.shortLine.hidden = indexPath.row == self.titleArray.count - 1;
    cell.bottomLine.hidden = !cell.shortLine.hidden;
    return cell;
}
-(NSInteger)tranlate:(NSInteger)type{
    NSInteger afterType=0;
    if (self.orderType==OrderTypeBuy||self.orderType==OrderTypeBring||self.orderType==OrderTypeTake) {
        if (type==1 || type==2) {/// 转化后 为 0 ，1
            afterType=type-1;
        }
        if (type>3) {/// 转化后 为 4，5，6
            afterType=type;
        }
        _willLoadStep=type+1;
        if (type==3) {/// 转化后 为2
            afterType=2;
            _willLoadStep=10;// 拍照
        }
        if (type==10) { // 转化后 为3
            afterType=3;
            _willLoadStep=4;
        }

    }
    if (self.orderType==OrderTypeQueueUp||self.orderType==OrderTypeHelp) {
        if (type == 1 || type == 2) { /// 转化后 为 0 ，1
            afterType=type-1;
            _willLoadStep=type+1;
        }
        if (type==3) { // 转化后 为 2
            afterType=2;
            _willLoadStep=10;//拍照
        }
        if (type==10) { // 转化后 为3
            afterType=3;
            _willLoadStep=7;
        }
        if (type==7) {/// 转化后 为3
            afterType=3;
            _willLoadStep=7;
        }
    }
//    if (self.orderType==OrderTypeMotocycleTaxi) {
//        if (type==4) {
//            afterType=0;
//        }
//        if (type==7) {
//            afterType=1;
//        }
//        
//        
//    }
    return afterType;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return RM_Padding;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RM_VWidth, RM_Padding)];
    bgView.backgroundColor = superBackgroundColor;
    return bgView;
}
#pragma mark -- 配送中TableCell的代理
-(void)peiSongZhongTableViewCellDelegateWithIndex:(NSIndexPath *)indexpath{
    if (self.orderType == OrderTypeBuy || self.orderType == OrderTypeTake || self.orderType == OrderTypeBring) {//买送取
        switch (indexpath.row) {
            case 0:
            {
                NSString * tel = [NSString stringWithFormat:@"%@",_dataDic[@"QITel"]];
                if (self.orderType==OrderTypeBuy) { //
                    tel =[NSString stringWithFormat:@"%@",_dataDic[@"UserTel"]];
                }
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
                BOOL isSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                if (isSuccess) {
                    [self stepAction];/// 联系发货人
                }
                
                break;
            }
            case 1:
            {
                [self stepAction]; ///我已到达
//                [CoreSVP showMessageInCenterWithMessage:@"我已到达"];
                break;
            }
            case 2:
            {
                [self ShowQiangDanResultMessage:nil WithCode:tanChuViewWithTakePhoto WithBlock:^{
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        imagePicker.delegate = self;
                        //            imagePicker.allowsEditing = YES;
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    }
                }];
                break;
            }
            case 3:
            {
                [self stepAction]; // 我已取货
//                [CoreSVP showMessageInCenterWithMessage:@"我已取货"];
                break;
            }
            case 4:
            {
                NSString * tel = [NSString stringWithFormat:@"%@",_dataDic[@"ZhongTel"]];
                
                
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
                BOOL isSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                if (isSuccess) {
                    [self stepAction];/// 联系发货人
                }
                break;
            }
            case 5:
            {
                [self stepAction]; /// 我已送达
                [CoreSVP showMessageInCenterWithMessage:@"我已送达"];
                break;
            }
            case 6:
            {
                //验证码
                _isDismissCodeView = YES;
                [self showYanZhengMaView];

                break;
            }
            default:
                break;
        }

    }
    if (self.orderType == OrderTypeHelp || self.orderType == OrderTypeQueueUp) {//帮忙 排队
        switch (indexpath.row) {
            case 0:
            {
                NSString * tel = [NSString stringWithFormat:@"%@",_dataDic[@"QITel"]];
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
               BOOL isSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                if (isSuccess) {
                    [self stepAction];/// 联系发货人
                }
                break;
            }
            case 1:
            {
                [self stepAction]; //   我已到达
//                [CoreSVP showMessageInCenterWithMessage:@"我已到达"];
                break;
            }
            case 2:
            {
                
                [self ShowQiangDanResultMessage:nil WithCode:tanChuViewWithTakePhoto WithBlock:^{
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        imagePicker.delegate = self;
                        //            imagePicker.allowsEditing = YES;
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    }
                }];
                break;
            }
            case 3:
            {
                //验证码
                _isDismissCodeView = YES;
                [self showYanZhengMaView];
                break;
            }
            default:
                break;
        }        
    }

    if (self.orderType==OrderTypeMotocycleTaxi) {
        switch (indexpath.row) {
            case 0: // 乘客以上车
            {
                [self stepAction];
//                [CoreSVP showMessageInCenterWithMessage:@"乘客以上车"];
                break;
            }
                break;
            case 1: // 乘客到达目的地
            {
                [self stepAction];
//                [CoreSVP showMessageInCenterWithMessage:@"乘客到达目的地"];
                break;
            }
                break;
            default:
                break;
        }
    }
    
    
    [_tableView reloadData];
    
 }
#pragma mark -- 点击事件
//导航或者返回首页
-(void)daoHangButtonEvent:(UIButton *)button{
    //
    orderDaoHangViewController * daohang = [orderDaoHangViewController new];
    
    
    daohang.longitude=[[NSString stringWithFormat:@"%@",_dataDic[@"QILng"]] floatValue];
    daohang.latitude=[[NSString stringWithFormat:@"%@",_dataDic[@"QILat"]] floatValue];
    [self.navigationController pushViewController:daohang animated:YES];

    
}
//订单详情
-(void)orderDetailsButtonEvent:(UIButton *)button{
    OrderDetailsViewController *orderDetailsVC = [OrderDetailsViewController new];
    orderDetailsVC.orderType=self.orderType;
    orderDetailsVC.orderId=self.orderId;
    orderDetailsVC.dataDic=_dataDic;
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
}
//验证码确认按钮事件
-(void)OKButtonEvent:(UIButton *)button{
    [self CloseView];
    if ([_codeTextField.text trimString].length != RM_CodeLength) {
        [CoreSVP showMessageInCenterWithMessage:@"请输入正确的验证码"];
        return;
    }
    [self stepAction];
    
 
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self CloseView];
}
-(void)CloseView{
    if (_isDismissCodeView || [_codeTextField.text trimString].length == RM_CodeLength) {
        [_grayView removeFromSuperview];
        _grayView = nil;
    }else{
        _isDismissCodeView = YES;
        [self.view endEditing:YES];
    }  
}
#pragma mark -- 验证码视图
-(void)showYanZhengMaView{
    //灰色的视图
    _grayView = [[UIView alloc] initWithFrame:self.view.frame];
    _grayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self.view addSubview:_grayView];
    
    //整个弹出的视图
    _codeView = [[UIView alloc] initWithFrame:CGRectMake((_grayView.width - codeBgViewWidth)/2.0, (_grayView.height - codeBgViewHeight)/2, codeBgViewWidth, codeBgViewHeight)];
    _codeView.backgroundColor = whiteLineColore;
    
    [_grayView addSubview:_codeView];
    
    //上方蓝色视图
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _codeView.width,50*self.scale)];
    topImageView.image = [UIImage ImageForColor:mainColor];
//    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_codeView addSubview:topImageView];
    //中间图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(topImageView.width/2 - 110/2.25*self.scale/2, topImageView.height/2 - 110/2.25*self.scale/2, 110/2.25*self.scale, 110/2.25*self.scale)];
    imageView.image = [UIImage imageNamed:@"yanzhengma"];
    imageView.contentMode = UIViewContentModeCenter;
    [topImageView addSubview:imageView];
    //codeTextField
    UIView *bianKuangView = [[UIView alloc] initWithFrame:CGRectMake(RM_Padding*2, topImageView.bottom+RM_Padding, _codeView.width-RM_Padding*4, 30*self.scale)];
    bianKuangView.layer.borderColor = blackLineColore.CGColor;
    bianKuangView.layer.borderWidth = 0.5;
    bianKuangView.layer.cornerRadius = RM_CornerRadius;
    bianKuangView.clipsToBounds = YES;
    [_codeView addSubview:bianKuangView];
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(RM_Padding, 0, bianKuangView.width-RM_Padding*2, bianKuangView.height)];
    _codeTextField.font = Big14Font(self.scale);
    [_codeTextField setMaxLength:RM_CodeLength];
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextField.placeholder = @"请输入短信验证码";
    [bianKuangView addSubview:_codeTextField];
    //点击button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(bianKuangView.left, bianKuangView.bottom+RM_Padding, 80*self.scale, bianKuangView.height-5)];
    button.centerX=_codeView.width/2;
    button.tag = 10;
    button.layer.cornerRadius = button.height/2;
    
    button.clipsToBounds = YES;
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [button setTitleColor:whiteLineColore forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    button.backgroundColor = blackLineColore;
    button.titleLabel.font = DefaultFont(self.scale);
    [button addTarget:self action:@selector(OKButtonEvent:) forControlEvents:UIControlEventTouchUpInside
     ];
    [_codeView addSubview:button];
    _codeView.height=button.bottom+RM_Padding;
    
}

#pragma mark --通知事件
-(void)TextFieldChange{
    UIButton *okButton = (UIButton *)[_grayView viewWithTag:10];
    if ([_codeTextField.text trimString].length != RM_CodeLength) {
        okButton.backgroundColor = blackLineColore;
        okButton.userInteractionEnabled = NO;
    }else{
        okButton.backgroundColor = mainColor;
        okButton.userInteractionEnabled = YES;
    }
}
-(void)keyboardChangeFrame:(NSNotification *)notification{
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //判断键盘是否把验证码视图遮盖，若遮盖把验证码视图上移，若没有则不动
    if (rect.origin.y < _codeView.bottom) {
        [UIView animateWithDuration:duration animations:^{
            _codeView.frame=CGRectMake((_grayView.width - codeBgViewWidth)/2.0, (rect.origin.y - codeBgViewHeight - RM_Padding), codeBgViewWidth, codeBgViewHeight);
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            _codeView.frame=CGRectMake((_grayView.width - codeBgViewWidth)/2.0, (_grayView.height - codeBgViewHeight)/2, codeBgViewWidth, codeBgViewHeight);
        }];
    }
    
    if (rect.origin.y < self.view.bottom) {
        _isDismissCodeView = NO;
    }else{
        _isDismissCodeView = YES;
    }

}
#pragma mark -- 倒计时
-(void)daoJiShi
{
    UIButton *btn=(UIButton *)[self.view viewWithTag:5];
    if (_time == 0) {
        [_timer invalidate];
        _timer = nil;
        btn.enabled=YES;
        [btn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [btn setTitleColor:whiteLineColore forState:UIControlStateNormal];
        btn.backgroundColor = matchColor;
        _time = 60;
    }else
    {
        [btn setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)_time] forState:UIControlStateNormal];
        [btn setTitleColor:whiteLineColore forState:UIControlStateNormal];
        btn.backgroundColor = blackLineColore;
        btn.enabled=NO;
        _time--;
    }
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"配送中";
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


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _paizhaoImg = image;
    [self stepAction];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
