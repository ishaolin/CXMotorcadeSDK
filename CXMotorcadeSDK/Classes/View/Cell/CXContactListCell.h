//
//  CXContactListCell.h
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import <CXUIKit/CXUIKit.h>

@interface CXContactListCell : CXTableViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *moblieLabel;
@property (nonatomic, strong, readonly) UIView *lineView;

@end

@interface CXContactListSectionHeaderView : CXTableHeaderFooterView

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@end
