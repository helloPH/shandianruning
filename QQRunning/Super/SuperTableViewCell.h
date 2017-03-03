//
//  SuperTableViewCell.h
//  Wedding
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultPageSource.h"
#import "Masonry.h"
@interface SuperTableViewCell : UITableViewCell
@property(nonatomic,assign)float scale;
-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone;
@end
