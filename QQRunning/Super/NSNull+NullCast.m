//
//  NSNull+NullCast.m
//  拼妈
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "NSNull+NullCast.h"

@implementation NSNull(NullCast)
-(double)doubleValue{
    return 0.0;
}
-(int )intValue{
        return 0;
}
-(float)floatValue{
        return 0.0;
}
-(NSInteger)integerValue{
        return 0;
}
@end
