//
//  CXMotorcadeSocketHandler.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import <Foundation/Foundation.h>

@class CXSocketPushContent;

@interface CXMotorcadeSocketHandler : NSObject

+ (BOOL)canHandleSocketPushContent:(CXSocketPushContent *)content;

+ (void)handleSocketPushContent:(CXSocketPushContent *)content;

@end
