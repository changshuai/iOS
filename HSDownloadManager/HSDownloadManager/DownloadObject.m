//
//  DownloadObject.m
//  HSDownloadManagerExample
//
//  Created by changshuai on 5/27/16.
//  Copyright © 2016 hans. All rights reserved.
//

#import "DownloadObject.h"
#import <objc/runtime.h>

@implementation DownloadObject


+(DownloadObject*) fromResultSet:(FMResultSet*)set {
    DownloadObject* obj = [[DownloadObject alloc] init];
    obj.url = [set stringForColumn:@"url"];
    obj.currentSize = [set longForColumn:@"current_size"];
    obj.totalSize = [set longForColumn:@"total_size"];
    obj.status = [set intForColumn:@"status"];
    obj.localPath = [set stringForColumn:@"save_path"];
    obj.className = [set stringForColumn:@"classType"];
    obj.objectJson = [set stringForColumn:@"objectJson"];
    
    return obj;
}

+(id) getClassObject:(DownloadObject*) down_obj {
    Class tempClass =  NSClassFromString(down_obj.className);
    
    if(!tempClass) {
        return nil;
    }
    
    NSData *data = [down_obj.objectJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    // class 需要重写 initWithDictionary
    id object = [tempClass initWithDictionary:dic];
    
    return object;
}

-(NSArray*)propertyKeys

{
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}

- (NSDictionary *)dictionaryReflectFromAttributes
{
    @autoreleasepool
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        unsigned int count = 0;
        objc_property_t *attributes = class_copyPropertyList([self class], &count);
        objc_property_t property;
        NSString *key, *value;
        
        for (int i = 0; i < count; i++)
        {
            property = attributes[i];
            key = [NSString stringWithUTF8String:property_getName(property)];
            value = [self valueForKey:key];
            [dict setObject:(value ? value : @"") forKey:key];
        }
        
        free(attributes);
        attributes = nil;
        
        return dict;
    }
}

- (NSString *)JSONString
{
    NSDictionary *dict = [self dictionaryReflectFromAttributes];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData.length > 0 && !error)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

@end
