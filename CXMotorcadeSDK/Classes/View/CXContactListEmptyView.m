//
//  CXContactListEmptyView.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXContactListEmptyView.h"

@interface CXContactListEmptyView () {
    UIImageView *_imageView;
    UILabel *_textLabel;
    UIButton *_fetchButton;
}

@end

@implementation CXContactListEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = CX_UIKIT_IMAGE(@"ui_page_error_image");
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = CX_PingFangSC_RegularFont(16.0);
        _textLabel.textColor = CXHexIColor(0x666666);
        _textLabel.text = @"未获取到手机联系人";
        [self addSubview:_textLabel];
        
        _fetchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fetchButton.titleLabel.font = CX_PingFangSC_MediumFont(16.0);
        [_fetchButton setTitle:@"获取手机通讯录" forState:UIControlStateNormal];
        [_fetchButton setTitleColor:CXHexIColor(0xFFFFFF) forState:UIControlStateNormal];
        [_fetchButton cx_setBackgroundColor:CXHexIColor(0x59D8FF) forState:UIControlStateNormal];
        [_fetchButton addTarget:self action:@selector(handleActionForFetchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fetchButton];
    }
    
    return self;
}

- (void)handleActionForFetchButton:(UIButton *)fetchButton{
    if([self.delegate respondsToSelector:@selector(contactListEmptyViewDidFetchAction:)]){
        [self.delegate contactListEmptyViewDidFetchAction:self];
    }
}

- (void)setAuthorized:(BOOL)authorized{
    _authorized = authorized;
    _fetchButton.hidden = authorized;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat imageView_W = CX_MARGIN(205.0);
    CGFloat imageView_H = imageView_W;
    CGFloat imageView_X = (CGRectGetWidth(self.bounds) - imageView_W) * 0.5;
    CGFloat imageView_Y = CX_MARGIN(50.0);
    _imageView.frame = (CGRect){imageView_X, imageView_Y, imageView_W, imageView_H};
    
    CGFloat textLabel_W = 300.0;
    CGFloat textLabel_H = 45.0;
    CGFloat textLabel_X = (CGRectGetWidth(self.bounds) - textLabel_W) * 0.5;
    CGFloat textLabel_Y = CGRectGetMaxY(_imageView.frame);
    _textLabel.frame = (CGRect){textLabel_X, textLabel_Y, textLabel_W, textLabel_H};
    
    CGFloat fetchButton_X = 20.0;
    CGFloat fetchButton_Y = CGRectGetMaxY(_textLabel.frame) + CX_MARGIN(60.0);
    CGFloat fetchButton_W = CGRectGetWidth(self.bounds) - fetchButton_X * 2;
    CGFloat fetchButton_H = 45.0;
    _fetchButton.frame = (CGRect){fetchButton_X, fetchButton_Y, fetchButton_W, fetchButton_H};
    [_fetchButton cx_roundedCornerRadii:fetchButton_H * 0.5];
}

@end
