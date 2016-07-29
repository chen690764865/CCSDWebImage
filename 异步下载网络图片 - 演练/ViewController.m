//
//  ViewController.m
//  异步下载网络图片 - 演练
//
//  Created by chenchen on 16/7/29.
//  Copyright © 2016年 chenchen. All rights reserved.
//
//  https://raw.githubusercontent.com/yinqiaoyin/SimpleDemo/master/apps.json

#import "AFNetworking.h"
#import "CCInfoModel.h"
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray<CCInfoModel*>* infoData;
@property (nonatomic, weak) UIImage* image;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //从网络加载数据
    [self loadData];
}

#pragma mark - 从网络加载数据
/**
 *  获取数据
 */
- (void)loadData
{

    //获取url字符串
    NSString* urlString = @"https://raw.githubusercontent.com/yinqiaoyin/SimpleDemo/master/apps.json";

    //使用第三方框架 AFNetworking加载数据
    //初始化一个网络请求的管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    //通过网络请求管理器对象调用get的方法从网络上加载数据
    /**
     参数:
     1. 请求的地址
     2. 请求参数
     3. 加载的进度
     4. 成功的回调
     5. 失败的回调
     */
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@", [NSThread currentThread]);
        //请求成功的回调 responseObject这个东西就是获取到的json数据的根目录,是一个数组
        NSLog(@"%@", responseObject);
        //先获取一下这个数组
        NSArray* tempArray = responseObject;
        //初始化可变数组
        NSMutableArray* Marray = [NSMutableArray array];
        //forin遍历临时数组
        for (NSDictionary* dict in tempArray) {

            //字典转模型
            CCInfoModel* info = [CCInfoModel infoModelWithDitionary:dict];

            //把模型添加到可变数组中
            [Marray addObject:info];
        }
        //赋值全局属性
        self.infoData = Marray.copy;
        NSLog(@"%@", self.infoData);
        //从网络上获取到数据以后要刷新数据源的方法
        [self.tableView reloadData];

    }
        failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {

            //请求失败的回调 以后再公司开发的时候一定要错里错误请求
            NSLog(@"------------------");
            NSLog(@"%@", error);
        }];
}

#pragma mark - 数据源方法

//有多少cell
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoData.count;
}

//cell内容
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    //1.从缓存池找cell
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    //2.注册单元格 从storyboard注册单元格

    //3.设置cell的内容
    //获取对应的模型数据
    CCInfoModel* info = self.infoData[indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = info.download;
    //设置图片
    //获取图片 注意耗时操作要新开一条线程去执行
    [[NSOperationQueue new] addOperationWithBlock:^{

        //获取url地址
        NSString* urlString = info.icon;
        NSURL* url = [NSURL URLWithString:urlString];
        //把url地址转换为二进制数据
        NSData* data = [NSData dataWithContentsOfURL:url];

        //把二进制数据转化为图片
        UIImage* image = [UIImage imageWithData:data];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.imageView.image = image;
            NSLog(@"%@", [NSThread currentThread]);
            //             [self.tableView reloadData];
            //        [self viewDidLayoutSubviews];
            NSLog(@"image获取完成");
        }];

    }];

    //    if (self.image) {
    //        cell.imageView.image = [UIImage new];
    //    }
    //    else {
    //        dispatch_async(dispatch_queue_create("itcast", DISPATCH_QUEUE_SERIAL), ^{
    //            //获取url地址
    //            NSString* urlString = info.icon;
    //            NSURL* url = [NSURL URLWithString:urlString];
    //            //把url地址转换为二进制数据
    //            NSData* data = [NSData dataWithContentsOfURL:url];
    //
    //            //把二进制数据转化为图片
    //            UIImage* image = [UIImage imageWithData:data];
    //
    //            cell.imageView.image = [UIImage imageNamed:@"001"];
    ////            cell.imageView.image = image;
    //            NSLog(@"image获取完成");
    //
    //        });
    //    }

    NSLog(@"返回cell");
    NSLog(@"%@", [NSThread currentThread]);
    //    self.image = nil;
    return cell;
}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [self.tableView reloadData];
//}
//
@end
