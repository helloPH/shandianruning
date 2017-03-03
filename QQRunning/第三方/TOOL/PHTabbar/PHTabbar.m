//
//  PHTabbar.m
//  PHPackAge
//
//  Created by wdx on 2016/12/28.
//  Copyright © 2016年 wdx. All rights reserved.
//



#import "PHTabbar.h"
//#import "UIViewAdditions.h"
#import "DefaultPageSource.h"



@interface PHTabbar ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSArray<NSString *> * titles;


@property (nonatomic,strong)UIColor * themeColor;

@property (nonatomic,strong)UIImageView * titleLine;

@end
@implementation PHTabbar

+(instancetype)insWithTitles:(NSArray *)titles type:(TabbarType)type themeColor:(UIColor*)themeColor frame:(CGRect)frame{
    PHTabbar * tabbar=[[PHTabbar alloc]initWithFrame:frame];
    tabbar.index=0;
    tabbar.tabbarType=type;
    tabbar.titles=titles;
    tabbar.themeColor=themeColor;
    [tabbar newView];
    [tabbar reshViewWithAnimaiton:YES];
    return tabbar;
}
-(UIScrollView *)initWithTitles:(NSArray *)titles type:(TabbarType)type themeColor:(UIColor*)themeColor frame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.index=0;
        self.tabbarType=type;
        self.titles=titles;
        self.themeColor=themeColor;
        
        [self newView];
        [self reshViewWithAnimaiton:YES];
    }

    return self;
}




-(void)newView{
//    self.delegate=self;
    self.scrollEnabled=YES;
    self.showsHorizontalScrollIndicator=NO;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    
    
    
    CGFloat bW=self.width/_titles.count;
    CGFloat bH=self.height;
    CGFloat bXs=10;
    CGFloat setSizeW=self.width;
    CGFloat setX=0;
    
    
    
    for (int i = 0; i < _titles.count; i++) {
        CGFloat bX=bW*i;
        CGFloat bY=0;
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(bX, bY, bW, bH)];
        [self addSubview:btn];
        btn.tag=100+i;
        
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        float scale = RM_Scale;
        btn.titleLabel.font=[UIFont systemFontOfSize:13*scale];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:_themeColor forState:UIControlStateSelected];
        
        
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
   
        //  设置 格式
        switch (_tabbarType) {
            case TabbarTypeNumber: //默认的格式
            {
                self.scrollEnabled=NO;
                // 不作任何修改
              
            }
                break;
            case TabbarTypeScrollUnderline: // 可滚动的 栏
            {
                [btn sizeToFit];
                
                bW=btn.width+10;
                
                bX=bXs + setX;
              
                bH=30;
                
                bY=0;
                
//                btn.backgroundColor=[UIColor grayColor];
                
                btn.frame=CGRectMake(bX, bY, bW, bH);
//                NSLog(@"%f %f",btn.frame.origin.x,btn.size.width);
                
                setSizeW=bX+(bXs+bW);
                
                
                setX=btn.frame.origin.x + btn.frame.size.width;
         

            }
               break;
            case TabbarTypeScrollRound: // 可滚动的 栏
            {
                [btn sizeToFit];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                
                bW=btn.width+10;
                
                bX=bXs + setX;
                
                bH=30;
                
                bY=-15;
                
                btn.frame=CGRectMake(bX, bY, bW, bH);
                //                NSLog(@"%f %f",btn.frame.origin.x,btn.size.width);
                
                setSizeW=bX+(bXs+bW);
                
                
                setX=btn.frame.origin.x + btn.frame.size.width;
                
            }
                break;

                
            default:
                break;
        }
        
        btn.centerY=self.height/2;
   
        
        
    }
     self.contentSize=CGSizeMake(setSizeW, self.height);
    
    
    
    //下面的线
//    if (!_titleLine) {
        _titleLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bW, 2)];
       
//    }
    

    _titleLine.centerX=bW/2;
//    _titleLine.top=self.height-20-2;
    
    _titleLine.bottom=self.height;
    _titleLine.backgroundColor=_themeColor;
   [self addSubview:_titleLine]; 
    

}




#pragma mark --  点击事件
// 内部
-(void)btnEvent:(UIButton *)sender{
    _index=sender.tag-100;
    [self reshViewWithAnimaiton:YES];

    if (_block) {
        _block(_index);
    }
}
// 外部
-(void)setIndex:(NSInteger)index{
    _index=index;
    if (_index<0) {
        _index=0;
    }
    if (_index>_titles.count-1) {
        _index=_titles.count-1;
    }
    
    
    [self reshViewWithAnimaiton:YES];
 
}
//// 设置 格式
-(void)changeType:(TabbarType)type{
    _tabbarType=type;
    [self newView];
    [self reshViewWithAnimaiton:NO];
    
}

// 设置 标题组
-(void)changeTitles:(NSArray<NSString *> *)titles{
    _titles=titles;
    self.index=_index;
    [self newView];
    [self reshViewWithAnimaiton:NO];
}

-(void)reshViewWithAnimaiton:(BOOL)isAnimation{
    for (UIButton * btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected=NO;
            
            if (btn.tag-100==_index) {
                btn.selected=YES;
            
                
                float duration=0.0;
                if (isAnimation) {
                    duration=0.2;
                }
                [UIView animateWithDuration:duration animations:^{
                    _titleLine.width=btn.width;
                    if (_tabbarType==TabbarTypeScrollRound) {
                        [self sendSubviewToBack:_titleLine];
                        _titleLine.frame=btn.frame;
                        _titleLine.backgroundColor=[UIColor redColor];
                        _titleLine.layer.cornerRadius=3;
                        _titleLine.layer.masksToBounds=YES;
                    }
                   _titleLine.centerX=btn.centerX;
                }];
                
                

            }
        }
    }
    [self judgeOffSet];
}




-(void)judgeOffSet{
    UIButton * btn=[self viewWithTag:100+_index];
    
    CGFloat btnLeft=btn.origin.x;
    CGFloat btnRight=btn.origin.x+btn.size.width;
    
    CGFloat oughtOffSetXMin=self.contentOffset.x;
    CGFloat oughtOffSetXMax=self.contentOffset.x + self.width;
    
    NSLog(@"%f %f %f %f ",btnLeft,btnRight,oughtOffSetXMin,oughtOffSetXMax);
    
    if (btnRight>oughtOffSetXMax) {
        [UIView animateWithDuration:0.2 animations:^{
                   self.contentOffset=CGPointMake(btnRight-self.width, self.contentOffset.y);
        }];
    }
    if (btnLeft < oughtOffSetXMin) {
        [UIView animateWithDuration:0.2 animations:^{
                 self.contentOffset=CGPointMake(btnLeft-10, self.contentOffset.y);
        }];
    }
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
