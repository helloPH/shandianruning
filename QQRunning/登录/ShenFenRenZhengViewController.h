//
//  ShenFenRenZhengViewController.h
//  SJSD
//
//  Created by 软盟 on 16/4/26.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^Block)();
@interface ShenFenRenZhengViewController : SuperViewController
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)Block block;

/**
 *  用于记录是哪个界面跳过来的
 *  0  表示是由注册界面跳转而来
 *  1  表示是由首页跳转而来
 */
@property (nonatomic,assign) NSInteger biaoJi ;
@end
