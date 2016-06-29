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
    if(self)
    {
        _animationType = animationType;
    }
    
    return self;
}

- (instancetype) initWithBackgroundColor:(UIColor *)backgroundColor animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _backgroundViewColor = backgroundColor;
        self.backgroundColor = _backgroundViewColor;
        _animationType = animationType;
    }
    
    return self;
}

- (instancetype) initWithBackgroundImage:(UIImage *)backgroundImage animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _backgroundImage = backgroundImage;
        _animationType = animationType;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
    }
    
    return self;
}

- (instancetype) initWithSplashIcon:(SKSplashIcon *)icon animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _splashIcon = icon;
        _animationType = animationType;
        self.backgroundColor = _backgroundViewColor;
        icon.center = self.center;
        [self addSubview:icon];
    }
    
    return self;
}

- (instancetype) initWithSplashIcon:(SKSplashIcon *)icon backgroundColor:(UIColor *)backgroundColor animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _splashIcon = icon;
        _backgroundViewColor = backgroundColor;
        _animationType = animationType;
        icon.center = self.center;
        self.backgroundColor = _backgroundViewColor;
        [self addSubview:icon];
    }
    return self;
}

- (instancetype) initWithSplashIcon:(SKSplashIcon *)icon backgroundImage:(UIImage *)backgroundImage animationType:(SKSplashAnimationType)animationType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _splashIcon = icon;
        _backgroundImage = backgroundImage;
        _animationType = animationType;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        [self addSubview:icon];
        icon.center = imageView.center;
    }
    return self;
}

#pragma mark - Public methods

- (void)startAnimation;
{
    [self startAnimationWithCompletion:nil];
}

- (void)startAnimationWithCompletion:(void(^)())completionHandler
{
    if(_splashIcon) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",self.animationDuration] forKey:@"animationDuration"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startAnimation" object:self userInfo:dic];
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
        case SKSplashAnimationTypeCustom:
            [self addCustomAnimationWithAnimation:_customAnimation];
            break;
        default:NSLog(@"No animation type selected");
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"stopAnimation" object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif)
    {
        if(completionHandler) {
            completionHandler();
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

- (void) startAnimationWhileExecuting:(NSURLRequest *)request withCompletion:(void (^)(NSData *, NSURLResponse *, NSError *))completion
{
    if(_splashIcon) { //trigger splash icon animation
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startAnimation" object:self userInfo:nil];
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

- (void) setCustomAnimationType:(CAAnimation *)animation
{
    _customAnimation = animation;
}

- (void) setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    imageView.frame = [UIScreen mainScreen].bounds;
    [self addSubview:imageView];
}

#pragma mark - Property setters

- (CGFloat)animationDuration
{
    if (!_animationDuration) {
        _animationDuration = 1.0f;
    }
    return _animationDuration;
}

- (CAAnimation *)customAnimation
{
    if (!_customAnimation) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@1, @0.9, @300];
        animation.keyTimes = @[@0, @0.4, @1];
        animation.duration = self.animationDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        _customAnimation = animation;
    }
    return _customAnimation;
}

- (UIColor *) backgroundViewColor
{
    if (!_backgroundViewColor) {
        _backgroundViewColor = [UIColor whiteColor];
    }
    return _backgroundViewColor;
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

- (void) addCustomAnimationWithAnimation: (CAAnimation *) animation
{
    [self.layer addAnimation:animation forKey:@"SKSplashAnimation"];
    [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeSplashView) userInfo:nil repeats:YES];
}

- (void) removeSplashView
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopAnimation" object:self userInfo:nil];
    if([self.delegate respondsToSelector:@selector(splashViewDidEndAnimating:)]) {
        [self.delegate splashViewDidEndAnimating:self];
    }
}

@end
