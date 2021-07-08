//
//  CXMotorcadeDestinationView.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import <UIKit/UIKit.h>

@class CXMotorcadeDestinationView;

@protocol CXMotorcadeDestinationViewDelegate <NSObject>

@optional

- (void)destinationViewDidGoToNavgationAction:(CXMotorcadeDestinationView *)destinationView;
- (void)destinationViewDidSetDestinationAction:(CXMotorcadeDestinationView *)destinationView;

@end

@interface CXMotorcadeDestinationView : UIView

@property(nonatomic, weak) id<CXMotorcadeDestinationViewDelegate> delegate;
@property (nonatomic, strong) NSString *destination;

@end
