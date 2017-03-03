//
//  UITextField+RYNumberKeyboard.h
//  RYNumberKeyboardDemo
//
//  Created by Resory on 16/2/21.
//  Copyright © 2016年 Resory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYNumberKeyboard.h"

@interface UITextField (RYNumberKeyboard)
/**
 *键盘类型
 *0：整数键盘 1：浮点数键盘 2：身份证键盘
 */
@property (nonatomic, assign) RYInputType ry_inputType;
/**每隔多少个数字空一格*/
@property (nonatomic, assign) NSInteger ry_interval;
@property (nonatomic, assign) NSInteger ry_maxlength;
@property (nonatomic, copy) NSString *ry_inputAccessoryText;  // inputAccessoryView显示的文字
-(void)setMaxLength:(NSInteger)maxlength;
@end


