//
//  NSString+Encrypt.h
//  DES
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MD532UpCode=0,
    MD516UpCode,
    MD532LowCode,
   MD516LowCode,
    
} MD5Type;
@interface NSString(Encrypt)
+ (NSString *)encryptWithText:(NSString *)sText ForKey:(NSString *)key ForInitIv:(NSString *)initIv;//加密
+ (NSString *)decryptWithText:(NSString *)sText ForKey:(NSString *)key ForInitIv:(NSString *)initIv;//解密
#pragma mark - MD5加密
/**
 *MD5加密
 */
-(NSString *)md5ForType:(MD5Type)type;
#pragma mark - 根据位置获取8位字符串
/**
 *根据位置获取8位字符串
 */
-(NSString *)get8KeyBySiteArray:(NSArray *)siteArr;
@end
