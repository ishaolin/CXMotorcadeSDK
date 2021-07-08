//
//  CXCmdEnterMotorcadeRequest.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXBaseMotorcadeURLRequest.h"
#import "CXMotorcadeOnlineModel.h"

@interface CXCmdEnterMotorcadeRequest : CXBaseMotorcadeURLRequest

- (instancetype)initWithCommand:(NSString *)command;

@end
