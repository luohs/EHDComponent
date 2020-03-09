//
//  EHDLoadLocalConfig.h
//  Pods
//
//  Created by luohs on 2017/11/15.
//
//

#import <Foundation/Foundation.h>
@protocol EHDCryptCipherProtocol;
@interface EHDLoadLocalConfig : NSObject
+ (id)loadLocalConfigJSON:(NSString *)filePath model:(Class)aClass cipher:(id<EHDCryptCipherProtocol>)cipherClass;
@end
