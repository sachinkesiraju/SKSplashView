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
@property (nonatomic) BOOL indefiniteAnimation;
@property (strong, nonatomic) UIImage *iconImage;

@end

@implementation SKSplashIcon

@dynamic animationDuration;

#pragma mark - Initialization

- (instancetype) initWithImage:(UIImage *)iconImage
{
    self = [super init];
    if(self) {
        self.image = iconImage;
        self.tintColor = _iconColor;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.frame = CGRectMake(0, 0, iconImage.size.width, iconImage.size.height);
        [self addObserverForAnimationNotification];
    }
    
    return self;
}

- (instancetype) initWithImage:(UIImage *)iconImage animationType:(SKIconAnimationType)animationType
{
    self = [super init];
    if(self) {
        _animationType = animationType;
        _iconImage = iconImage;
        self.image = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.image = iconImage;
        self.tintColor = _iconColor;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.frame = CGRectMake(0, 0, iconImage.size.width, iconImage.size.height);
        [self addObserverForAnimationNotification];
    }
    
    return self;
}

- (void) setIconAnimationType:(SKIconAnimationType)animationType
{
    _animationType = animationType;
}

- (void) setCustomAnimation:(CAAnimation *)animation
{
    _customAnimation = animation;
}

- (void) setIconSize:(CGSize)iconSize
{
    self.frame = CGRectMake(0, 0, iconSize.width, iconSize.height);
}

- (UIColor *)iconColor
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"stopAnimation" object:nil];
}

- (void) receiveNotification: (NSNotification *) notification
{
    if([notification.name isEqualToString:@"startAnimation"]) { //if start animation, set duration if any
        if(notification.userInfo [@"animationDuration"]){
            double duration = [notification.userInfo [@"animationDuration"] doubleValue];
            self.animationDuration = duration;
            [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeAnimations) userInfo:nil repeats:YES];
        }
        else {
            self.indefiniteAnimation = YES;
        }
        [self startAnimation];
    }
    else if([notification.name isEqualToString:@"stopAnimation"]) {
        [self removeAnimations];
    }
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
            [self addCustomAnimation:_customAnimation];
            break;
        default:NSLog(@"No animation type selected");
            break;
    }
}

#pragma mark - Animations

- (void) addBounceAnimation
{
    CGFloat delay = 1.2;
    CGFloat shrinkDuration = (self.animationDuration - delay) * 0.3;
    CGFloat growDuration = (self.animationDuration - delay) * 0.7;
    
    [UIView animateWithDuration:shrinkDuration delay:delay usingSpringWithDamping:0.7f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
    
    if(self.indefiniteAnimation){ //keep running animation indefinitely
        [self performSelectorOnMainThread:@selector(addPingAnimation) withObject:nil waitUntilDone:NO];
    }
}

- (void) addBlinkAnimation
{
    self.alpha = 0;
    [UIView animateWithDuration:1.5 delay:0 options:(UIViewAnimationOptionRepeat) animations:^{
        self.alpha = 1;
    }completion:^(BOOL finished)
     {
         [UIView animateWithDuration:1.5 animations:^{
             self.alpha = 0;
         }];
     }];
    
    if(self.indefiniteAnimation){ //keep running animation indefinitely
        [self performSelectorOnMainThread:@selector(addBlinkAnimation) withObject:nil waitUntilDone:NO];
    }
}

- (void) removeAnimations
{
    [self.layer removeAllAnimations];
    self.indefiniteAnimation = NO;
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
