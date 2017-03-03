//
//  UIScrollView+AddRefresh.m
//  PrepareBusiness
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 com.ruanmeng. All rights reserved.
//

#import "UIScrollView+AddRefresh.h"
#import "UITableView+AddRefresh.h"

@implementation UIScrollView (AddRefresh)
-(void)addHeardTarget:(id)target Action:(SEL)action{
    
    self.header = [MJRefreshHeader headerWithRefreshingTarget:target refreshingAction:action];
}
-(void)addFooterTarget:(id)target Action:(SEL)action{
    self.footer = [MJRefreshFooter footerWithRefreshingTarget:target refreshingAction:action];
}
@end
