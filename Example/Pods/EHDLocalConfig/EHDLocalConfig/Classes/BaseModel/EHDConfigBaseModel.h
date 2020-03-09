//
//  EHDConfigBaseModel.h
//  Pods
//
//  Created by luohs on 2017/11/17.
//
//

#import <Foundation/Foundation.h>
#import "EHDLocalConfigProtocol.h"

@interface EHDConfigBaseModel : NSObject <NSCopying, EHDLocalConfigProtocol>
- (BOOL)isValid:(NSString **)errorInfo;
- (void)padding;//填充
@end
