//
//  DDLogHelper.h
//  stockDiary
//
//  Created by changshuai on 11/2/16.
//  Copyright © 2016 changshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLogDefine.h"

@interface DDLogHelper : NSObject
//- (void) configLog;
+ (DDLogHelper *)sharedManager;
- (DDFileLogger *)getFileLogger;


@end
