//
//  RegistXieYiViewController.m
//  QQRunning
//
//  Created by wdx on 2017/1/17.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "RegistXieYiViewController.h"

@interface RegistXieYiViewController ()
@property (nonatomic,strong)UIScrollView       * scrollView;
@property (nonatomic,strong)NSMutableDictionary* dataDic;

@end

@implementation RegistXieYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    [self setupNewNavi];
    [self newView];
    
    [self reshData];
    
    // Do any additional setup after loading the view.
}
-(void)initData{
    _dataDic=[NSMutableDictionary dictionary];
}
-(void)reshData{
    NSDictionary * dic = @{@"Flag":@"1"};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getAppTextWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        
        [_dataDic removeAllObjects];
        if (CODE(ret)) {
            [_dataDic addEntriesFromDictionary:model];
            
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        }
        [self reshView];
    }];
    
    
}
-(void)reshView{
    UILabel * label=[_scrollView viewWithTag:100];
    label.text=[[NSString stringWithFormat:@"%@",_dataDic[@"Text"]] getValiedString];
    [label sizeToFit];
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight-self.NavImg.height)];
    [self.view addSubview:_scrollView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(15*self.scale, 15*self.scale, RM_VWidth-30*self.scale, _scrollView.height-30*self.scale)];
    [_scrollView addSubview:label];
    
    label.textColor=blackTextColor;
    label.font=DefaultFont(self.scale);
    label.numberOfLines=0;
    label.tag=100;
    
    
    CGFloat setY=label.bottom;
    
    
    
    _scrollView.contentSize=CGSizeMake(RM_VWidth, setY);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupNewNavi
{

    
    
    self.TitleLabel.text = @"注册协议";
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

