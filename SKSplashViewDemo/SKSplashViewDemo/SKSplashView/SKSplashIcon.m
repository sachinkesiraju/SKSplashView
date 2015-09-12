//
//  SKSplashIcon.m
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "SKSplashIcon.h"

@interface SKSplashIcon()

@property (nonatomic, assign) SKIconAnimationType animationType;
@property (strong, nonatomic) CAAnimation *customAnimation;
@property (nonatomic) CGFloat animationDuration;
@property (strong, nonatomic) UIImage *iconImage;

@end

@implementation SKSplashIcon

#pragma mark - Initialization

- (instancetype) initWithImage:(UIImage *)iconImage
{
    self = [super init];
    if(self)
    {
        self.image = iconImage;
        self.tintColor = [self setIconStartColor];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.frame = CGRectMake(0, 0, [self setIconStartSize].width, [self setIconStartSize].height);
        [self addObserverForAnimationNotification];
    }
    
    return self;
}

- (instancetype) initWithImage:(UIImage *)iconImage animationType:(SKIconAnimationType)animationType
{
    self = [super init];
    if(self)
    {
        _animationType = animationType;
        _iconImage = iconImage;
        self.image = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.image = iconImage;
        self.tintColor = [self setIconStartColor];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.frame = CGRectMake(0, 0, [self setIconStartSize].width, [self setIconStartSize].height);
        [self addObserverForAnimationNotification];
    }
    
    return self;
}

#pragma mark - Public methods

- (void) setIconAnimationType:(SKIconAnimationType)animationType
{
 
    _animationType = animationType;
}

- (void) setCustomAnimation:(CAAnimation *)animation
{
    _customAnimation = animation;
}

#pragma mark - Property setters

- (CGSize)setIconStartSize
{
    if (!_iconSize.height) {
        _iconSize = CGSizeMake(60, 60);
    }
    return _iconSize;
}

- (UIColor *)setIconStartColor
{
    if (!_iconColor) {
        _iconColor = [UIColor whiteColor];
    }
    return _iconColor;
}

#pragma mark - Implementation

- (void) addObserverForAnimationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"startAnimation" object:nil];
}

- (void) receiveNotification: (NSNotification *) notification
{
    if(notification.userInfo [@"animationDuration"])
    {
        double duration = [notification.userInfo [@"animationDuration"] doubleValue];
        self.animationDuration = duration;
    }
    [self startAnimation];
}

- (void) startAnimation
{
    switch (_animationType)
    {
        case SKIconAnimationTypeBounce:
            [self addBounceAnimation];
            break;
        case SKIconAnimationTypeFade:
            [self addFadeAnimation];
            break;
        case SKIconAnimationTypeGrow:
            [self addGrowAnimation];
            break;
        case SKIconAnimationTypeShrink:
            [self addShrinkAnimation];
            break;
        case SKIconAnimationTypePing:
            [self addPingAnimation];
            break;
        case SKIconAnimationTypeBlink:
            [self addBlinkAnimation];
            break;
        case SKIconAnimationTypeNone:
            [self addNoAnimation];
            break;
        case SKIconAnimationTypeCustom:
            if(_customAnimation)
            {
                [self addCustomAnimation:_customAnimation];
            }
            else
            {
                [self addCustomAnimation:[self customAnimation]];
            }
            break;
        default:NSLog(@"No animation type selected");
            break;
    }
}

- (void) addBounceAnimation
{
    CGFloat shrinkDuration = self.animationDuration * 0.3;
    CGFloat growDuration = self.animationDuration * 0.7;
    
    [UIView animateWithDuration:shrinkDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.75, 0.75);
        self.transform = scaleTransform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:growDuration animations:^{
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
            self.transform = scaleTransform;
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

- (void) addFadeAnimation
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.image = _iconImage;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) addGrowAnimation
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
        self.transform = scaleTransform;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) addShrinkAnimation
{
    [UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.75, 0.75);
        self.transform = scaleTransform;
    } completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

- (void) addPingAnimation
{
    [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeAnimations) userInfo:nil repeats:YES];
    [UIView animateWithDuration:1.5 delay:0 options:(UIViewAnimationOptionRepeat) animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.75, 0.75);
        self.transform = scaleTransform;
    }completion:^(BOOL finished)
     {
         [UIView animateWithDuration:1.5 animations:^{
             CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
             self.transform = scaleTransform;
         }];
     }];
}

- (void) addBlinkAnimation
{
    self.alpha = 0;
    [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeAnimations) userInfo:nil repeats:YES];
    [UIView animateWithDuration:1.5 delay:0 options:(UIViewAnimationOptionRepeat) animations:^{
        self.alpha = 1;
    }completion:^(BOOL finished)
     {
         [UIView animateWithDuration:1.5 animations:^{
             self.alpha = 0;
         }];
     }];
}

- (void) removeAnimations
{
    [self.layer removeAllAnimations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
}

- (void) addNoAnimation
{
    [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeAnimations) userInfo:nil repeats:YES];
}

- (void) addCustomAnimation: (CAAnimation *) animation
{
    [self.layer addAnimation:animation forKey:@"SKSplashAnimation"];
    [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeAnimations) userInfo:nil repeats:YES];
}

@end
