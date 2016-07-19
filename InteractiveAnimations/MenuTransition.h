//
//  Copyright © 2016 arkulpa. All rights reserved. 
//

#import <UIKit/UIKit.h>
@class MenuInteractiveTransition;

@interface MenuTransition : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) BOOL isMenuVisible;
@property (nonatomic, strong) MenuInteractiveTransition *interactiveTransition;

@end
