//
//  CXMicPermissionChangeModel.h
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CXMicPermissionChangeType) {
    CXMicPermissionChangeAll,
    CXMicPermissionChangeMember
};

@interface CXMicPermissionChangeModel : NSObject

@property (nonatomic, assign) CXMicPermissionChangeType changeType;
@property (nonatomic, assign) BOOL micPermission;
@property (nonatomic, copy) NSString *userId;

@end
