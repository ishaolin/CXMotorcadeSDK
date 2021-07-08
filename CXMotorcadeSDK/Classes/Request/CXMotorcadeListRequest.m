//
//  CXMotorcadeListRequest.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeListRequest.h"

@implementation CXMotorcadeListRequest

- (NSString *)path{
    return @"/motorcadeServer/app/motorcadeManage/motorcadeList";
}

- (id)modelWithData:(id)data{
    return [CXMotorcadeListModel cx_modelWithData:data];
}

@end
