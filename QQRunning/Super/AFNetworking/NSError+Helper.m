//
//  NSError+Helper.m
//  AFNetDemo
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSError+Helper.h"
//}
@implementation NSError(Helper)
-(NSString *)errorMessage{
    NSString *message = @"没有数据";
    
    switch (self.code) {
        case -1://    NSURLErrorUnknown = -1,
            message = @"未知错误";
            break;
        case -999://    NSURLErrorCancelled = -999,
            message = @"取消了";
            break;
        case -1000://    NSURLErrorBadURL = -1000,
            message = @"URL错误";
            break;
        case -1001://    NSURLErrorTimedOut = -1001,
            message = @"网络超时";
            break;
        case -1002://    NSURLErrorUnsupportedURL = -1002
            message = @"不支持的URL";
            break;
        case -1003://    NSURL Error Cannot Find Host = -1003,
            message = @"找不到主机";
            break;
        case -1004://   NSURLError Cannot Connect To Host
            message = @"不能连接到主机";
            break;
        case -1005://    NSURLError Network Connection Lost = -1005,
            message = @"网络连接丢失";
            break;
        case -1006://    NSURLError DNS Lookup Failed = -1006,
            message = @"DNS查找失败";
            break;
        case -1007://    NSURLError HTTP Too Many Redirects = -1007,
            message = @"HTTP重定向太多了";
            break;
        case -1008://    NSURLError Resource Unavailable = -1008,
            message = @"资源不可用";
            break;
        case -1009://    NSURLError Not Connected To Internet = -1009,
            message = @"没有连接到互联网";
            break;
        case -1010: //    NSURLError Redirect To Non Existent Location = -1010,
            message = @"重定向到非存在的位置";
            break;
        case -1011: //    NSURLError Bad Server Response = -1011,
            message = @"服务无响应";//404
            break;
        case -1012://    NSURLErrorUserCancelledAuthentication = -1012,
            message = @"用户取消了身份验证";
            break;
        case -1013://    NSURLErrorUserAuthenticationRequired = -1013,
            message = @"用户身份验证要求";
            break;
        case -1014://    NSURLErrorZeroByteResource = -1014,
            message = @"零字节资源";
            break;
        case -1015://    NSURLErrorCannotDecodeRawData = -1015,
            message = @"不能解码原始数据";
            break;
        case -1016://    NSURLErrorCannotDecodeContentData = -1016,
            message = @"不能解码内容数据";
            break;
        case -1017: //    NSURLErrorCannotParseResponse = -1017,
            message = @"不能解析响应";
            break;
        case -1018://    NSURLErrorInternationalRoamingOff = -1018,
            message = @"国际漫游了";
            break;
        case -1019://    NSURLErrorCallIsActive = -1019,
            message = @"愈伤组织活动";
            break;
        case -1020://    NSURLErrorDataNotAllowed = -1020,
            message = @"数据不允许";
            break;
            
        case -1021://    NSURLErrorRequestBodyStreamExhausted = -1021,
            message = @"请求主体流精疲力竭";
            break;
        case -1100://    NSURLErrorFileDoesNotExist = -1100,
            message = @"文件不存在";
            break;
        case -1101://    NSURLErrorFileIsDirectory = -1101,
            message = @"FileIs目录";
            break;
        case -1102: //    NSURLErrorNoPermissionsToReadFile = -1102,
            message = @"优化权限阅读文件";
            break;
        case -1103://NSURLError Data Length Exceeds Maximum
            message = @"数据长度超过最大";
            break;
        case -1200: //    NSURLErrorSecureConnectionFailed = -1200,
            message = @"安全连接失败";
            break;
        case -1201: // NSURLErrorServerCertificateHasBadDate = -1201,
            message = @"服务器证书已经糟糕的约会";
            break;
        case -1202: // NSURLErrorServerCertificateUntrusted = -1202,
            message = @"服务器证书不受信任";
            break;
        case -1203:  // NSURLErrorServerCertificateHasUnknownRoot = -1203,
            message = @"服务器证书有未知的根";
            break;
        case -1204:  // NSURLErrorServerCertificateNotYetValid = -1204,
            message = @"服务器证书尚未有效";
            break;
        case -1205:   // NSURLErrorClientCertificateRejected = -1205,
            message = @"客户机证书拒绝";
            break;
        case -1206:  // NSURLErrorClientCertificateRequired = -1206,
            message = @"客户机证书要求";
            break;
        case -2000:  // NSURLErrorCannotLoadFromNetwork = -2000,
            message = @"不能从网络负载";
            break;
        case -3000:   // NSURLErrorCannotCreateFile = -3000,
            message = @"不能创建文件";
            break;
        case -3001:   // NSURLErrorCannotOpenFile = -3001,
            message = @"不能打开文件";
            break;
        case -3002:    // NSURLErrorCannotCloseFile = -3002,
            message = @"不能关闭文件";
            break;
        case -3003:   // NSURLErrorCannotWriteToFile = -3003,
            message = @"无法写入文件";
            break;
        case -3004: // NSURLErrorCannotRemoveFile = -3004,
            message = @"无法删除文件";
            break;
        case -3005:  // NSURLErrorCannotMoveFile = -3005,
            message = @"不能移动文件";
            break;
        case -3006: // NSURLErrorDownloadDecodingFailedMidStream = -3006,
            message = @"下载解码失败的中期流";
            break;
        case -3007:  // NSURLErrorDownloadDecodingFailedToComplete = -3007
            message = @"下载解码未能完成";
            break;
        case 3840:  // NSURLErrorDownloadDecodingFailedToComplete = -3007
            message = @"服务请求错误";//500
            break;
        default:
            break;
    }
    return message;
}
@end
