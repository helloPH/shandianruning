//
//  KuaiCheSuccess.m
//  QQRunning
//
//  Created by wdx on 2017/2/10.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "KuaiCheSuccess.h"

@interface KuaiCheSuccess ()

@end

@implementation KuaiCheSuccess

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNewNavi];
    [self newView];
    
    // Do any additional setup after loading the view.
}
-(void)newView{
    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50*self.scale, 50*self.scale)];
    img.image=[UIImage imageNamed:@"chenggong"];
    [self.view addSubview:img];
    img.top=self.NavImg.bottom+30*self.scale;
    img.centerX=RM_VWidth/2;
 
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 20*self.scale)];
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    label.text=[NSString stringWithFormat:@"本次行程收入%@元",_shouRu];
    label.attributedText = [[NSString stringWithFormat:@"<black15>本次行程收入</black15><orang15>%@</orang15><black15>元<black15>",_shouRu] attributedStringWithStyleBook:[self Style]];
    label.top=img.bottom+20*self.scale;
    
    
    UILabel * subTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 20*self.scale)];
    [self.view addSubview:subTitle];
    subTitle.font=Big15Font(self.scale);
    subTitle.top=label.bottom+5*self.scale;
    subTitle.centerX=RM_VWidth/2;
    subTitle.textAlignment=NSTextAlignmentCenter;
    subTitle.textColor=grayTextColor;
    subTitle.text=@"谢谢您的支持，服务在继续";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"成功入账";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (_block) {
        _block();
    }
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
