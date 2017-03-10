//
//  TextContentViewController.m
//  QQRunning
//
//  Created by wdx on 2017/3/10.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "TextContentViewController.h"

@interface TextContentViewController ()

@property (nonatomic,strong)NSString * parameter;

@property (nonatomic,strong)NSString * contentText;

@property (nonatomic,strong)UIScrollView * scrollView;
@end

@implementation TextContentViewController
+(instancetype)insWithTitle:(NSString *)title parameter:(NSString *)parameter{
    TextContentViewController * text = [[TextContentViewController alloc]initWithTitle:title parameter:parameter];
    return text;
}
-(instancetype)initWithTitle:(NSString *)title parameter:(NSString *)parameter{
    if (self = [super init]) {
        self.title=title;
        self.parameter=parameter;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewNavi];
    [self newView];
    [self reshData];
    
    // Do any additional setup after loading the view.
}
-(void)reshData{
    NSDictionary * dic = @{@"Flag":_parameter};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getAppTextWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            _contentText = [NSString stringWithFormat:@"%@",model[@"Text"]];
            [self reshView];
        }else{
            
        }
       
    }];
    
}
-(void)reshView{
 
    
    UILabel * label =[_scrollView viewWithTag:100];
    label.text=[NSString stringWithFormat:@"    %@",_contentText];
    [label sizeToFit];
    _scrollView.contentSize=CGSizeMake(_scrollView.width, label.bottom+RM_Padding);
    
}
-(void)newView{
  _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.height, RM_VWidth, RM_VHeight-self.NavImg.height)];
    [self.view addSubview:_scrollView];
    
  UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(RM_Padding, RM_Padding, _scrollView.width-2*RM_Padding , _scrollView.height-2*RM_Padding)];
    label.tag=100;
    label.font=DefaultFont(self.scale);
    label.textColor=blackTextColor;
    [_scrollView addSubview:label];
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
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = self.title;
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
