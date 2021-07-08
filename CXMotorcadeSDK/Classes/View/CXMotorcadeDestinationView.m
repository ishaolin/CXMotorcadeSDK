//
//  CXMotorcadeDestinationView.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeDestinationView.h"
#import <CXUIKit/CXUIKit.h>
#import "CXMotorcadeDefines.h"

@interface CXMotorcadeDestinationView () {
    UIImageView *_imageView;
    UILabel *_destinationLabel;
    UIButton *_actionButton;
    UIView *_lineView;
}

@end

@implementation CXMotorcadeDestinationView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _imageView = [[UIImageView alloc] init];
        _imageView.image = CX_MOTORCADE_IMAGE(@"motorcade_poi_drag_point");
        
        _destinationLabel = [[UILabel alloc] init];
        _destinationLabel.font = CX_PingFangSC_RegularFont(14.0);
        _destinationLabel.textAlignment = NSTextAlignmentLeft;
        [_destinationLabel setTextColor:CXHexIColor(0x333333)];
        _destinationLabel.userInteractionEnabled = YES;
        [_destinationLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDestinationLabelTapGestureRecognizer:)]];
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton.titleLabel setFont:CX_PingFangSC_RegularFont(12.0)];
        [_actionButton setTitle:@"导航" forState:UIControlStateNormal];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton cx_setBackgroundColor:CXHexIColor(0x00CDFF) forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(handleActionForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CXHexIColor(0xF0F0F0);
        
        [self addSubview:_imageView];
        [self addSubview:_destinationLabel];
        [self addSubview:_actionButton];
        [self addSubview:_lineView];
    }
    
    return self;
}

- (void)setDestination:(NSString *)destination{
    _destination = destination;
    
    if(CXStringIsEmpty(destination)){
        _destinationLabel.text = @"设置小队目的地";
        [_destinationLabel setTextColor:CXHexIColor(0x666666)];
        _actionButton.hidden = YES;
    }else{
        _destinationLabel.text = destination;
        [_destinationLabel setTextColor:CXHexIColor(0x333333)];
        _actionButton.hidden = NO;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineView_X = 0;
    CGFloat lineView_H = 0.75;
    CGFloat lineView_Y = CGRectGetHeight(self.bounds) - lineView_H;
    CGFloat lineView_W = CGRectGetWidth(self.bounds);
    _lineView.frame = (CGRect){lineView_X, lineView_Y, lineView_W, lineView_H};
    
    CGFloat imageView_W = 20.0;
    CGFloat imageView_H = 20.0;
    CGFloat imageView_X = 18.0;
    CGFloat imageView_Y = (CGRectGetHeight(self.bounds) - imageView_H) * 0.5;
    _imageView.frame = (CGRect){imageView_X, imageView_Y, imageView_W, imageView_H};
    
    CGFloat actionButton_H = 23.0;
    CGFloat actionButton_W = 44.0;
    CGFloat actionButton_X = CGRectGetWidth(self.bounds) - actionButton_W - imageView_X;
    CGFloat actionButton_Y = (CGRectGetHeight(self.bounds) - actionButton_H) * 0.5;
    _actionButton.frame = (CGRect){actionButton_X, actionButton_Y, actionButton_W, actionButton_H};
    [_actionButton cx_roundedCornerRadii:4.0];
    
    CGFloat destinationLabel_X = CGRectGetMaxX(_imageView.frame) + 5.0;
    CGFloat destinationLabel_H = CGRectGetHeight(self.frame);
    CGFloat destinationLabel_Y = 0;
    CGFloat destinationLabel_W = 0;
    
    if(_actionButton.isHidden){
        destinationLabel_W = CGRectGetMaxX(_actionButton.frame) - destinationLabel_X;
    }else{
        destinationLabel_W = CGRectGetMinX(_actionButton.frame) - destinationLabel_X;
    }
    
    _destinationLabel.frame = (CGRect){destinationLabel_X, destinationLabel_Y, destinationLabel_W, destinationLabel_H};
}

- (void)handleDestinationLabelTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    if([self.delegate respondsToSelector:@selector(destinationViewDidSetDestinationAction:)]){
        [self.delegate destinationViewDidSetDestinationAction:self];
    }
}

- (void)handleActionForButton:(UIButton *)actionButton {
    if([self.delegate respondsToSelector:@selector(destinationViewDidGoToNavgationAction:)]){
        [self.delegate destinationViewDidGoToNavgationAction:self];
    }
}

@end
