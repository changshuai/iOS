//
//  NSObject+json.m
//  HSDownloadManagerExample
//
//  Created by changshuai on 6/13/16.
//  Copyright © 2016 hans. All rights reserved.
//

#import "NSObject+json.h"
#import <objc/runtime.h>

@implementation NSObject (json)
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
            if([key isEqualToString:@"hash"] || [key isEqualToString:@"superclass"] || [key isEqualToString:@"debugDescription"] || [key isEqualToString:@"description"]) {
                continue;
            }
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
