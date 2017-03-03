//
//  CExpandHeader.h
//  CExpandHeaderViewExample
//
//
//  Created by cml on 14-8-27.
//  Copyright (c) 2014年 Mei_L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CExpandHeader : NSObject <UIScrollViewDelegate>

/*
 拉伸图片
 
 */


//使用方法：
//
//导入头文件：
//#import "CExpandHeader.h"
//
//声明实例变量：
//CExpandHeader *_header;
//
//调用expandWithScrollView:expandView:方法：
//_header = [CExpandHeader expandWithScrollView:_tableView expandView:imageView];
#pragma mark - 类方法
/**
 *  生成一个CExpandHeader实例
 *
 *  @param scrollView 滚动父视图
 *  @param expandView 可以伸展的背景View
 *
 *  @return CExpandHeader 对象
 */
+ (id)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView;


#pragma mark - 成员方法
/**
 *
 *
 *  @param scrollView 滚动父视图
 *  @param expandView 可以伸展的背景View
 */
- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView;

/**
 *  监听scrollViewDidScroll方法
 *
 *  @param scrollView 滚动父视图
 */
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

@end
