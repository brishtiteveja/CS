// Copyright (c) 2012, HTW Berlin / Project HardMut
// (http://www.hardmut-projekt.de)
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
// * Neither the name of the HTW Berlin / INKA Research Group nor the names
//   of its contributors may be used to endorse or promote products derived
//   from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  AppDelegate.m
//  iDiary2
//
//  Created by Markus Konrad on 27.04.11.
//  Copyright INKA Forschungsgruppe 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "Config.h"
#import "RootViewController.h"
#import "CoreHolder.h"
#import "Config.h"
#import "Makros.h"
#import "iCarouselExampleViewController.h"

#ifdef DIARY_LAUNCHER
#import "LauncherLayer.h"
#endif

@implementation AppDelegate

@synthesize window = window_;
@synthesize viewController = viewController_;
@synthesize navController = navController_;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
    NSLog(@"Remove Startup Flicker.");
	CCDirector *director = [CCDirector sharedDirector];
	CGSize size = [director winSize];
	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	sprite.position = ccp(size.width/2, size.height/2);
	sprite.rotation = -90;
	[sprite visit];
	[[director openGLView] swapBuffers];
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
    //	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
    //		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	director = [CCDirector sharedDirector];
    director.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
    //	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
    //								   pixelFormat:kEAGLColorFormatRGBA8	// kEAGLColorFormatRGBA8
    //								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
    //                            preserveBackbuffer:NO
    //                                    sharegroup:nil
    //                                 multiSampling:(kOpenGLMultisampling > 0 && IS_IPAD_2)
    //                               numberOfSamples:kOpenGLMultisampling
    //						];
    
    // Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:(kOpenGLMultisampling > 0 && IS_IPAD_2)
							   numberOfSamples:kOpenGLMultisampling];
	
    [glView setMultipleTouchEnabled:YES];
    
	// attach the openglView to the director
	[director setView:glView];
    
    // for rotation and other messages
    [director setDelegate:self];
    
    //for projection
    //[director_ setProjection:kCCDirectorProjection2D];
    
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
    
//#if GAME_AUTOROTATION == kGameAutorotationUIViewController
//    [director_ setDeviceOrientation:kCCDeviceOrientationLandscapeRight];
//   [director setDeviceOrientation:kCCDeviceOrientationPortrait];
//#else
//	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
//#endif
	
	[director setAnimationInterval:1.0/60];
    
#ifdef DEBUG
	[director setDisplayStats:YES];
#endif
	
    
    
	// Init the View Controller
//	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
//    
//	viewController.wantsFullScreenLayout = YES;
//	
//	// make the OpenGLView a child of the view controller
//	[viewController setView:glView];

//    navController = [[UINavigationController alloc] initWithRootViewController:director];
//    navController.navigationBarHidden = YES;
    
    iCarouselExampleViewController* categoryViewController = [[iCarouselExampleViewController alloc] initWithNibName:nil bundle:nil];
    
    
	// make the View Controller a child of the main window
	[window_ addSubview: categoryViewController.view];
	
	[window_ makeKeyAndVisible];
    [window_ setRootViewController:categoryViewController];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

   
	
	// Removes the startup flicker
	//
    [self removeStartupFlicker];
	
	// startup
//    CoreHolder *core = [CoreHolder sharedCoreHolder];
//    [core firstStart];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    return UIInterfaceOrientationMaskLandscape;
}
#else
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
#endif



- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
#ifdef DIARY_LAUNCHER
    LauncherLayer *launcher = (LauncherLayer *)[[CoreHolder sharedCoreHolder] currentMainLayer];
    [launcher hide];
#endif

	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
    
#ifdef DIARY_LAUNCHER
    LauncherLayer *launcher = (LauncherLayer *)[[CoreHolder sharedCoreHolder] currentMainLayer];
    [launcher show];
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window_ release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    NSLog(@"Handling URL: %@ from source %@", url, sourceApplication);
    
    [[CoreHolder sharedCoreHolder] setStartedFromLauncher:YES];

    return YES;
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window_ release];
	[super dealloc];
}

@end
