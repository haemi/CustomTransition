//
//  Copyright © 2016 arkulpa. All rights reserved. 
//

#import <UIKit/UIKit.h>
@class MenuTransition;
@class ViewController;

@interface MenuViewController : UIViewController

@property (nonatomic, strong) MenuTransition *menuTransition;
@property (nonatomic, weak) ViewController *viewController;

@end
