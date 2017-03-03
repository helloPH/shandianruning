//
//  GuiderViewController.h
//  QQRunning
//
//  Created by wdx on 2017/2/8.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^Block)(BOOL success);

@interface GuiderViewController : SuperViewController
-(GuiderViewController *)initWithBlock:(Block)block;
@end
