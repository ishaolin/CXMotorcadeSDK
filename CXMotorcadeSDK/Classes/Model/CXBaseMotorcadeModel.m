//
//  CXBaseMotorcadeModel.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXBaseMotorcadeModel.h"

@implementation CXBaseMotorcadeModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"code" : @"errno", @"msg" : @"errmsg"};
}

@end
