//
//  CXBaseUserJSONModel.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import <CXNetSDK/CXNetSDK.h>

@interface CXBaseUserJSONModel : NSObject

@property (nonatomic, copy) NSString *userId;

- (BOOL)isSelf;

@end
