//
//  SKSplashView.h
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class SKSplashIcon;
@class SKSplashView;

@protocol SKSplashDelegate <NSObject>
@optional
- (void) splashView: (SKSplashView *) splashView didBeginAnimatingWithDuration: (float) duration;
- (void) splashViewDidEndAnimating: (SKSplashView *) splashView;
@end

typedef NS_ENUM(NSInteger, SKSplashAnimationType)
{
    SKSplashAnimationTypeFade =0,
    SKSplashAnimationTypeBounce,
    SKSplashAnimationTypeShrink,
    SKSplashAnimationTypeZoom,
    SKSplashAnimationTypeNone,
    SKSplashAnimationTypeCustom
};

@interface SKSplashView : UIView

@property (strong, nonatomic) UIColor *backgroundViewColor; //Default: white
@property (strong, nonatomic) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat animationDuration; //Default: 1s

@property (weak, nonatomic) id <SKSplashDelegate> delegate;

//Init splash view
- (instancetype)initWithAnimationType: (SKSplashAnimationType) animationType;
- (instancetype)initWithBackgroundColor: (UIColor *) backgroundColor animationType: (SKSplashAnimationType) animationType;
- (instancetype)initWithBackgroundImage: (UIImage *) backgroundImage animationType: (SKSplashAnimationType) animationType;
- (instancetype)initWithSplashIcon: (SKSplashIcon *)icon animationType: (SKSplashAnimationType) animationType;
- (instancetype) initWithSplashIcon:(SKSplashIcon *)icon backgroundColor: (UIColor *) backgroundColor animationType:(SKSplashAnimationType) animationType;
- (instancetype) initWithSplashIcon:(SKSplashIcon *)icon backgroundImage:(UIImage *) backgroundImage animationType:(SKSplashAnimationType) animationType;

- (void) setCustomAnimationType: (CAAnimation *) animation;

//Start animation
- (void)startAnimation;
- (void)startAnimationWithCompletion:(void(^)())completionHandler; //start animation with completion
- (void)startAnimationWhileExecuting: (NSURLRequest *) request withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) completion; //NOTE: Splash View returns regardless of whether request was success -> error handling highly recommended

@end