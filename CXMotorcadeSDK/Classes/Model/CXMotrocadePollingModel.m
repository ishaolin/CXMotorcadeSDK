//
//  CXMotrocadePollingModel.m
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import "CXMotrocadePollingModel.h"

@implementation CXMotrocadePollingModel

@end

@implementation CXMotrocadePollingResultModel

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [CXMotorcadeUserInfoModel class]};
}

@end
