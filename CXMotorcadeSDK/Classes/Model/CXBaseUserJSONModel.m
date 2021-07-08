//
//  CXBaseUserJSONModel.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXBaseUserJSONModel.h"
#import "CXMotorcadeManager.h"

@implementation CXBaseUserJSONModel

- (BOOL)isSelf{
    return [self.userId isEqualToString:[CXMotorcadeManager sharedManager].userInfo.userId];
}

@end
