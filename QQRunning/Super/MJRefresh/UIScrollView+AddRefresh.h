//
//  UIScrollView+AddRefresh.h
//  PrepareBusiness
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 com.ruanmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshFooter.h"
#import "MJRefreshHeader.h"

@interface UIScrollView (AddRefresh)
-(void)addHeardTarget:(id)target Action:(SEL)action;
-(void)addFooterTarget:(id)target Action:(SEL)action;
@property(nonatomic,strong)MJRefreshHeader *header;
@property(nonatomic,strong)MJRefreshFooter *footer;
@end
