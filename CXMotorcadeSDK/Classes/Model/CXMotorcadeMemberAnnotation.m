//
//  CXMotorcadeMemberAnnotation.m
//  Pods
//
//  Created by wshaolin on 2019/4/11.
//

#import "CXMotorcadeMemberAnnotation.h"

@implementation CXMotorcadeMemberAnnotation

- (instancetype)initWithMemberInfoModel:(CXMotorcadeUserInfoModel *)memberInfoModel{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(memberInfoModel.lat, memberInfoModel.lng);
    UIImage *image = CX_MOTORCADE_IMAGE(@"motorcade_user_avatar");
    image = [CXMotorcadeMemberAnnotation annotationImageWithSex:CXUserSexMale avatar:image];
    if(self = [super initWithCoordinate:coordinate image:image]){
        _memberInfoModel = memberInfoModel;
        self.coorOffset = CGPointMake(0, 5.0);
        self.calloutOffset = CGPointMake(0, -6.0);
        self.zIndex = 10;
    }
    
    return self;
}

+ (UIImage *)annotationImageWithSex:(CXUserSexType)sex avatar:(UIImage *)avatar{
    UIImage *image1;
    if(sex == CXUserSexFemale){
        image1 = CX_MOTORCADE_IMAGE(@"motorcade_annotion_girl");
    }else{
        image1 = CX_MOTORCADE_IMAGE(@"motorcade_annotion_boy");
    }
    
    UIImage *image2 = [avatar cx_resizeImage:CGSizeMake(image1.size.width - 4.0, image1.size.width - 4.0)];
    image2 = [image2 cx_roundImage];
    
    CGFloat x = (image1.size.width - image2.size.width) * 0.5;
    CGFloat y = x;
    CGRect rect = (CGRect){x, y, image2.size};
    return [image1 cx_composeImage:image2 rect:rect];
}

@end
