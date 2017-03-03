//
//  SuperCollectionViewCell.m
//  Wedding
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperCollectionViewCell.h"

@implementation SuperCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
    _scale=RM_Scale;
    }
    return self;
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        _scale=RM_Scale;
    }
    return self;
}
@end
