//
//  NetWork.h
//  CGYFood-v2
//
//  Created by qf on 9/15/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^blockDic)(NSDictionary *dic);         //字典
typedef void(^blockArray)(NSMutableArray *array);   //数组
typedef void(^blockData)(NSMutableData *data);      //数据流
typedef void(^blockString)(NSString *str);          //字符串

@interface NetWork : NSObject

#pragma mark --- 美食列表
+(void)getFoodListDataWithURL:(NSString *)url keyWords:(NSString *)keywords page:(NSString *)page pageSize:(NSString *)pageSize order:(NSString *)order getData:(blockDic)block error:(blockString)err;

#pragma mark --- 详情页
+(void)getDetailDataWithURL:(NSString *)url withID:(NSString *)ID getData:(blockString)block error:(blockString)err;

#pragma mark --- 专题
+(void)getSubjectDataWithURL:(NSString *)url page:(NSString *)page pageSize:(NSString *)pageSize order:(NSString *)order getData:(blockDic)block error:(blockString)err;

#pragma mark --- 专题列表
+(void)getSubjectListWithURL:(NSString *)url ID:(NSString *)ID getData:(blockDic)block error:(blockString)err;

#pragma mark --- 健康常识列表
+(void)getHealthyListDataWithURL:(NSString *)url tags:(NSString *)tags page:(NSString *)page pageSize:(NSString *)pageSize getData:(blockDic)block error:(blockString)err;

#pragma mark --- 健康常识详情页
+(void)getHealthyDetailDataWithURL:(NSString *)url ID:(NSString *)ID getData:(blockString)block error:(blockString)err;

@end
