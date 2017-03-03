//
//  CalculateFileSize.h
//  Wedding
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject
//类方法
+ (instancetype)defaultCacheManager;
/**
*
*计算单个文件大小
*/
- (double)fileSizeAtPath:(NSString*)path;
/**
 *
*获取缓存大小M
*/
- (double)GetCacheSize;
/**
 *
 *清空缓存
 */
- (void)clearCache:(void(^)(BOOL success)) complation;
@end
