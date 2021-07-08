//
//  CXMotorcadePOITableHeaderView.h
//  Pods
//
//  Created by wshaolin on 2019/4/15.
//

#import <UIKit/UIKit.h>

@class CXMotorcadePOITableHeaderView;

@protocol CXMotorcadePOITableHeaderViewDelegate <NSObject>

@optional

- (void)POITableHeaderViewDidDragSelectionAction:(CXMotorcadePOITableHeaderView *)headerView;
- (void)POITableHeaderViewDidCurrentLocationAction:(CXMotorcadePOITableHeaderView *)headerView;

@end

@interface CXMotorcadePOITableHeaderView : UIView

@property (nonatomic, weak) id<CXMotorcadePOITableHeaderViewDelegate> delegate;

@end
