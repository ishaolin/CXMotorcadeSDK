//
//  CXMotorcadeListModel.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeListModel.h"

@implementation CXMotorcadeListModel

@end

@implementation CXMotorcadeListResultModel

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [CXMotorcadeListDataModel class]};
}

@end

@implementation CXMotorcadeListDataModel

@end
