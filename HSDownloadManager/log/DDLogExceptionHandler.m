//
//  DDLogExceptionHandler.m
//  stockDiary
//
//  Created by changshuai on 11/2/16.
//  Copyright © 2016 changshuai. All rights reserved.
//

#import "DDLogExceptionHandler.h"
#import "DDLogDefine.h"

void UncaughtExceptionHandler(NSException * exception) {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    DDLogError(@"%@\n\n",url);
}


@implementation DDLogExceptionHandler

+ (void)setDefaultHandler {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler *)getHandler {
    return NSGetUncaughtExceptionHandler();
}

+ (void)TakeException:(NSException *)exception {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    DDLogError(@"%@",url);
}

@end
