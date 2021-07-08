//
//  CXMotorcadeUserListRequest.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeUserListRequest.h"

@implementation CXMotorcadeUserListRequest

- (NSString *)path{
    return @"/carlife/motorcade/userList";
}

- (id)modelWithData:(id)data{
    return [CXMotorcadeUserListModel cx_modelWithData:data];
}

@end
