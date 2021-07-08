//
//  CXIMSpeakDragView.m
//  Pods
//
//  Created by wshaolin on 2019/4/10.
//

#import "CXIMSpeakDragView.h"
#import "CXMotorcadeDefines.h"

@interface CXIMSpeakDragView () {
    UIImageView *_imageView;
}

@end

@implementation CXIMSpeakDragView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForPanGestureRecognizer:)]];
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGestureRecognizer:)]];
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        [self resetting];
    }
    
    return self;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    _edgeInsets = edgeInsets;
    [self setFrameCenter:self.center animated:YES];
}

- (void)resetting{
    _imageView.image = CX_MOTORCADE_IMAGE(@"motorcade_chat_mic_drag");
}

- (void)handleActionForPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint point = [gestureRecognizer locationInView:self.superview];
        [self setFrameCenter:point animated:NO];
    }
    
    if([self.delegate respondsToSelector:@selector(IMSpeakDragView:didDragActionForState:)]){
        [self.delegate IMSpeakDragView:self didDragActionForState:gestureRecognizer.state];
    }
}

- (void)setFrameCenter:(CGPoint )center animated:(BOOL)animated{
    if(center.x < self.edgeInsets.left + CGRectGetWidth(self.bounds) * 0.5){
        center.x = self.edgeInsets.left + CGRectGetWidth(self.bounds) * 0.5;
    }
    
    if(center.x > CGRectGetWidth(self.superview.bounds) - self.edgeInsets.right - CGRectGetWidth(self.bounds) * 0.5){
        center.x = CGRectGetWidth(self.superview.bounds) - self.edgeInsets.right - CGRectGetWidth(self.bounds) * 0.5;
    }
    
    if(center.y < self.edgeInsets.top + CGRectGetHeight(self.bounds) * 0.5){
        center.y = self.edgeInsets.top + CGRectGetHeight(self.bounds) * 0.5;
    }
    
    if(center.y > CGRectGetHeight(self.superview.bounds) - self.edgeInsets.bottom - CGRectGetHeight(self.bounds) * 0.5){
        center.y = CGRectGetHeight(self.superview.bounds) - self.edgeInsets.bottom - CGRectGetHeight(self.bounds) * 0.5;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
        self.center = center;
    }];
}

- (void)handleActionForLongPressGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer{
    UIGestureRecognizerState state = gestureRecognizer.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            _imageView.image = CX_MOTORCADE_IMAGE(@"motorcade_chat_mic_pressed");
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            [self resetting];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            CGPoint point = [gestureRecognizer locationInView:self];
            if(!CGRectContainsPoint(self.bounds, point)){
                state = UIGestureRecognizerStateCancelled;
            }
            
            [self resetting];
        }
            break;
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(IMSpeakDragView:didLongPressActionForState:)]){
        [self.delegate IMSpeakDragView:self didLongPressActionForState:state];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

@end

@interface CXIMSpeakAnimationView () {
    UIImageView *_micImageView;
    UIImageView *_animationView;
    CAShapeLayer *_shapeLayer;
}

@end

@implementation CXIMSpeakAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.panelSize = CGSizeMake(130.0, 130.0);
        self.overlayStyle = CXActionPanelOverlayStyleClear;
        self.animationType = CXActionPanelAnimationCenter;
        
        _micImageView = [[UIImageView alloc]init];
        _micImageView.image = CX_MOTORCADE_IMAGE(@"motorcade_chat_speaking_mic");
        [self addSubview:_micImageView];
        
        _animationView = [[UIImageView alloc]init];
        _animationView.image = CX_MOTORCADE_IMAGE(@"motorcade_chat_mic_animation");
        [self addSubview:_animationView];
        
        _shapeLayer = [[CAShapeLayer alloc]init];
        _shapeLayer.anchorPoint = CGPointZero;
        _shapeLayer.position = CGPointZero;
    }
    
    return self;
}

- (UIView *)overlayView{
    return nil;
}

- (void)setSpeakPower:(CGFloat)speakPower{
    _speakPower = MIN(1.0, MAX(0.1, speakPower));
    CGFloat animationView_H = CGRectGetHeight(_animationView.frame);
    _shapeLayer.position = CGPointMake(0, (1 - _speakPower) * animationView_H);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat micImageView_X = 34.0;
    CGFloat micImageView_Y = 31.0;
    CGFloat micImageView_W = 37.0;
    CGFloat micImageView_H = 62.0;
    _micImageView.frame = (CGRect){micImageView_X, micImageView_Y, micImageView_W, micImageView_H};
    
    CGFloat animationView_X = 76.0;
    CGFloat animationView_Y = 45.0;
    CGFloat animationView_W = 21.0;
    CGFloat animationView_H = 45.0;
    _animationView.frame = (CGRect){animationView_X, animationView_Y, animationView_W, animationView_H};
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_animationView.bounds];
    _shapeLayer.path = path.CGPath;
    _animationView.layer.mask = _shapeLayer;
    
    [self cx_roundedCornerRadii:4.0];
}

@end
