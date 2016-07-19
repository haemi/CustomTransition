//
//  Copyright © 2016 arkulpa. All rights reserved. 
//

#import "MenuInteractiveTransition.h"
#import "MenuTransition.h"

@interface MenuInteractiveTransition()

@property (nonatomic, strong) MenuTransition *menuTransition;

@end

@implementation MenuInteractiveTransition

- (instancetype)initWithAnimatedTransition:(MenuTransition *)menuTransition {
    self = [super init];
    
    if (self) {
        _menuTransition = menuTransition;
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc menuinteractivetransition");
}

@end
