//
//  ViewController.m
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "ViewController.h"
#import "SKSplashIcon.h"

@interface ViewController ()

@property (strong, nonatomic) SKSplashView *splashView;

//Demo of how to add other UI elements on top of splash view
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    //Call the splash view example method to view the demo
    [self twitterSplash];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Load Example

- (void) customLoadSplash
{
    //Adding splash view
    UIColor *customColor = [UIColor colorWithRed:168.0f/255.0f green:36.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    _splashView = [[SKSplashView alloc] initWithBackgroundColor:customColor animationType:SKSplashAnimationTypeZoom];
    _splashView.animationDuration = 3.0f;
    _splashView.delegate = self;
    //Adding activity indicator view on splash view
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorView.frame = self.view.frame;
    [self.view addSubview:_splashView];
    [self.view addSubview:_indicatorView];
    [_splashView startAnimation];
}

#pragma mark - Twitter Example

- (void) twitterSplash
{
    //Setting the background
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"twitter background.png"];
    [self.view addSubview:imageView];
    //Twitter style splash
    SKSplashIcon *twitterSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"twitterIcon.png"] animationType:SKIconAnimationTypeBounce];
    UIColor *twitterColor = [UIColor colorWithRed:0.25098 green:0.6 blue:1.0 alpha:1.0];
    _splashView = [[SKSplashView alloc] initWithSplashIcon:twitterSplashIcon backgroundColor:twitterColor animationType:SKSplashAnimationTypeNone];
    _splashView.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
    _splashView.animationDuration = 2; //Optional -> set animation duration. Default: 1s
    [self.view addSubview:_splashView];
    [_splashView startAnimation];
}

#pragma mark - Snapchat Example

- (void) snapchatSplash
{
    //Snapchat style splash
    SKSplashIcon *snapchatSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"snapchat icon.png"] animationType:SKIconAnimationTypeNone];
    UIColor *snapchatColor = [UIColor colorWithRed:255 green:252 blue:0 alpha:1];
    _splashView = [[SKSplashView alloc] initWithSplashIcon:snapchatSplashIcon backgroundColor:snapchatColor animationType:SKSplashAnimationTypeFade];
    _splashView.animationDuration = 3.0f;
    [self.view addSubview:_splashView];
    [_splashView startAnimation];
}

#pragma mark - Ping Example

- (void) pingSplash
{
    //Setting the background
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"ping background.png"];
    [self.view addSubview:imageView];
    //Ping style splash
    SKSplashIcon *pingSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"ping.png"] animationType:SKIconAnimationTypePing];
    _splashView = [[SKSplashView alloc] initWithSplashIcon:pingSplashIcon backgroundColor:[UIColor whiteColor] animationType:SKSplashAnimationTypeBounce];
    _splashView.animationDuration = 5.0f;
    [self.view addSubview:_splashView];
    [_splashView startAnimation];
}

#pragma mark - Animation Examples

- (void) fadeExampleSplash
{
    SKSplashIcon *splashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"white dot.png"] animationType:SKIconAnimationTypeBlink];
    _splashView = [[SKSplashView alloc] initWithSplashIcon:splashIcon backgroundColor:[UIColor blackColor] animationType:SKSplashAnimationTypeFade];
    _splashView.animationDuration = 5;
    [self.view addSubview:_splashView];
    [_splashView startAnimation];
}

#pragma mark - Delegate methods

- (void) splashView:(SKSplashView *)splashView didBeginAnimatingWithDuration:(float)duration
{
    NSLog(@"Started animating from delegate");
    //To start activity animation when splash animation starts
    [_indicatorView startAnimating];
}

- (void) splashViewDidEndAnimating:(SKSplashView *)splashView
{
    NSLog(@"Stopped animating from delegate");
    //To stop activity animation when splash animation ends
    [_indicatorView stopAnimating];
}

@end
