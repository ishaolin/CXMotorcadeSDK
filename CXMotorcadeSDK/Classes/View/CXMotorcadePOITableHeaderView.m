//
//  CXMotorcadePOITableHeaderView.m
//  Pods
//
//  Created by wshaolin on 2019/4/15.
//

#import "CXMotorcadePOITableHeaderView.h"
#import <CXUIKit/CXUIKit.h>
#import "CXMotorcadeDefines.h"

@interface CXMotorcadePOITableHeaderView () {
    UIButton *_itemView1;
    UIButton *_itemView2;
    
    UIView *_vLineView;
    UIView *_hLineView;
}

@end

@implementation CXMotorcadePOITableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = CXHexIColor(0xFFFFFF);
        
        _itemView1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemView1.titleLabel.font = CX_PingFangSC_RegularFont(13.0);
        [_itemView1 setImage:CX_MOTORCADE_IMAGE(@"motorcade_poi_drag_point") forState:UIControlStateNormal];
        [_itemView1 setTitle:@"地图选点" forState:UIControlStateNormal];
        [_itemView1 setTitleColor:CXHexIColor(0x333333) forState:UIControlStateNormal];
        _itemView1.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, 0);
        [_itemView1 cx_setBackgroundColor:[CXTableViewCell highlightedColour] forState:UIControlStateHighlighted];
        [_itemView1 addTarget:self action:@selector(handleActionForItemView:) forControlEvents:UIControlEventTouchUpInside];
        
        _itemView2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemView2.titleLabel.font = CX_PingFangSC_RegularFont(13.0);
        [_itemView2 setImage:CX_MOTORCADE_IMAGE(@"motorcade_poi_current_location") forState:UIControlStateNormal];
        [_itemView2 setTitle:@"当前位置" forState:UIControlStateNormal];
        [_itemView2 setTitleColor:CXHexIColor(0x333333) forState:UIControlStateNormal];
        _itemView2.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, 0);
        [_itemView2 cx_setBackgroundColor:[CXTableViewCell highlightedColour] forState:UIControlStateHighlighted];
        [_itemView2 addTarget:self action:@selector(handleActionForItemView:) forControlEvents:UIControlEventTouchUpInside];
        
        _vLineView = [[UIView alloc] init];
        _vLineView.backgroundColor = CXHexIColor(0xECECEC);
        
        _hLineView = [[UIView alloc] init];
        _hLineView.backgroundColor = CXHexIColor(0xECECEC);
        
        [self addSubview:_itemView1];
        [self addSubview:_itemView2];
        [self addSubview:_vLineView];
        [self addSubview:_hLineView];
    }
    
    return self;
}

- (void)handleActionForItemView:(UIButton *)itemView{
    if(itemView == _itemView1){
        if([self.delegate respondsToSelector:@selector(POITableHeaderViewDidDragSelectionAction:)]){
            [self.delegate POITableHeaderViewDidDragSelectionAction:self];
        }
    }else{
        if([self.delegate respondsToSelector:@selector(POITableHeaderViewDidCurrentLocationAction:)]){
            [self.delegate POITableHeaderViewDidCurrentLocationAction:self];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat vLineView_W = 0.5;
    CGFloat vLineView_H = 40.0;
    CGFloat vLineView_X = (self.bounds.size.width - vLineView_W) * 0.5;
    CGFloat vLineView_Y = (CGRectGetHeight(self.bounds) - vLineView_H) * 0.5;
    _vLineView.frame = (CGRect){vLineView_X, vLineView_Y, vLineView_W, vLineView_H};
    
    CGFloat hLineView_X = 0;
    CGFloat hLineView_H = vLineView_W;
    CGFloat hLineView_Y = self.bounds.size.height - hLineView_H;
    CGFloat hLineView_W = self.bounds.size.width;
    _hLineView.frame = (CGRect){hLineView_X, hLineView_Y, hLineView_W, hLineView_H};
    
    CGFloat itemView1_X = 0;
    CGFloat itemView1_Y = 0;
    CGFloat itemView1_W = vLineView_X;
    CGFloat itemView1_H = CGRectGetHeight(self.bounds);
    _itemView1.frame = (CGRect){itemView1_X, itemView1_Y, itemView1_W, itemView1_H};
    
    CGFloat itemView2_X = CGRectGetMaxX(_vLineView.frame);
    CGFloat itemView2_Y = itemView1_Y;
    CGFloat itemView2_W = itemView1_W;
    CGFloat itemView2_H = itemView1_H;
    _itemView2.frame = (CGRect){itemView2_X, itemView2_Y, itemView2_W, itemView2_H};
}

@end
