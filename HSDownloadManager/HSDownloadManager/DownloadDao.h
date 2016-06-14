//
//  DownloadDao.h
//  HSDownloadManagerExample
//
//  Created by changshuai on 6/5/16.
//  Copyright © 2016 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "DownloadObject.h"

@interface DownloadDao : NSObject

+ (DownloadDao *) sharedManager;
-(void) createTable;
-(NSString*) getPath;

// for download manager
// insert download object  // for user add one download task waiting
// update download object
-(BOOL) insertDownloadObject:(DownloadObject*) dwObject;
-(BOOL) updateDownloadObject:(DownloadObject*) dwObject;
-(BOOL) deleteDownloadObject:(DownloadObject*) dwObject;
// for view display
// get a list filter by type and download status
-(NSMutableArray*) getDownloadObjectList: (NSInteger)status;
-(NSMutableArray*) getDownloadObjectList: (NSString*) className withStatus:(NSInteger)status;

-(void) insertDownloadObjectAsync:(DownloadObject*) dwObject;
-(void) updateDownloadObjectAsync:(DownloadObject*) dwObject block:(void (^)(BOOL result))block;

-(NSMutableArray*) getDownloadObject: (NSString*) url;
-(BOOL) deleteObj:(NSString*) url;

@end
