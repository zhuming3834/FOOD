//
//  AppDelegate.m
//  CGYFood-v2
//
//  Created by qf on 9/12/15.
//  Copyright (c) 2015 Chakery. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setDB];
    [NSThread sleepForTimeInterval:2.0];
    return YES;
}

//初始化的时候创建数据库
-(void)setDB{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"flag"] isEqualToString:@"1"]) {
        return;
    }
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        CGYDB *db = [[CGYDB alloc]init];
        [db openDatabaseWithName:DB];
        [db createTabelWithName:TABLE_FOOD withArray:TABLE_FOOD_ARRAY];
        [db createTabelWithName:TABLE_HEALTHY withArray:TABLE_HEALTHY_ARRAY];
        [db createTabelWithName:TABLE_FOODDATA withArray:TABLE_FOODDATA_ARRAY];
        [db createTabelWithName:TABLE_SUBJECT withArray:TABLE_SUBJECT_ARRAY];
        [db closeDatabase];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"1" forKey:@"flag"];
        [user synchronize];
    });
}

//清理缓存
-(void)clearCache{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:path error:nil];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isEqualToString:@".DS_Store"] && ![obj isEqualToString:@"LaunchImages"]) {
            NSString *deleteFilePath = [path stringByAppendingPathComponent:obj];
            [manager removeItemAtPath:deleteFilePath error:nil];
        }
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
