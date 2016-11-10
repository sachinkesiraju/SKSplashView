//
//  SKSplashIcon.h
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSplashView.h"

typedef NS_ENUM(NSInteger, SKIconAnimationType)
{
    SKIconAnimationTypeBounce,
    SKIconAnimationTypeGrow,
    SKIconAnimationTypeShrink,
    SKIconAnimationTypeFade,
    SKIconAnimationTypePing, //supports network dependent animation
    SKIconAnimationTypeBlink, //supports network dependent animation
    SKIconAnimationTypeNone
};

@interface SKSplashIcon : UIImageView <SKSplashDelegate>

@property (strong, nonatomic) UIColor *iconColor; //Default: white
@property (nonatomic, assign) CGSize iconSize; //Default: 60x60

- (instancetype) initWithImage: (UIImage *) iconImage;
- (instancetype) initWithImage: (UIImage *) iconImage animationType: (SKIconAnimationType) animationType;

- (void) splashIconAnimateWithDuration:(CGFloat) animationDuration indefinitely:(BOOL) shouldAnimateIndefinitely;
- (void) splashIconStopAnimating;

@end
