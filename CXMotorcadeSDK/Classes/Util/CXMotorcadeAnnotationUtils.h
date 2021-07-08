//
//  CXMotorcadeAnnotationUtils.h
//  Pods
//
//  Created by wshaolin on 2019/4/11.
//

#import "CXMotorcadeMemberAnnotation.h"

@class CXMotorcadeUserInfoModel;

@interface CXMotorcadeAnnotationUtils : NSObject

+ (CXMotorcadeMemberAnnotation *)memberAnnotationById:(NSString *)memberId
                                          annotations:(NSArray<id<MAAnnotation>> *)annotations;

+ (BOOL)annotation:(CXMotorcadeMemberAnnotation *)annotation
      inMemberList:(NSArray<CXMotorcadeUserInfoModel *> *)memberList
      belongMember:(CXMotorcadeUserInfoModel **)belongMember;

@end
