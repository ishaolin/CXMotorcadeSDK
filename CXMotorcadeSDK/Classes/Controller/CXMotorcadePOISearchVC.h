//
//  CXMotorcadePOISearchVC.h
//  Pods
//
//  Created by wshaolin on 2019/4/14.
//

#import <CXMapKit/CXMapKit.h>

#define CXMotorcadePOIType 7

@interface CXMotorcadePOISearchVC : CXPOISearchViewController

- (instancetype)initWithCompletion:(CXPOISearchVCCompletionBlock)completion;

@end
