//
//  PHTabbar.h
//  PHPackAge
//
//  Created by wdx on 2016/12/28.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,TabbarType){
    TabbarTypeNumber =0,
    TabbarTypeScrollUnderline=1,
    TabbarTypeScrollRound=2,
};
@interface PHTabbar : UIScrollView
@property (nonatomic,strong)void (^block)(NSInteger index);
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)TabbarType tabbarType;

+(instancetype)insWithTitles:(NSArray *)titles type:(TabbarType)type themeColor:(UIColor*)themeColor frame:(CGRect)frame;
-(UIScrollView*)initWithTitles:(NSArray *)titles type:(TabbarType)type themeColor:(UIColor*)themeColor frame:(CGRect)frame;


-(void)changeType:(TabbarType)type;
-(void)changeTitles:(NSArray<NSString *> *)titles;
@end
