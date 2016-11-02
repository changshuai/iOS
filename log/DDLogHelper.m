//
//  DDLogHelper.m
//  stockDiary
//
//  Created by changshuai on 11/2/16.
//  Copyright © 2016 changshuai. All rights reserved.
//

#import "DDLogHelper.h"


@interface DDLogHelper()

@property (nonatomic, strong, readwrite) DDFileLogger *fileLogger;

@end

@implementation DDLogHelper

static DDLogHelper *sharedManager=nil;

- (void) configLogColor {
    setenv("XcodeColors", "YES", 0);
    //[DDLog addLogger:[DDTTYLogger sharedInstance]];// 初始化DDLog日志输出
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];// 启用颜色区分
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor grayColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    
    DDLogError(@"DDLogError");      // red
    DDLogWarn(@"DDLogWarn");        // orange
    DDLogDebug(@"DDLogDebug");      // green
    DDLogInfo(@"DDLogInfo");        // pink
    DDLogVerbose(@"DDLogVerbose");  // gray
}

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [self configureLogging];
//    }
//    return self;
//}

+ (DDLogHelper *) sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager=[[self alloc]init];
        [sharedManager configLog];
    });
    return sharedManager;
}

- (void)configLog {
    [self configLogColor];
#ifdef DEBUG
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[self getFileLogger]];
#endif
    [DDLog addLogger:[self getFileLogger]];
}

#pragma mark - 初始化文件记录类型
- (DDFileLogger *)getFileLogger {
    if (!_fileLogger) {
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        _fileLogger = fileLogger;
    }
    return _fileLogger;
}
@end
