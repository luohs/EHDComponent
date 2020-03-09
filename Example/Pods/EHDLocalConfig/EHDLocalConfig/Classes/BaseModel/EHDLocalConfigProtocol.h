//
//  EHDLocalConfigProtocol.h
//  Pods
//
//  Created by luohs on 2017/11/17.
//
//

#import <Foundation/Foundation.h>

@protocol EHDLocalConfigProtocol <NSObject>
@optional
+ (NSDictionary *)titlesByPropertyKey;
+ (NSSet *)keysThatContentsCanBeEmpty;
@end
