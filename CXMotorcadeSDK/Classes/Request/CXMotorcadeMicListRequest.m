//
//  CXMotorcadeMicListRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import "CXMotorcadeMicListRequest.h"

@implementation CXMotorcadeMicListRequest

- (NSString *)path{
    return @"/motorcadeServer/app/motorcade/user/getMicList";
}

- (id)modelWithData:(id)data{
    return [CXMotorcadeMicListModel cx_modelWithData:data];
}

@end
