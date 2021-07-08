//
//  CXIMSpeakDragView.h
//  Pods
//
//  Created by wshaolin on 2019/4/10.
//

#import <CXUIKit/CXUIKit.h>

@class CXIMSpeakDragView;

@protocol CXIMSpeakDragViewDelegate <NSObject>

@optional

- (void)IMSpeakDragView:(CXIMSpeakDragView *)dragView didDragActionForState:(UIGestureRecognizerState)state;
- (void)IMSpeakDragView:(CXIMSpeakDragView *)dragView didLongPressActionForState:(UIGestureRecognizerState)state;

@end

@interface CXIMSpeakDragView : UIView

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, weak) id<CXIMSpeakDragViewDelegate> delegate;

- (void)resetting;

@end

@interface CXIMSpeakAnimationView : CXBaseActionPanel

@property (nonatomic, assign) CGFloat speakPower;

@end
