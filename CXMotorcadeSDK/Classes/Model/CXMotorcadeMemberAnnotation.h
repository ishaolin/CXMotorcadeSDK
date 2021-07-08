//
//  CXMotorcadeMemberAnnotation.h
//  Pods
//
//  Created by wshaolin on 2019/4/11.
//

#import <CXMapKit/CXMapKit.h>
#import "CXMotorcadeUserListModel.h"

@interface CXMotorcadeMemberAnnotation : CXBubbleAnnotation

@property (nonatomic, strong, readonly) CXMotorcadeUserInfoModel *memberInfoModel;

- (instancetype)initWithMemberInfoModel:(CXMotorcadeUserInfoModel *)memberInfoModel;

+ (UIImage *)annotationImageWithSex:(CXUserSexType)sex avatar:(UIImage *)avatar;

@end
