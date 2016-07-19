//
//  Copyright © 2016 arkulpa. All rights reserved. 
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.viewController action:@selector(didPan:)];
    [self.view addGestureRecognizer:panRecognizer];
}

@end
