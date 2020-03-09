//
//  EHDConfigBaseModel.m
//  Pods
//
//  Created by luohs on 2017/11/17.
//
//

#import "EHDConfigBaseModel.h"
#ifdef USE_MJEXTENSION
#import <MJExtension/MJExtension.h>
#endif

@interface EHDConfigBaseModel ()
+ (NSSet *)configModelPropertyKeys;
@end

@implementation EHDConfigBaseModel
#ifdef USE_MJEXTENSION
- (instancetype)copyWithZone:(NSZone *)zone
{
    EHDConfigBaseModel *model = [[self.class alloc] init];
    [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        NSString *key = property.name;
        id value = [self valueForKey:key];
        [model setValue:value forKey:key];
    }];
    return model;
}
#endif

+ (NSSet *)configModelPropertyKeys
{
    NSSet *propertyKeys = nil;
#ifdef USE_MJEXTENSION
    NSMutableSet *tmpPropertyKeys = [NSMutableSet set];
    [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        [tmpPropertyKeys addObject:property.name];
    }];
    propertyKeys = [tmpPropertyKeys copy];
#endif
    return propertyKeys;
}

- (BOOL)isValid:(NSString **)errorInfo
{
    NSSet *propertyKeys = [self.class configModelPropertyKeys];
    NSSet *keysThatContentsCanBeEmpty = nil;
    if ([self.class respondsToSelector:@selector(keysThatContentsCanBeEmpty)]) {
        keysThatContentsCanBeEmpty = [self.class keysThatContentsCanBeEmpty];
    }
    
    for (NSString *key in propertyKeys) {
        if (![keysThatContentsCanBeEmpty containsObject:key]) {
            id obj = [self valueForKey:key];
            if (!obj) {
                if (errorInfo) {
                    *errorInfo = [NSString stringWithFormat:@"ERROR: %@ = nil", key];
                }
                return NO;
            }
            else if ([obj isKindOfClass:NSString.class]) {
                NSString *string = (NSString *)obj;
                if (string.length == 0) {
                    if (errorInfo) {
                        *errorInfo = [NSString stringWithFormat:@"ERROR: %@.length = 0", key];
                    }
                    return NO;
                }
            }
            else if ([obj isKindOfClass:EHDConfigBaseModel.class]) {
                if (![obj isValid:errorInfo]) {
                    if (errorInfo) {
                        NSString *modelInfo = [NSString stringWithFormat:@"model = %@", key];
                        *errorInfo = [NSString stringWithFormat:@"%@\n%@", modelInfo, *errorInfo];
                    }
                    return NO;
                }
            }
            else {
                if (errorInfo) {
                    *errorInfo = [NSString stringWithFormat:@"ERROR: %@ is not valid", key];
                }
                return NO;
            }
        }
    }
    return YES;
}

- (void)padding
{
    NSSet *propertyKeys = [self.class configModelPropertyKeys];
    
    NSString * const emptyValue = @"";
    for (NSString *key in propertyKeys) {
        id obj = [self valueForKey:key];
        if (!obj) {
#ifdef USE_MJEXTENSION
            __block MJPropertyType *propertyType = nil;
            [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
                if ([property.name isEqualToString:key]) {
                    propertyType = property.type;
                }
            }];
            Class cls = propertyType.typeClass;
            if (cls) {
                id model = [cls mj_objectWithKeyValues:@{}];
                if (model) {
                    // 必须这样转换一次
                    [self setValue:model forKey:key];
                    obj = [self valueForKey:key];
                }
            }
#endif
        }
        if (!obj) {
            [self setValue:emptyValue forKey:key];
            continue;
        }
        if ([obj isKindOfClass:EHDConfigBaseModel.class]) {
            [obj padding];
            continue;
        }
        if (![obj isKindOfClass:NSString.class]) {
            NSString *info = [NSString stringWithFormat:@"ERROR: %@ is not valid", key];
            NSAssert(0, info);
        }
    }
}
@end
