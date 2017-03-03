//
//  CalculateFileSize.m
//  Wedding
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager
//单利
+ (instancetype)defaultCacheManager
{
    
    static CacheManager *calculateFileSize =nil;
    
    @synchronized(self)  {
        
        if (!calculateFileSize) {
            
            calculateFileSize   =  [[self alloc]init];;
            
        }
    }
    
    return calculateFileSize;
}


//计算单个文件大小返回值是M

- (double)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        double size = [fileManager attributesOfItemAtPath:path error:nil].fileSize/(1024*1024.0);
        // 返回值是字节 B K M
        return size;
    }
    return 0;
}
//计算目录大小
- (double)GetCacheSize
{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    double folderSize=0;
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        
        for (NSString *fileName in childerFiles) {
            
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            
            
            // 计算单个文件大小
            folderSize += [self fileSizeAtPath:absolutePath];
            
        }
        
        return folderSize;
        
    }
    
    return 0;
    
}
//清理缓存文件

//同样也是利用NSFileManager API进行文件操作，SDWebImage框架自己实现了清理缓存操作，我们可以直接调用。

- (void)clearCache:(void(^)(BOOL success)) complation
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            complation(YES);
        });
    });
}
@end
