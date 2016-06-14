//
//  HSDownloadManagerExampleTests.m
//  HSDownloadManagerExampleTests
//
//  Created by changshuai on 6/12/16.
//  Copyright © 2016 hans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DownloadDao.h"
#import "DownloadObject.h"

@interface HSDownloadManagerExampleTests : XCTestCase

@end

@implementation HSDownloadManagerExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSLog(@"testExample");
    
}

- (void)testDBCreate {
    
    NSString* filePath = [[DownloadDao sharedManager] getPath];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    XCTAssertEqual(true, isExist, @"DB文件已存在");
}

- (void)testInsertDownloadObject {
    DownloadObject* object = [[DownloadObject alloc] init];
    object.url = @"http://www.baidu.com/test.html";
    object.localPath = @"c:";
    object.currentSize = 0;
    object.totalSize = 0;
    object.className = @"Music";
    object.objectJson = @"{id:1,url:test}";
    
    BOOL ret = [[DownloadDao sharedManager] insertDownloadObject:object];
    XCTAssertEqual(true, ret, @"insert failed");
}

- (void)testQueryList {
    NSMutableArray* array = [[DownloadDao sharedManager] getDownloadObjectList:@"music" withStatus:0];
    NSLog(@"array size is:%lu", (unsigned long)[array count]);
    
    for (DownloadObject* obj in array) {
        NSLog(@"obj url:%@ className:%@ ", obj.url, obj.className);
    }
    
}

- (void)testQueryStatus {
    NSArray* array  = [[DownloadDao sharedManager] getDownloadObjectList:0];
    
    for (DownloadObject* obj in array) {
        NSLog(@"obj url:%@ className:%@ ", obj.url, obj.className);
    }
}

- (void)testUpdateDB{
    DownloadObject* object = [[DownloadObject alloc] init];
    object.url = @"http://www.baidu.com/test.html";
    object.localPath = @"c:";
    object.currentSize = 100;
    object.totalSize = 1000;
    object.className = @"Music";
    object.objectJson = @"{id:1,url:test}";
    object.status = 2;
    
    BOOL ret = [[DownloadDao sharedManager] updateDownloadObject:object];
    NSMutableArray* set = [[DownloadDao sharedManager] getDownloadObject:object.url];
    BOOL exist = [set count] > 0;
    XCTAssertEqual(exist, ret, @"");
    
    //DownloadObject* object1 = [[DownloadObject alloc] init];
    object.url = @"http://www.sohu.com/test.html";
    object.localPath = @"c:";
    object.currentSize = 100;
    object.totalSize = 2000;
    object.className = @"Music";
    object.objectJson = @"{id:1,url:test}";
    
    ret = [[DownloadDao sharedManager] updateDownloadObject:object];
    set = [[DownloadDao sharedManager] getDownloadObject:object.url];
    
}

- (void)testDelete {
    DownloadObject* object = [[DownloadObject alloc] init];
    object.url = @"http://www.baidu.com/test1.html";
    object.localPath = @"c:";
    object.currentSize = 0;
    object.totalSize = 0;
    object.className = @"Music";
    object.objectJson = @"{id:1,url:test}";
    
    BOOL ret = [[DownloadDao sharedManager] insertDownloadObject:object];
    ret = [[DownloadDao sharedManager] insertDownloadObject:object];
    XCTAssertEqual(true, ret, @"insert failed");
    
    ret = [[DownloadDao sharedManager] deleteObj:object.url];
    XCTAssertEqual(true, ret, @"delete failed");
}

- (void) testUpdateAsync {
    DownloadObject* object = [[DownloadObject alloc] init];
    object.url = @"http://www.baidu.com/test3.html";
    object.localPath = @"c:";
    object.currentSize = 100;
    object.totalSize = 5000;
    object.className = @"Music";
    object.objectJson = @"{id:1,url:test}";
    
    [[DownloadDao sharedManager] updateDownloadObjectAsync:object block:^(BOOL result){
        XCTAssertEqual(true,result,@"");
        if(result) {
            NSLog(@"update success!");
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
