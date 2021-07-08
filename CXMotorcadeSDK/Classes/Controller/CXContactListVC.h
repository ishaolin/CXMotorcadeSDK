//
//  CXContactListVC.h
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXBaseViewController.h"
#import <CXFoundation/CXFoundation.h>

@class CXContactListVC;

@protocol CXContactListVCDelegate <NSObject>

@optional

- (void)contactListVC:(CXContactListVC *)listVC didSelectContact:(CXContact *)contact;

@end

@interface CXContactListVC : CXBaseViewController

@property (nonatomic, weak) id<CXContactListVCDelegate> delegate;

@end
