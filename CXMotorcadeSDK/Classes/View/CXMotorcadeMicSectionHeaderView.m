//
//  CXMotorcadeMicSectionHeaderView.m
//  Pods
//
//  Created by wshaolin on 2019/4/17.
//

#import "CXMotorcadeMicSectionHeaderView.h"
#import <CXUIKit/CXUIKit.h>

@interface CXMotorcadeMicSectionHeaderView () {
    UILabel *_titleLabel;
}

@end

@implementation CXMotorcadeMicSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundView.backgroundColor = CXHexIColor(0xF9F9F9);
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = CX_PingFangSC_RegularFont(12.0);
        _titleLabel.textColor = [CXHexIColor(0x333333) colorWithAlphaComponent:0.6];
        _titleLabel.text = @"小队成员";
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat titleLabel_X = 15.0;
    CGFloat titleLabel_Y = 0;
    CGFloat titleLabel_W = CGRectGetWidth(self.bounds) - titleLabel_X * 2;
    CGFloat titleLabel_H = CGRectGetHeight(self.bounds);
    _titleLabel.frame = CGRectMake(titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H);
}

@end
