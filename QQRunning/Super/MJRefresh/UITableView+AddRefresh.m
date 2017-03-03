//
//  UITableView+AddRefresh.m
//  DemoForKey
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UITableView+AddRefresh.h"
#import "SuperViewController.h"

@implementation UITableView (AddRefresh)
-(void)addHeardTarget:(id)target Action:(SEL)action{
    self.header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}
-(void)addFooterTarget:(id)target Action:(SEL)action{
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

@end
