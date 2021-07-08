//
//  CXGMERoomNoRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/12.
//

#import "CXGMERoomNoRequest.h"

@implementation CXGMERoomNoRequest

- (NSString *)path{
    return @"/carlife/motorcade/getGmeRoomno";
}

- (id)modelWithData:(id)data{
    return [CXGMERoomNoModel cx_modelWithData:data];
}

@end
