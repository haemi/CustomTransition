//
//  Copyright © 2016 arkulpa. All rights reserved. 
//

#import "MenuTransition.h"
#import "MenuInteractiveTransition.h"

@interface MenuTransition () <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) NSLayoutConstraint *menuLeadingConstraint;

@end

@implementation MenuTransition

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _interactiveTransition = [[MenuInteractiveTransition alloc] initWithAnimatedTransition:self];
    }
    
    return self;
}

- (void)animationEnded:(BOOL)transitionCompleted {
    // Reset to default values
    self.interactive = NO;
    self.presenting = NO;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"animatetransition");
    
    if (self.presenting) {
        [self prepareForPresentation:transitionContext];
    }
    
    [self animateMenu:transitionContext show:self.presenting];
}

- (void)prepareForPresentation:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    
    // setup menu
    UIView *menu = [transitionContext viewForKey:UITransitionContextToViewKey];
    menu.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:menu];
    
    CGFloat menuWidth = 300;
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:menu attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:menuWidth];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:menu attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:menu.superview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
    self.menuLeadingConstraint = [NSLayoutConstraint constraintWithItem:menu attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:menu.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-menuWidth];
    
    NSArray *constraints = @[widthConstraint, heightConstraint, self.menuLeadingConstraint];
    [NSLayoutConstraint activateConstraints:constraints];
    
    [menu.superview layoutIfNeeded];
}

- (void)animateMenu:(id <UIViewControllerContextTransitioning>)transitionContext show:(BOOL)show {
    BOOL useToView = show;
    
    if (transitionContext.transitionWasCancelled) {
        useToView = !useToView;
    }
    
    NSString *viewKey = useToView ? UITransitionContextToViewKey : UITransitionContextFromViewKey;
    UIView *menu = [transitionContext viewForKey:viewKey];
    
    NSAssert(menu != nil, @"no menu given");
    
    CGFloat offset = show ? 0 : -menu.frame.size.width;
    self.menuLeadingConstraint.constant = offset;
    
    CGFloat duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [menu.superview layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         BOOL transitionDidComplete = !transitionContext.transitionWasCancelled;
                         [transitionContext completeTransition:transitionDidComplete];
                         
                         BOOL menuIsCurrentlyShowing = transitionDidComplete ? show : !show;
                         
                         if (!menuIsCurrentlyShowing) {
                             self.menuLeadingConstraint = nil;
                             [menu removeFromSuperview];
                         } else {
                             self.menuLeadingConstraint.constant = 0;
                         }
                     }];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interactive ? self.interactiveTransition : nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interactive ? self.interactiveTransition : nil;
}

- (void)dealloc {
    NSLog(@"dealloc menutransition");
}

@end
