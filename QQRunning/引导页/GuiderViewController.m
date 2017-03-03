//
//  GuiderViewController.m
//  QQRunning
//
//  Created by wdx on 2017/2/8.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "GuiderViewController.h"

@interface GuiderViewController ()<UIScrollViewDelegate>

@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIPageControl * pageControl;


@property (nonatomic,strong)NSArray * imgs;

@property (nonatomic,strong)Block block;
@end

@implementation GuiderViewController
-(GuiderViewController *)initWithBlock:(void(^)(BOOL success))block{
    if (self = [super init]) {
        _block=block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newView];
    [self reshView:NO alpha:1];
    // Do any additional setup after loading the view.
}
-(void)initData{
    _currentPage=0;
    _imgs = @[@{@"bg":@"uoko_guide_background_1",@"fg":@"uoko_guide_foreground_1"},@{@"bg":@"uoko_guide_background_2",@"fg":@"uoko_guide_foreground_2"},@{@"bg":@"uoko_guide_background_3",@"fg":@"uoko_guide_foreground_3"}];
}
-(void)newView{
    for (int i = 0; i < _imgs.count; i ++) {
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, RM_VHeight)];
        img.image=[UIImage imageNamed:_imgs[i][@"bg"]];
        img.tag=100+i;
        [self.view addSubview:img];
    }
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, RM_VHeight)];
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
    _scrollView.contentSize=CGSizeMake(_scrollView.width*_imgs.count, _scrollView.height);
    _scrollView.showsHorizontalScrollIndicator=NO;
    for (int i = 0; i < _imgs.count; i ++) {
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*RM_VWidth, 0, RM_VWidth , RM_VHeight)];
        img.image=[UIImage imageNamed:_imgs[i][@"fg"]];
        img.tag=100+i;
        [_scrollView addSubview:img];
    }
    
    [self.view addSubview:_scrollView];
    
    
    
    UIButton * tiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    tiaoBtn.top=50;
    tiaoBtn.right=RM_VWidth-20*self.scale;
    [tiaoBtn setTitle:@"跳过 >" forState:UIControlStateNormal];
    [tiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tiaoBtn.titleLabel.font=Big17Font(self.scale);
    [self.view addSubview:tiaoBtn];
    tiaoBtn.tag=200;
    [tiaoBtn addTarget:self action:@selector(enterBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    enterBtn.bottom=RM_VHeight-100*self.scale;
    enterBtn.centerX=RM_VWidth/2;
    [enterBtn setTitle:@"进入跑男" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enterBtn setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateNormal];
    enterBtn.layer.cornerRadius=5;
    enterBtn.layer.masksToBounds=YES;
    enterBtn.titleLabel.font=Big14Font(self.scale);
    [self.view addSubview:enterBtn];
    enterBtn.alpha=0;
    enterBtn.tag=201;
    [enterBtn addTarget:self action:@selector(enterBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 20*self.scale)];
    _pageControl.top=enterBtn.bottom+10*self.scale;
    _pageControl.numberOfPages=_imgs.count;
    _pageControl.currentPage=_currentPage;
    [self.view addSubview:_pageControl];
    
}

#pragma mark -- scroll delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / RM_VWidth;
    int offset = (int)(scrollView.contentOffset.x) % (int)([UIScreen mainScreen].bounds.size.width);
    if (page>=_currentPage) { // 后翻
        
        float alpha = (RM_VWidth - offset)/RM_VWidth;
        if (alpha==1) {
            return;
        }
        [self reshView:NO alpha:alpha];

    }else {
        float alpha = offset/RM_VWidth;
        [self reshView:YES alpha:alpha];
    }
    
    
}
-(void)reshView:(BOOL)isBefore alpha:(float)alpha{
    for (int i=0; i < _imgs.count ; i++) {
        UIImageView * img = [self.view viewWithTag:100+i];
        img.alpha=0;
    }
    UIImageView * currentImg = [self.view viewWithTag:100+_currentPage];
    currentImg.alpha=alpha;
    
    NSLog(@"alpha:::: %f",alpha);
    if (isBefore) {
        if (_currentPage>=0) {
            UIImageView * beforeImg = [self.view viewWithTag:100+_currentPage-1];
            beforeImg.alpha=1-alpha;
        }
    }else{
        if (_currentPage<=_imgs.count-1) {
            UIImageView * afterImg = [self.view viewWithTag:100+_currentPage+1];
            afterImg.alpha=1-alpha;
        }
    }
    
    
    
        UIImageView * lastImg = [self.view viewWithTag:100+_imgs.count-1];
    
    
        UIButton * enterBtn = [self.view viewWithTag:201];
        enterBtn.alpha=lastImg.alpha;

    UIButton * tiaoBtn = [self.view viewWithTag:200];
    tiaoBtn.alpha=1-lastImg.alpha;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _currentPage=scrollView.contentOffset.x / RM_VWidth;
    _pageControl.currentPage=_currentPage;
//    [self reshView:YES alpha:1];

}
-(void)enterBtn:(UIButton *)sender{
    if (_block) {
        _block(YES);
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
