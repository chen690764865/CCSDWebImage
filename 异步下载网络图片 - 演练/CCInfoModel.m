//
//  CCInfoModel.m
//  异步下载网络图片 - 演练
//
//  Created by chenchen on 16/7/29.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import "CCInfoModel.h"

@implementation CCInfoModel

+(instancetype)infoModelWithDitionary:(NSDictionary *)dict{
    
    CCInfoModel *info = [[CCInfoModel alloc] init];
    
    [info setValuesForKeysWithDictionary:dict];
    
    return info;
}

//记得写模型的时候顺便把setValue ForUndefineKey也写一下,以免出现错误 什么都不执行就可以,需要判断的时候在往里面加判断条件就可以了
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
