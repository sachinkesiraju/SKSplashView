SKSplashView
============

SKSplashView is a simple class to create beautiful animated splash views for transitioning between views. Perfect as a launch 
screen while your app loads.

The splash view allows you to create an animated background view with preset animations with the option of adding a splash icon
that will animate as long as the splash view is animating.

 <img src = "https://github.com/sachinkesiraju/SKSplashView/blob/master/SKSplashViewDemo/Example%20GIFs/twitter.gif" width = "320px"> 

<h1> Installation </h1>
<h3> Cocoapods </h3>
SKSplashView is available through <a href = "cocoapods.org"> Cocoapods</a>. To install it, simply add the following to your Podfile.

```
pod 'SKSplashView'
```
<h3> Alternative </h3>
If installation through Cocoapods doesn't work or if you aren't comfortable using it, you can always just drag and drop the folder 'SKSplashView' into your project and `#import "SKSplashView.h"` and you're ready to go.

<h1> Implementation </h1>

<h2> SKSplashView </h2>
Simply create an instance of SKSplashView with the desired customizability option.

```
SKSplashView *splashView = [[SKSplashView alloc] initWithBackgroundColor:[UIColor blueColor] animationType:SKSplashAnimationTypeZoom];
// the splashView can be initialized with a variety of animation types and backgrounds. See customizability for more.
splashView.animationDuration = 3.0f; //Set the animation duration (Default: 1s)
[self.view addSubview:splashView]; //Add the splash view to your current view
[splashView startAnimation]; //Call this method to start the splash animation
```

<h4> Customizability </h4>
The appearance of the splash view can be customized with the following properties:

```
@property (strong, nonatomic) UIImage *backgroundImage; //Sets a background image to the splash view
@property (nonatomic, assign) CGFloat animationDuration; //Sets the duration of the splash view
```
The splash view also allows you to customize the animation transition of the splash view  with the following types:

```
SKSplashAnimationTypeFade,
SKSplashAnimationTypeBounce,
SKSplashAnimationTypeShrink,
SKSplashAnimationTypeZoom,
SKSplashAnimationTypeNone
```

<h2> SKSplashIcon </h2>

In addition to adding an animated splash view, you can also add an icon on your splash view with its own customizability options that will animate as long as the splash view is running.
To add a splash icon to your splash view:

1. `#import "SKSplashIcon.h"` in the view you are presenting the splash view

2. Initialize the splash icon as follows:

```
SKSplashIcon *splashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"test.png"] animationType:SKIconAnimationTypeNone]; 
//Initialize with the customizability option of your choice. See Customizability for more.
```
3. Add the splash icon when you are initializing your splash view

```
  SKSplashView *splashView = [SKSplashView alloc] initWithSplashIcon:splashIcon backgroundColor:splashColor animationType:SKSplashAnimationTypeFade];
```

<h4> Customizability </h4>

The appearance of the splash icon can be customized with the following properties:

```
@property (strong, nonatomic) UIColor *iconColor; //Sets the icon color of the icon (Default: white)
@property (nonatomic, assign) CGSize iconSize; //Sets the size of the icon (Default: 60x60)
```
The animation of the splash icon can also be customized with the following animation types:

```
SKIconAnimationTypeBounce,
SKIconAnimationTypeGrow,
SKIconAnimationTypeShrink,
SKIconAnimationTypeFade,
SKIconAnimationTypePing,
SKIconAnimationTypeBlink,
SKIconAnimationTypeNone
```

<h1> Delegate </h1> 
You can optionally add the SplashView delegate to your view controller to listen to when the splash view begins and ends animating.
To do this:

- Add `<SKSplashDelegate>` to your interface

- Set the delegate to your splash view `splashView.delegate = self;`

- Add the following methods to listen to updates

```
- (void) splashView:(SKSplashView *)splashView didBeginAnimatingWithDuration:(float)duration
{
  NSLog(@"Splash view started animating with duration %f", duration);
}

- (void) splashViewDidEndAnimating:(SKSplashView *)splashView
{
  NSLog(@"Splash view stopped animating");
}
```
<h1> Special Feature </h1>
SKSplashView also allows you to run a splash animation while executing a network request. This is ideal in situations where your app takes time during launch to download necessary data.
By simply calling:

```
[splashView startAnimationWhileExecuting:request withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {}];
```
with an initialized splash view, the splash animation will repeat until you've downloaded everything you need to get started!

<img src = "https://github.com/sachinkesiraju/SKSplashView/raw/master/SKSplashViewDemo/Example%20GIFs/uber.gif" width = "320px" height = "568"/>

<i> Note: This feature currently does not allow animation of the splash view itself but allows for certain splash icon animations. </i>

<h1> Example </h1> 

Some examples of splash views created using SKSplashView (Twitter iOS app and Ping iOS app). All code to the examples is available in the <a href = "https://github.com/sachinkesiraju/SKSplashView/tree/master/SKSplashViewDemo">Demo.</a>
If you found a way to mimic another popular iOS app's splash view using SKSplashView, let <a href = "https://twitter.com/_sachink"> me </a> know so I can add it here.

<img src = "https://github.com/sachinkesiraju/SKSplashView/raw/master/SKSplashViewDemo/Example%20GIFs/twitter.gif" width = "320px" height = "568"/> <img src="https://github.com/sachinkesiraju/SKSplashView/blob/master/SKSplashViewDemo/Example%20GIFs/ping.gif" width = "320px" height = "568"/> 

For more help getting started with SKSplashView, check out the <a href = "https://github.com/sachinkesiraju/SKSplashView/tree/master/SKSplashViewDemo">Demo</a>.

<h1> Community </h1>
If you feel you can improve or add more customizability to SKSplashView, feel free to raise an issue/submit a PR. For any questions, reach out to me on Twitter <a href = "https://twitter.com/_sachink">@_sachink</a>

<h1> License </h1>
SKSplashView is available under the MIT License
