//
//  CXMotorcadeSchemeRegistrar.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeSchemeRegistrar.h"
#import "CXMotorcadeListVC.h"
#import "CXMotorcadeTalkbackVC.h"
#import "CXMotorcadeMapVC.h"

@implementation CXMotorcadeSchemeRegistrar

+ (void)registerSupportiveClass{
    [CXMotorcadeListVC registerSchemeSupporter];
    [CXMotorcadeTalkbackVC registerSchemeSupporter];
    [CXMotorcadeMapVC registerSchemeSupporter];
}

@end
