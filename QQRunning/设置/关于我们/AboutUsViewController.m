//
//  AboutUsViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (nonatomic,strong)NSMutableDictionary* dataDic;

@property (nonatomic,strong)UIWebView * webView;
@end

@implementation AboutUsViewController

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
    [self reshView];
    NSDictionary * dic = @{@"Flag":@"6"};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getAppTextWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        [_dataDic removeAllObjects];
        if (CODE(ret)) {
            [_dataDic addEntriesFromDictionary:model];
        }else{
            
        }
        [self reshView];
    }];
    
}
-(void)reshView{
    NSString * htmlString =[NSString stringWithFormat:@"<!DOCTYPE html><html><body>%@</body></html>",[[NSString stringWithFormat:@"%@",_dataDic[@"Text"]] getValiedString]];
    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:htmlString]];
}
-(void)newView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight-self.NavImg.height)];
    [self.view addSubview:_webView];
}

-(void)setupNewNavi
{
    self.TitleLabel.text = @"关于我们";
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
