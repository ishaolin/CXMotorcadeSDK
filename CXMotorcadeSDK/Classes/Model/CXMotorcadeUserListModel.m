//
//  CXMotorcadeUserListModel.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeUserListModel.h"

@implementation CXMotorcadeUserListModel

@end

@implementation CXMotorcadeUserListResultModel

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [CXMotorcadeUserInfoModel class]};
}

@end

@implementation CXMotorcadeUserInfoModel

@end
