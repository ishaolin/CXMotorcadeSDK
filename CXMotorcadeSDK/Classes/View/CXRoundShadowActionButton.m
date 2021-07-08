//
//  CXRoundShadowActionButton.m
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXRoundShadowActionButton.h"

@interface CXRoundShadowActionButton () {
    CALayer *_shadowLayer;
    UIButton *_actionButton;
}

@end

@implementation CXRoundShadowActionButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _enabled = YES;
        
        _shadowLayer = [CALayer layer];
        _shadowLayer.backgroundColor = CXHexIColor(0x00B6FF).CGColor;
        _shadowLayer.shadowColor = CXHexIColor(0x00B6FF).CGColor;
        _shadowLayer.shadowOffset = CGSizeMake(0, 4.0);
        _shadowLayer.shadowOpacity = 0.3;
        _shadowLayer.shadowRadius = 6.0;
        [self.layer addSublayer:_shadowLayer];
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _actionButton.titleLabel.font = CX_PingFangSC_SemiboldFont(16.0);
        [_actionButton cx_setBackgroundColors:@[CXHexIColor(0x00CDFF), CXHexIColor(0x00B7FF)]
                            gradientDirection:CXColorGradientHorizontal
                                     forState:UIControlStateNormal];
        [_actionButton cx_setBackgroundColors:@[CXHexIColor(0x00B8E5), CXHexIColor(0x00A5E6)]
                            gradientDirection:CXColorGradientHorizontal
                                     forState:UIControlStateHighlighted];
        [_actionButton cx_setBackgroundColors:@[CXHexIColor(0x7FE6FF), CXHexIColor(0x7FDCFF)]
                            gradientDirection:CXColorGradientHorizontal
                                     forState:UIControlStateDisabled];
        [self addSubview:_actionButton];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title{
    [_actionButton setTitle:title forState:UIControlStateNormal];
}

- (NSString *)title{
    return [_actionButton titleForState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action{
    [_actionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
    _actionButton.enabled = _enabled;
    _shadowLayer.hidden = !_enabled;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _shadowLayer.frame = self.bounds;
    _actionButton.frame = self.bounds;
    
    CGFloat cornerRadius = MIN(CGRectGetWidth(_shadowLayer.frame), CGRectGetHeight(_shadowLayer.frame)) * 0.5;
    _shadowLayer.cornerRadius = cornerRadius;
    [_actionButton cx_roundedCornerRadii:cornerRadius];
}

@end
