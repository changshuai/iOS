//
//  TestObject.m
//  HSDownloadManagerExample
//
//  Created by changshuai on 6/13/16.
//  Copyright © 2016 hans. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

+ (instancetype)initWithDictionary:(NSDictionary *)dict{
    TestObject* obj = [[TestObject alloc] init];
    
    NSString* name = [dict valueForKey:@"name"];
    if (name) obj.name = name;
    
    NSString* url = [dict valueForKey:@"url"];
    if (url) obj.url = url;
    
    NSString* detail = [dict valueForKey:@"detail"];
    if (detail) obj.detail = detail;
    
    BOOL isPlaying = [dict valueForKey:@"isPlaying"];
    if (isPlaying) obj.isPlaying = isPlaying;
    
    int startTime = (int)[dict valueForKey:@"startTime"];
    if (startTime) obj.startTime = startTime;
    
    
    return obj;
}

+ (instancetype)getInstance {
    TestObject* obj = [[TestObject alloc] init];
    
    obj.name = @"test";

    obj.name = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    
    obj.detail = @"test test";
    
    obj.isPlaying = NO;
    
    obj.startTime = 100;
    
    return obj;
}

@end
