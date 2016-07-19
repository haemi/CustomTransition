//
//  Copyright © 2016 arkulpa. All rights reserved. 
//

#import <UIKit/UIKit.h>
@class MenuTransition;

@interface MenuInteractiveTransition : UIPercentDrivenInteractiveTransition

- (instancetype)initWithAnimatedTransition:(MenuTransition *)menuTransition;

@end
