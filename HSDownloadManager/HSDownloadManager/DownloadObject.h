//
//  DownloadObject.h
//  HSDownloadManagerExample
//
//  Created by changshuai on 5/27/16.
//  Copyright © 2016 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"
#import "HSSessionModel.h"

//typedef enum {
//    DownloadStateStart = 0,     /** 下载中 */
//    DownloadStateSuspended,     /** 下载暂停 */
//    DownloadStateCompleted,     /** 下载完成 */
//    DownloadStateFailed         /** 下载失败 */
//}DownloadState;
@protocol DownloadObjectProtocal <NSObject>

@required
+ (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface DownloadObject : NSObject

+(DownloadObject*) fromResultSet:(FMResultSet*)set;

+(id) getClassObject:(DownloadObject*) down_obj;


@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger currentSize;

@property (nonatomic, assign) NSInteger totalSize;

@property (nonatomic, copy) NSString *localPath;

@property (nonatomic, copy) NSString *className;

@property (nonatomic, copy) NSString *objectJson;

@property (nonatomic) DownloadState status;

@end
