//
//  EHDLoadLocalConfig.m
//  Pods
//
//  Created by luohs on 2017/11/15.
//
//

#import "EHDLoadLocalConfig.h"
#import <objc/message.h>
#ifdef USE_MJEXTENSION
#import <MJExtension/MJExtension.h>
#endif
@implementation EHDLoadLocalConfig
+ (id)loadLocalConfigJSON:(NSString *)filePath model:(Class)aClass cipher:(id)cipher
{
    NSString *path = filePath;
    NSString *info = nil;
    id ret = nil;

    BOOL decrypt = NO;
    BOOL loop = YES;
    do {
        // 加载文件
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (!data) {
            info = [NSString stringWithFormat:@"无法正常读取配置文件:%@", path];
            break;
        }
        
        // 解密
        if (decrypt) {
            data = [self decryptData:data cipher:cipher];
            loop = NO;
        }
        
        if (!data) {
            info = [NSString stringWithFormat:@"%@配置文件解密失败", path];
            break;
        }
        
        // 解析成JSONObject
        NSError *error = nil;
        id JSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        if (error || !JSONObject) {
            info = [NSString stringWithFormat:@"配置文件解析失败\n%@", error];
            decrypt = YES;
        }
        
        if ([JSONObject isKindOfClass:NSDictionary.class]) {
            ret = [self modelWithJSONObject:JSONObject modelClass:aClass];
        } else if ([JSONObject isKindOfClass:NSArray.class]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in JSONObject) {
                id model = [self modelWithJSONObject:dic modelClass:aClass];
                if (model) {
                    [array addObject:model];
                }
            }
            ret = array;
        }
    } while (decrypt && loop);
    
    return ret;
}


+ (id)modelWithJSONObject:(id)JSONObject modelClass:(Class)modelClass
{
    if ([JSONObject isKindOfClass:NSDictionary.class]) {
#ifdef USE_MJEXTENSION
        id model = JSONObject;
        if ([modelClass respondsToSelector:@selector(mj_objectWithKeyValues:)]){
            model = [modelClass mj_objectWithKeyValues:JSONObject];
        }
#else
        id model = JSONObject;
#endif
        return model;
    }
    return nil;
}

+ (NSData *)decryptData:(NSData *)data cipher:(id)cipher
{
    SEL sel = NSSelectorFromString(@"aesDecryptData:withKey:");
    if ([cipher respondsToSelector:sel]){
        return ((id (*)(id, SEL, id, id))objc_msgSend)(cipher, sel, data, @"etransfar");
    }
    return data;
}

+ (NSData *)encryptData:(NSData *)data cipher:(id)cipher
{
    SEL sel = NSSelectorFromString(@"aesEncryptData:withKey:");
    if ([cipher respondsToSelector:sel]){
        return ((id (*)(id, SEL, id, id))objc_msgSend)(cipher, sel, data, @"etransfar");
    }
    return data;
}
@end
