//
//  DDLogExceptionHandler.h
//  stockDiary
//
//  Created by changshuai on 11/2/16.
//  Copyright © 2016 changshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDLogExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
