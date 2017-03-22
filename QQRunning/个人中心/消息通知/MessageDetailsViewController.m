//
//  MessageDetailsViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "MessageDetailsViewController.h"
@interface MessageDetailsViewController()
@property (nonatomic,strong)UIWebView * webView;

@property (nonatomic,strong)NSMutableDictionary * dataDic;
@end
@implementation MessageDetailsViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    
    [self setupNewNavi];
    [self newView];
    
    [self reshData];
}
-(void)initData{
    _dataDic= [NSMutableDictionary dictionary];
}
-(void)newView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight-self.NavImg.height)];
    [self.view addSubview:_webView];
}
-(void)reshData{
    NSDictionary * dic = @{@"Id":_msgId};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getMessageDetailWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
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
    NSString * htmlString =[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"<!doctype html><html><body>%@</body></html>",_dataDic[@"Text"]] getValiedString]];
    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:htmlString]];
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"详情";
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

@end
