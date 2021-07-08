//
//  CXMotorcadeMicListModel.m
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import "CXMotorcadeMicListModel.h"

@implementation CXMotorcadeMicListModel

@end

@implementation CXMotorcadeMicListResultModel

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"userInfoList" : [CXMotorcadeMicUserInfoModel class]};
}

@end

@implementation CXMotorcadeMicUserInfoModel

@end
