//
//  TextContentViewController.h
//  QQRunning
//
//  Created by wdx on 2017/3/10.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "SuperViewController.h"
typedef NS_ENUM(NSInteger ,ContentType){
    ContentTypeWeb,
    ContentTypeLabel,
};

@interface TextContentViewController :SuperViewController
-(instancetype)initWithTitle:(NSString *)title parameter:(NSString *)parameter type:(ContentType)contentType;
+(instancetype)insWithTitle:(NSString *)title parameter:(NSString *)parameter type:(ContentType)contentType;
@end
