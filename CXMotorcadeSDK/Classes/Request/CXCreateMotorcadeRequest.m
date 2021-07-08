//
//  CXCreateMotorcadeRequest.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXCreateMotorcadeRequest.h"

@implementation CXCreateMotorcadeRequest

- (instancetype)initWithVoiceMode:(NSNumber *)voiceMode{
    if(self = [super init]){
        [self addParam:voiceMode forKey:@"groupChat"];
        [self addParam:@"[]" forKey:@"friendList"];
    }
    
    return self;
}

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/motorcadeServer/app/motorcadeManage/createMotorcadeWithFriends";
}

- (id)modelWithData:(id)data{
    return [CXMotorcadeOnlineModel cx_modelWithData:data];
}

@end
