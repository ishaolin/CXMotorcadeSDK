//
//  CXRoundShadowActionButton.h
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import <CXUIKit/CXUIKit.h>

@interface CXRoundShadowActionButton : UIView

@property (nonatomic, assign, getter = isEnabled) BOOL enabled; // 默认YES
@property (nonatomic, copy) NSString *title;

- (void)addTarget:(id)target action:(SEL)action;

@end
