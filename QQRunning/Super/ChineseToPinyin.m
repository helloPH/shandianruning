/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ChineseToPinyin.h"
#import "NSString+Helper.h"
@implementation ChineseToPinyin
+ (NSString *) pinyinFromChineseString:(NSString *)string{
    NSMutableString *str = [string mutableCopy];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *Uppter=[NSString stringWithFormat:@"%@",[str uppercaseString]];
    return  [Uppter stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end