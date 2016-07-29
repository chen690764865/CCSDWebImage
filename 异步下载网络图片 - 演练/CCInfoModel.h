//
//  CCInfoModel.h
//  异步下载网络图片 - 演练
//
//  Created by chenchen on 16/7/29.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCInfoModel : NSObject
@property(nonatomic,copy)NSString * download;
@property(nonatomic,copy)NSString * icon;
@property(nonatomic,copy)NSString * name;

+(instancetype)infoModelWithDitionary:(NSDictionary *)dict;

@end
