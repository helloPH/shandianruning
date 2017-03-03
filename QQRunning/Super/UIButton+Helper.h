//
//  UIButton+Helper.h
//  GeXiaZi
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MsgCodeTime  60
typedef NS_OPTIONS(NSUInteger, UIButtonTextSite) {
    UIButtonTextRight=0,//图片在左文字在右
    UIButtonTextLeft ,//图片在右文字在左
    UIButtonTextBottom,//图片在上文字在下
    UIButtonTextTop,//图片在下文字在上
};
@interface UIButton(Helper)
/**
*  按钮上的图片跟文字位置
*
*  @param offset 间距
*  @param site   位置
*/
-(void)TiaoZhengButtonWithOffsit:(CGFloat)offset TextImageSite:(UIButtonTextSite)site;
/**
 *  开始倒计时
 */
-(void)StartMsgCodeTimeDown;
@end
