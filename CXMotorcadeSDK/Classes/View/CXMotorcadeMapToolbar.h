//
//  CXMotorcadeMapToolbar.h
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import <UIKit/UIKit.h>

@class CXMotorcadeMapToolbar;

@protocol CXMotorcadeMapToolbarDelegate <NSObject>

@optional

- (void)motorcadeMapToolbarDidGlobalLocationAction:(CXMotorcadeMapToolbar *)toolbar;
- (void)motorcadeMapToolbarDidSelfLocationAction:(CXMotorcadeMapToolbar *)toolbar;
- (void)motorcadeMapToolbar:(CXMotorcadeMapToolbar *)toolbar didActionWithShowTraffic:(BOOL)showTraffic;

@end

@interface CXMotorcadeMapToolbar : UIView

@property (nonatomic, weak) id<CXMotorcadeMapToolbarDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isFollowSelfLocation;

@end
