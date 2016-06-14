//
//  DownloadDao.m
//  HSDownloadManagerExample
//
//  Created by changshuai on 6/5/16.
//  Copyright © 2016 hans. All rights reserved.
//

#import "DownloadDao.h"

#define  SQL_INSERT @"insert into download_v2 (url, created_at, current_size, total_size, status, save_path, classType, objectJson)values(?,?,?,?,?,?,?,?)"
#define  SQL_UPDATE @"update download_v2 set current_size=?,total_size=?,status=? where url=?"
#define  SQL_DELETE @"delete from download_v2 where url=?"
#define  SQL_SELECT @"select * from download_v2 where classType=? AND status=?"
#define  SQL_SELECT_STATUS @"select * from download_v2 where status=?"
#define  SQL_SELECT_EXIST @"select * from download_v2 where url=?"

@interface DownloadDao ()

@property(nonatomic, strong)FMDatabase* dataBase;

@property(nonatomic, strong)FMDatabaseQueue *queue;

@end

@implementation DownloadDao

+ (DownloadDao *)sharedManager
{
    static DownloadDao *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (DownloadDao*) init {
    if (self = [super init]) {
        self.dataBase = [FMDatabase databaseWithPath:[self getPath]];
        self.queue = [FMDatabaseQueue databaseQueueWithPath:[self getPath]];
        [self createTable];
    }
    return self;
}

- (NSString*) getPath {
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"ubaby.db"];
    return dbPath;
}

-(void)createTable
{
    if (![self.dataBase open]){
        NSLog(@"OPEN FAIL");
        return;
    }
    
    BOOL result=[self.dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS download_v2(id integer PRIMARY KEY AUTOINCREMENT, url text NOT NULL, created_at TimeStamp NOT NULL DEFAULT(datetime('now','localtime')), current_size real default 0, total_size real default 0, status integer default 1, save_path text, classType text,objectJson text)"];
    if (result) {
        NSLog(@"download_V2 CREATE SUCCESS");
    } else {
        NSLog(@"download_V2 CREATE FAILED");
    }
    
    [self.dataBase close];
}

// for view display
// get a list filter by type and download status
-(NSMutableArray*) getDownloadObjectList: (NSString*) className withStatus:(NSInteger)status {
    if (![self.dataBase open]) {
        NSLog(@"OPEN FAIL");
        return nil;
    }
    
    FMResultSet* set = [self.dataBase executeQuery:SQL_SELECT,className,@(status)];
    
    NSMutableArray* ret = [self fromResultSet:set];
    
    [self.dataBase close];
    
    return ret;
}

-(NSMutableArray*) getDownloadObjectList: (NSInteger)status {
    if (![self.dataBase open]) {
        NSLog(@"OPEN FAIL");
        return nil;
    }
    
    FMResultSet* set = [self.dataBase executeQuery:SQL_SELECT_STATUS,@(status)];
    
    NSMutableArray* ret = [self fromResultSet:set];
    
    [self.dataBase close];
    
    return ret;
}

-(NSMutableArray*) getDownloadObject: (NSString*) url {
    if (![self.dataBase open]) {
        NSLog(@"OPEN FAIL");
        return nil;
    }
    
    FMResultSet* set = [self.dataBase executeQuery:SQL_SELECT_EXIST,url];
    
    NSMutableArray* ret = [self fromResultSet:set];
    
    [self.dataBase close];
    
    return ret;
}

-(BOOL) insertDownloadObject:(DownloadObject*) dwObject {
    
    if (![self.dataBase open]){
        NSLog(@"OPEN FAIL");
        return false;
    }
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    //(url,created_at,current_size,total_size,status,save_path,classType,objectJson)
    BOOL success=[_dataBase executeUpdate:SQL_INSERT,dwObject.url,@(timestamp),@(0),@(0),@(dwObject.status),dwObject.localPath,dwObject.className,dwObject.objectJson];
    if (success) {
        NSLog(@"INSERT SUCCESS");
    }else{
        NSLog(@"INSERT FAILED");
    }
    
    [self.dataBase close];
    
    return success;
}

-(BOOL) updateDownloadObject:(DownloadObject*) dwObject {
    if (![self.dataBase open]){
        NSLog(@"OPEN FAIL");
        return NO;
    }

    BOOL success=[self.dataBase executeUpdate:SQL_UPDATE, @(dwObject.currentSize), @(dwObject.totalSize), @(dwObject.status),dwObject.url];
    if (success) {
        NSLog(@"UPDATE SUCCESS");
    }else{
        NSLog(@"UPDATE FAILED");
    }
    
    [self.dataBase close];
    return success;
}

-(BOOL) deleteDownloadObject:(DownloadObject*) dwObject{
    if (![self.dataBase open]){
        NSLog(@"OPEN FAIL");
        return NO;
    }

    BOOL success=[self.dataBase executeUpdate:SQL_DELETE, dwObject.url];
    if (success) {
        NSLog(@"DELETE SUCCESS");
    }else{
        NSLog(@"DELETE FAILED");
    }
    
    [self.dataBase close];
    return success;
}

-(BOOL) deleteObj:(NSString*) url{
    if (![self.dataBase open]){
        NSLog(@"OPEN FAIL");
        return NO;
    }
    
    BOOL success=[self.dataBase executeUpdate:SQL_DELETE, url];
    if (success) {
        NSLog(@"DELETE SUCCESS");
    }else{
        NSLog(@"DELETE FAILED");
    }
    
    [self.dataBase close];
    return success;
}

#pragma async method
-(void) insertDownloadObjectAsync:(DownloadObject*) dwObject {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:SQL_INSERT,dwObject.url,timestamp,0,0,dwObject.status,dwObject.localPath,dwObject.className,dwObject.objectJson];
        if (success) {
            NSLog(@"DELETE SUCCESS");
        }else{
            NSLog(@"DELETE FAILED");
        }
    }];
}

-(void) updateDownloadObjectAsync:(DownloadObject*) dwObject block:(void (^)(BOOL result))block{
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:SQL_UPDATE, @(dwObject.currentSize), @(dwObject.totalSize), @(dwObject.status), dwObject.url];
        if (success) {
            NSLog(@"UPDATE SUCCESS");
        }else{
            NSLog(@"UPDATE FAILED");
        }
        if (block != nil) {
            block(success);
        }
        
    }];
}

-(void) deleteDownloadObjectAsync:(DownloadObject*) dwObject{
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:SQL_DELETE, dwObject.url];
        if (success) {
            NSLog(@"DELETE SUCCESS");
        }else{
            NSLog(@"DELETE FAILED");
        }
    }];
}

-(NSMutableArray*) fromResultSet:(FMResultSet*) set {
    NSMutableArray *array = nil;
    
    while([set next]) {
        array = [NSMutableArray array];
        DownloadObject* obj = [DownloadObject fromResultSet:set];
        [array addObject:obj];
    }
    
    return array;
}

@end
