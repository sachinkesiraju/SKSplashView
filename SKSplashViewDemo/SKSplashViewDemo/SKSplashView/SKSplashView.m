//
//  SKSplashView.m
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "SKSplashView.h"
#import "SKSplashIcon.h"

@interface SKSplashView()

@property (nonatomic, assign) SKSplashAnimationType animationType;
@property (nonatomic, assign) SKSplashIcon *splashIcon;
@property (strong, nonatomic) CAAnimation *customAnimation;

@end

@implementation SKSplashView

#pragma mark - Init

- (instancetype)initWithAnimationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self) {
        _animationType = animationType;
    }
    return self;
}

- (instancetype) initWithSplashIcon:(SKSplashIcon *)icon animationType:(SKSplashAnimationType)animationType
{
    self = [self initWithAnimationType:animationType];
    if(self) {
        _splashIcon = icon;
        icon.center = self.center;
        [self addSubview:icon];
    }
    return self;
}

#pragma mark - Public methods

- (void)startAnimation;
{
    if(_splashIcon) {
        [_splashIcon splashIconAnimateWithDuration:self.animationDuration indefinitely:NO];
    }
    
    if([self.delegate respondsToSelector:@selector(splashView:didBeginAnimatingWithDuration:)]) {
        [self.delegate splashView:self didBeginAnimatingWithDuration:self.animationDuration];
    }
    
    switch(_animationType)
    {
        case SKSplashAnimationTypeBounce:
            [self addBounceAnimation];
            break;
        case SKSplashAnimationTypeFade:
            [self addFadeAnimation];
            break;
        case SKSplashAnimationTypeZoom:
            [self addZoomAnimation];
            break;
        case SKSplashAnimationTypeShrink:
            [self addShrinkAnimation];
            break;
        case SKSplashAnimationTypeNone:
            [self addNoAnimation];
            break;
        default: NSLog(@"No animation type selected");
            break;
    }
}

- (void) startAnimationWhileExecuting:(NSURLRequest *)request withCompletion:(void (^)(NSData *, NSURLResponse *, NSError *))completion
{
    [self startAnimation];
    if(_splashIcon) { //trigger splash icon animation
        [_splashIcon splashIconAnimateWithDuration:0 indefinitely:YES];
    }
    
    if([self.delegate respondsToSelector:@selector(splashView:didBeginAnimatingWithDuration:)]) {
        [self.delegate splashView:self didBeginAnimatingWithDuration:self.animationDuration];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [self removeSplashView];
         completion(data, response, error);
     }];
}

#pragma mark - Property setters

- (void) setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    imageView.frame = [UIScreen mainScreen].bounds;
    [self addSubview:imageView];
}

- (CGFloat)animationDuration
{
    if (!_animationDuration) {
        _animationDuration = 1.0f;
    }
    return _animationDuration;
}

#pragma mark - Animations

- (void) addBounceAnimation
{
    CGFloat bounceDuration = self.animationDuration * 0.8;
    [NSTimer scheduledTimerWithTimeInterval:bounceDuration target:self selector:@selector(pingGrowAnimation) userInfo:nil repeats:NO];
}

- (void) pingGrowAnimation
{
    CGFloat growDuration = self.animationDuration *0.2;
    [UIView animateWithDuration:growDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
        self.transform = scaleTransform;
        self.alpha = 0;
        self.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        [self removeSplashView];
    }];
}

- (void) growAnimation
{
    CGFloat growDuration = self.animationDuration * 0.7;
    [UIView animateWithDuration:growDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
        self.transform = scaleTransform;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeSplashView];
    }];
}

- (void) addFadeAnimation
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeSplashView];
    }];

}

- (void) addShrinkAnimation
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.5, 0.5);
        self.transform = scaleTransform;
        self.alpha = 0;
    }completion:^(BOOL finished)
     {
         [self removeSplashView];
     }];
}

- (void) addZoomAnimation
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(10, 10);
        self.transform = scaleTransform;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeSplashView];
    }];
}

- (void) addNoAnimation
{
    [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeSplashView) userInfo:nil repeats:NO];
}

- (void) removeSplashView
{
    [self removeFromSuperview];
    if (_splashIcon) {
        [_splashIcon splashIconStopAnimating];
    }
    
    if([self.delegate respondsToSelector:@selector(splashViewDidEndAnimating:)]) {
        [self.delegate splashViewDidEndAnimating:self];
    }
}

@end
