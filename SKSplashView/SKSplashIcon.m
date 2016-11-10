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
@property (nonatomic, assign, readonly) CGFloat animationDuration;
@property (nonatomic) BOOL shouldAnimateIndefinitely;

@end

@implementation SKSplashIcon

@dynamic animationDuration;

#pragma mark - Initialization

- (instancetype) initWithImage:(UIImage *)iconImage
{
    self = [super init];
    if(self) {
        self.image = iconImage;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _iconSize = CGSizeMake(60, 60);
        self.frame = CGRectMake(0, 0, _iconSize.width, _iconSize.height);
    }
    return self;
}

- (instancetype) initWithImage:(UIImage *)iconImage animationType:(SKIconAnimationType)animationType
{
    self = [self initWithImage:iconImage];
    if(self) {
        _animationType = animationType;
    }
    return self;
}

#pragma mark - Setters

- (void) setIconSize:(CGSize)iconSize
{
    [self setFrame:CGRectMake(0, 0, iconSize.width, iconSize.height)];
}

#pragma mark - Implementation

- (void) splashIconAnimateWithDuration:(CGFloat)animationDuration indefinitely:(BOOL)shouldAnimateIndefinitely
{
    self.animationDuration = animationDuration;
    [self startAnimation];
    if (shouldAnimateIndefinitely) {
        self.shouldAnimateIndefinitely = shouldAnimateIndefinitely;
    }
}

- (void) splashIconStopAnimating
{
    self.shouldAnimateIndefinitely = NO;
    [self removeAnimations];
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
        default:NSLog(@"No animation type selected");
            break;
    }
}

#pragma mark - Animations

- (void) addBounceAnimation
{
    CGFloat delay = 1.2;
    CGFloat shrinkDuration = (self.animationDuration - delay) * 0.3;
    CGFloat growDuration = (self.animationDuration - delay) - shrinkDuration;
    
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
    
    if (_shouldAnimateIndefinitely) {
        [self performSelectorOnMainThread:@selector(addPingAnimation) withObject:self waitUntilDone:NO];
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
    
    if (_shouldAnimateIndefinitely) {
        [self performSelectorOnMainThread:@selector(addBlinkAnimation) withObject:self waitUntilDone:NO];
    }
}

- (void) removeAnimations
{
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (void) addNoAnimation
{
    [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(removeAnimations) userInfo:nil repeats:YES];
}

@end
