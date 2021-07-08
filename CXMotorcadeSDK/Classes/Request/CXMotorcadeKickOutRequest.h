//
//  CXMotorcadeKickOutRequest.h
//  Pods
//
//  Created by wshaolin on 2019/4/17.
//

#import "CXBaseMotorcadeURLRequest.h"

@interface CXMotorcadeKickOutRequest : CXBaseMotorcadeURLRequest

// userIds 逗号分隔的字符串
- (instancetype)initWithMotorcadeId:(NSString *)motorcadeId
                            userIds:(NSString *)userIds;

@end
