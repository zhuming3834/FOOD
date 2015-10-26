//
//  NetWork.m
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "NetWork.h"

@implementation NetWork

+(int)currentNetWorking{
    __block int netStatus = 0;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusNotReachable     = 0,//断网
         AFNetworkReachabilityStatusReachableViaWWAN = 1,//移动网络状态(3G, 4G)
         AFNetworkReachabilityStatusReachableViaWiFi = 2,//无线网络状体(wifi)
         */
        netStatus = status;
    }];
    return netStatus;
}

//美食列表
+(void)getFoodListDataWithURL:(NSString *)url keyWords:(NSString *)keywords page:(NSString *)page pageSize:(NSString *)pageSize order:(NSString *)order getData:(blockDic)block error:(blockString)err{
    
    //拼接url
    NSMutableString *strURL = [[NSMutableString alloc]init];
    [strURL appendString:url];
    [strURL appendFormat:@"?%@", keywords];
    [strURL appendFormat:@"&p=%@", page];
    [strURL appendFormat:@"&pagesize=%@", pageSize];
    [strURL appendFormat:@"&order=%@", order];
    [strURL setString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //网络管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送GET请求
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        printf("网络请求错误: %s\n", [error.userInfo[@"NSLocalizedDescription"] UTF8String]);
        err(error.userInfo[@"NSLocalizedDescription"]);
    }];
}

//详情页
+(void)getDetailDataWithURL:(NSString *)url withID:(NSString *)ID getData:(blockString)block error:(blockString)err{
    //拼接url
    NSMutableString *strURL = [[NSMutableString alloc]init];
    [strURL appendString:url];
    [strURL appendFormat:@"?id=%@", ID];
    [strURL setString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //网络管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送GET请求
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        block(str);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        printf("网络请求错误: %s\n", [error.userInfo[@"NSLocalizedDescription"] UTF8String]);
        err(error.userInfo[@"NSLocalizedDescription"]);
    }];
}

//专题
+(void)getSubjectDataWithURL:(NSString *)url page:(NSString *)page pageSize:(NSString *)pageSize order:(NSString *)order getData:(blockDic)block error:(blockString)err{
    //拼接url
    NSMutableString *strURL = [[NSMutableString alloc]init];
    [strURL appendString:url];
    [strURL appendFormat:@"?p=%@", page];
    [strURL appendFormat:@"&pagesize=%@", pageSize];
    [strURL appendFormat:@"&order=%@", order];
    [strURL setString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //网络管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送GET请求
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        printf("网络请求错误: %s\n", [error.userInfo[@"NSLocalizedDescription"] UTF8String]);
        err(error.userInfo[@"NSLocalizedDescription"]);
    }];
}


//专题列表
+(void)getSubjectListWithURL:(NSString *)url ID:(NSString *)ID getData:(blockDic)block error:(blockString)err{
    //拼接url
    NSMutableString *strURL = [[NSMutableString alloc]init];
    [strURL appendString:url];
    [strURL appendFormat:@"?id=%@", ID];
    [strURL setString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //网络管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送GET请求
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        printf("网络请求错误: %s\n", [error.userInfo[@"NSLocalizedDescription"] UTF8String]);
        err(error.userInfo[@"NSLocalizedDescription"]);
    }];
}


//健康常识列表
+(void)getHealthyListDataWithURL:(NSString *)url tags:(NSString *)tags page:(NSString *)page pageSize:(NSString *)pageSize getData:(blockDic)block error:(blockString)err{
    //拼接url
    NSMutableString *strURL = [[NSMutableString alloc]init];
    [strURL appendString:url];
    [strURL appendFormat:@"?p=%@", page];
    [strURL appendFormat:@"&pagesize=%@", pageSize];
    [strURL appendFormat:@"&tags=%@", tags];
    [strURL setString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //网络管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送GET请求
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        printf("网络请求错误: %s\n", [error.userInfo[@"NSLocalizedDescription"] UTF8String]);
        err(error.userInfo[@"NSLocalizedDescription"]);
    }];
}

+(void)getHealthyDetailDataWithURL:(NSString *)url ID:(NSString *)ID getData:(blockString)block error:(blockString)err{
    //拼接url
    NSMutableString *strURL = [[NSMutableString alloc]init];
    [strURL appendString:url];
    [strURL appendFormat:@"?id=%@", ID];
    [strURL setString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //网络管理者对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送GET请求
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        block(str);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        printf("网络请求错误: %s\n", [error.userInfo[@"NSLocalizedDescription"] UTF8String]);
        err(error.userInfo[@"NSLocalizedDescription"]);
    }];
}

@end
