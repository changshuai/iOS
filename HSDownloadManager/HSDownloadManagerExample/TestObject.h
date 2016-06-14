//
//  TestObject.h
//  HSDownloadManagerExample
//
//  Created by changshuai on 6/13/16.
//  Copyright © 2016 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadObject.h"
@interface TestObject : NSObject<DownloadObjectProtocal>

+ (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)getInstance;


@property(copy,nonatomic) NSString* name;

@property(copy,nonatomic) NSString* url;
@property(copy,nonatomic) NSString* detail;
@property (nonatomic) BOOL isPlaying;//是否正在播放
@property (nonatomic,assign) int startTime;//适龄 start


@end
