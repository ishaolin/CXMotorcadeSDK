//
//  CXMotorcadeInvitationCell.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXMotorcadeInvitationCell.h"

@implementation CXMotorcadeInvitationCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.titleLabel.font = CX_PingFangSC_RegularFont(17.0);
        self.titleLabel.textColor = CXHexIColor(0x353C43);
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat iconView_X = CX_MARGIN(15.0);
    CGFloat iconView_W = 44.0;
    CGFloat iconView_H = iconView_W;
    CGFloat iconView_Y = (CGRectGetHeight(self.contentView.bounds) - iconView_H) * 0.5;
    self.iconView.frame = (CGRect){iconView_X, iconView_Y, iconView_W, iconView_H};
    [self.iconView cx_roundedCornerRadii:iconView_H * 0.5];
    
    CGFloat titleLabel_X = CGRectGetMaxX(self.iconView.frame) + iconView_X;
    CGFloat titleLabel_W = CGRectGetWidth(self.contentView.frame) - titleLabel_X - iconView_X;
    CGFloat titleLabel_H = iconView_H;
    CGFloat titleLabel_Y = iconView_Y;
    self.titleLabel.frame = (CGRect){titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H};
    
    CGFloat lineView_X = titleLabel_X;
    CGFloat lineView_W = CGRectGetWidth(self.contentView.frame) - lineView_X;
    CGFloat lineView_H = 0.5;
    CGFloat lineView_Y = CGRectGetHeight(self.contentView.frame) - lineView_H;
    self.lineView.frame = (CGRect){lineView_X, lineView_Y, lineView_W, lineView_H};
}

@end
