//
//  ViewController.m
//  InteractiveAnimations
//
//  Copyright © 2016 arkulpa. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"
#import "MenuTransition.h"
#import "MenuInteractiveTransition.h"

@interface ViewController ()

@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) MenuTransition *menuTransition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    recognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:recognizer];
    
    self.menuTransition = [[MenuTransition alloc] init];
}

- (void)showNavigation {
    self.menuTransition.presenting = YES;
    self.menuViewController = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
    self.menuViewController.modalPresentationStyle = UIModalPresentationCustom;
    self.menuViewController.viewController = self;
    self.menuViewController.menuTransition = self.menuTransition;
    self.menuViewController.transitioningDelegate = self.menuTransition;
    
    [self presentViewController:self.menuViewController animated:YES completion:nil];
}

- (void)hideNavigation {
    self.menuTransition.presenting = NO;
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.menuViewController = nil;
    }];
}

- (void)didPan:(UIPanGestureRecognizer *)recognizer {
    CGPoint location;
    
    BOOL isOpeningGesture = [recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
    
    if (isOpeningGesture) {
        location = [recognizer translationInView:recognizer.view];
    } else {
        location = [recognizer locationInView:recognizer.view.superview];
    }
    
    static CGFloat initialPosition = 0;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.menuTransition.interactive = YES;
            
            initialPosition = location.x;
            
            BOOL canPresent = !self.menuTransition.isMenuVisible;
            
            if (canPresent) {
                canPresent = location.x < CGRectGetMidX(recognizer.view.bounds);
            }
            
            self.menuTransition.presenting = canPresent;
            
            if (isOpeningGesture) {
                [self showNavigation];
            } else {
                [self hideNavigation];
            }
            
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGFloat width = recognizer.view.bounds.size.width;
            // normalize progress
            CGFloat menuWidth = 300;
            
            CGFloat progress;
            
            CGFloat totalWidth = self.view.bounds.size.width;
            CGFloat maxProgress = menuWidth / totalWidth;
            
            if (isOpeningGesture) {
                progress = location.x / width;
            } else {
                CGFloat pannedPixelDistance = MAX(0, initialPosition - location.x);
                CGFloat currentMenuWidth = menuWidth - pannedPixelDistance;
                
                progress = currentMenuWidth / totalWidth;
            }
            
            if (progress < maxProgress) {
                progress = MAX(0, progress);
                progress = progress / maxProgress;
            } else {
                progress = 1;
            }
            
            progress = isOpeningGesture ? progress : 1 - progress;
            
            [self.menuTransition.interactiveTransition updateInteractiveTransition:progress];
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"ended");
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            
            // the transition has to be cancelled if we were presenting (i.e. showing the menu) but the pan ended with a negative speed (right to left) or the other way around
            BOOL cancel = (velocity.x < 0 && self.menuTransition.presenting) || (velocity.x > 0 && !self.menuTransition.presenting);
            
            if (cancel) {
                [self.menuTransition.interactiveTransition cancelInteractiveTransition];
            } else {
                [self.menuTransition.interactiveTransition finishInteractiveTransition];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)dealloc {
    NSLog(@"==");
}

@end
