//
//  UITableView+AddRefresh.h
//  DemoForKey
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshFooter.h"
#import "MJRefreshHeader.h"

@interface UITableView (AddRefresh)
-(void)addHeardTarget:(id)target Action:(SEL)action;
-(void)addFooterTarget:(id)target Action:(SEL)action;
@property(nonatomic,strong)MJRefreshHeader *header;
@property(nonatomic,strong)MJRefreshFooter *footer;
@end
