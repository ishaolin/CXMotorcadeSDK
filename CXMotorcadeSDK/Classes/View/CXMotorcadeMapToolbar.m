//
//  CXMotorcadeMapToolbar.m
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXMotorcadeMapToolbar.h"
#import "CXMotorcadeDefines.h"

@interface CXMotorcadeMapToolbar () {
    CXActionItemButton *_trafficButton;
    CXActionItemButton *_globalLocationButton;
    CXActionItemButton *_selfLocationButton;
}

@end

@implementation CXMotorcadeMapToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        _trafficButton = [CXActionItemButton buttonWithType:UIButtonTypeCustom];
        [_trafficButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_map_traffic_off") forState:UIControlStateNormal];
        [_trafficButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_map_traffic_on") forState:UIControlStateSelected];
        _trafficButton.enableHighlighted = NO;
        [_trafficButton addTarget:self action:@selector(handleActionForTrafficButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _globalLocationButton = [CXActionItemButton buttonWithType:UIButtonTypeCustom];
        [_globalLocationButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_map_global_loc_selected_0")
                               forState:UIControlStateNormal];
        [_globalLocationButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_map_global_loc_selected_1")
                               forState:UIControlStateSelected];
        _globalLocationButton.enableHighlighted = NO;
        [_globalLocationButton addTarget:self action:@selector(handleActionForGlobalLocationButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _selfLocationButton = [CXActionItemButton buttonWithType:UIButtonTypeCustom];
        [_selfLocationButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_map_self_loc_selected_0")
                             forState:UIControlStateNormal];
        [_selfLocationButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_map_self_loc_selected_1")
                             forState:UIControlStateSelected];
        _selfLocationButton.enableHighlighted = NO;
        _selfLocationButton.selected = YES;
        [_selfLocationButton addTarget:self action:@selector(handleActionForSelfLocationButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_trafficButton];
        [self addSubview:_globalLocationButton];
        [self addSubview:_selfLocationButton];
    }
    
    return self;
}

- (BOOL)isFollowSelfLocation{
    return _selfLocationButton.isSelected;
}

- (void)handleActionForTrafficButton:(CXActionItemButton *)trafficButton{
    trafficButton.selected = !trafficButton.isSelected;
    if([self.delegate respondsToSelector:@selector(motorcadeMapToolbar:didActionWithShowTraffic:)]) {
        [self.delegate motorcadeMapToolbar:self didActionWithShowTraffic:trafficButton.isSelected];
    }
}

- (void)handleActionForGlobalLocationButton:(CXActionItemButton *)globalLocationButton{
    if(globalLocationButton.isSelected){
        return;
    }
    
    globalLocationButton.selected = YES;
    _selfLocationButton.selected = NO;
    if([self.delegate respondsToSelector:@selector(motorcadeMapToolbarDidGlobalLocationAction:)]){
        [self.delegate motorcadeMapToolbarDidGlobalLocationAction:self];
    }
}

- (void)handleActionForSelfLocationButton:(CXActionItemButton *)selfLocationButton{
    if(selfLocationButton.isSelected){
        return;
    }
    
    selfLocationButton.selected = YES;
    _globalLocationButton.selected = NO;
    if([self.delegate respondsToSelector:@selector(motorcadeMapToolbarDidSelfLocationAction:)]){
        [self.delegate motorcadeMapToolbarDidSelfLocationAction:self];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat trafficButton_X = 0;
    CGFloat trafficButton_Y = 0;
    CGFloat trafficButton_H = 46.0;
    CGFloat trafficButton_W = 60.0;
    _trafficButton.frame = (CGRect){trafficButton_X, trafficButton_Y, trafficButton_W, trafficButton_H};
    
    CGFloat globalLocationButton_X = trafficButton_X;
    CGFloat globalLocationButton_Y = CGRectGetMaxY(_trafficButton.frame) + 15.0;
    CGFloat globalLocationButton_H = trafficButton_H;
    CGFloat globalLocationButton_W = trafficButton_W;
    _globalLocationButton.frame = (CGRect){globalLocationButton_X, globalLocationButton_Y, globalLocationButton_W, globalLocationButton_H};
    
    CGFloat selfLocationButton_X = 0;
    CGFloat selfLocationButton_Y = CGRectGetMaxY(_globalLocationButton.frame) + 15.0;
    CGFloat selfLocationButton_H = globalLocationButton_H;
    CGFloat selfLocationButton_W = globalLocationButton_W;
    _selfLocationButton.frame = (CGRect){selfLocationButton_X, selfLocationButton_Y, selfLocationButton_W, selfLocationButton_H};
}

@end
