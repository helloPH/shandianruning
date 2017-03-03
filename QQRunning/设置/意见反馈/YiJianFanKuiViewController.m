//
//  YiJianFanKuiViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "YiJianFanKuiViewController.h"
#import "CellView.h"
@interface YiJianFanKuiViewController ()<UITextViewDelegate>

@property (nonatomic,strong)UITextView * textView;
@end

@implementation YiJianFanKuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupNewView];
}
-(void)setupNewView{
    CellView *bgView = [[CellView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom + RM_Padding, RM_VWidth, 170*self.scale)];
    bgView.topline.hidden = NO;
    bgView.bottomline.hidden = NO;
    bgView.backgroundColor = whiteLineColore;
    [self.view addSubview:bgView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(RM_Padding, 0.5, bgView.width - 2*RM_Padding, bgView.height-20*self.scale-0.5)];
    textView.delegate = self;
    textView.font = DefaultFont(self.scale);
    [textView setMaxLength:RM_LeaveMessageLength];
    textView.placeholder = @"请提供您的宝贵意见，我们非常感谢！";
    [bgView addSubview:textView];
    _textView=textView;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(textView.left, textView.bottom, textView.width, 20*self.scale)];
    textLabel.font = SmallFont(self.scale)
    textLabel.textColor = grayTextColor;
    textLabel.tag = 10;
    textLabel.text = [NSString stringWithFormat:@"0/%d",RM_LeaveMessageLength];
    textLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:textLabel];
    
    UIButton *tiJiaoButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_ButtonPadding, bgView.bottom + 30*self.scale, RM_VWidth - RM_ButtonPadding*2, RM_ButtonHeight)];
    [tiJiaoButton setTitle:@"提交" forState:UIControlStateNormal];
    [tiJiaoButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    tiJiaoButton.titleLabel.font = Big15Font(self.scale);
    [tiJiaoButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
    [tiJiaoButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateHighlighted];
    tiJiaoButton.userInteractionEnabled = NO;
    tiJiaoButton.layer.cornerRadius = RM_CornerRadius;
    tiJiaoButton.clipsToBounds = YES;
    tiJiaoButton.tag = 1;
    [tiJiaoButton addTarget:self action:@selector(tiJiaoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tiJiaoButton];
}
#pragma mark -- 点击事件
-(void)tiJiaoButtonEvent:(UIButton *)button{
     [self closeKeyboard];
    
    NSDictionary * dic = @{@"UserId":[Stockpile sharedStockpile].userID,
                           @"Flag":@"1",
                           @"Content":_textView.text};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject feedBackWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
         
        }
           [CoreSVP showMessageInBottomWithMessage:msg];
    }];
}
-(void)textViewDidChange:(UITextView *)textView{
    UILabel *textLabel = (UILabel *)[self.view viewWithTag:10];
    UIButton *tiJiaoButton = (UIButton *)[self.view viewWithTag:1];
    if ([textView.text trimString].length > 0) {
        [tiJiaoButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateNormal];
        [tiJiaoButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateHighlighted];
        tiJiaoButton.userInteractionEnabled=YES;
    }else{
        [tiJiaoButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateNormal];
        [tiJiaoButton setBackgroundImage:[UIImage ImageForColor:blackLineColore] forState:UIControlStateHighlighted];
        tiJiaoButton.userInteractionEnabled=NO;
    }
    NSInteger textLength = [textView.text trimString].length;
    if (textLength > RM_LeaveMessageLength) {
        textLength = RM_LeaveMessageLength;
    }
    textLabel.text = [NSString stringWithFormat:@"%ld/%d",textLength,RM_LeaveMessageLength];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self closeKeyboard];
}
-(void)closeKeyboard{
    [self.view endEditing:YES];
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"意见反馈";
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
