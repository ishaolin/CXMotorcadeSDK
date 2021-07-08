//
//  CXMotorcadeNameEditCell.h
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXSettingTableViewCell.h"

@class CXMotorcadeNameEditCell;

@protocol CXMotorcadeNameEditCellDelegate <NSObject>

@optional

- (void)motorcadeNameEditCell:(CXMotorcadeNameEditCell *)editCell didChangeInputText:(NSString *)inputText;

@end

@interface CXMotorcadeNameEditCell : CXSettingTableViewCell

@property (nonatomic, weak) id<CXMotorcadeNameEditCellDelegate> delegate;

@end
