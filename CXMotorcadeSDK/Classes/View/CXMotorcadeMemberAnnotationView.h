//
//  CXMotorcadeMemberAnnotationView.h
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import <CXMapKit/CXMapKit.h>

@class CXMotorcadeUserInfoModel;

@interface CXMotorcadeMemberAnnotationView : CXBubbleAnnotationView

@property (nonatomic, strong) CXMotorcadeUserInfoModel *memberInfoModel;

@end

@interface CXMotorcadeMemberAnnotationBubbleView : UIControl

- (void)setMemberInfoModel:(CXMotorcadeUserInfoModel *)infoModel;

@end
