//
//  CXMotorcadeAnnotationUtils.m
//  Pods
//
//  Created by wshaolin on 2019/4/11.
//

#import "CXMotorcadeAnnotationUtils.h"
#import "CXMotorcadeUserListModel.h"

@implementation CXMotorcadeAnnotationUtils

+ (CXMotorcadeMemberAnnotation *)memberAnnotationById:(NSString *)memberId
                                          annotations:(NSArray<id<MAAnnotation>> *)annotations{
    if(CXStringIsEmpty(memberId)){
        return nil;
    }
    
    __block CXMotorcadeMemberAnnotation *targetAnnotation = nil;
    [annotations enumerateObjectsUsingBlock:^(id<MAAnnotation> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[CXMotorcadeMemberAnnotation class]]){
            return;
        }
        
        CXMotorcadeMemberAnnotation *annotation = (CXMotorcadeMemberAnnotation *)obj;
        if([annotation.memberInfoModel.userId isEqualToString:memberId]){
            targetAnnotation = annotation;
            *stop = YES;
        }
    }];
    
    return targetAnnotation;
}

+ (BOOL)annotation:(CXMotorcadeMemberAnnotation *)annotation
      inMemberList:(NSArray<CXMotorcadeUserInfoModel *> *)memberList
      belongMember:(CXMotorcadeUserInfoModel **)belongMember{
    __block BOOL existed = NO;
    __block CXMotorcadeUserInfoModel *memberInfoModel = nil;
    [memberList enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([annotation.memberInfoModel.userId isEqualToString:obj.userId]){
            memberInfoModel = obj;
            existed = YES;
            *stop = YES;
        }
    }];
    
    if(belongMember){
        *belongMember = memberInfoModel;
    }
    
    return existed;
}

@end
