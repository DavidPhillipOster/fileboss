//  AppDelegate.m
//
//  Created by David Phillip Oster on 6/8/20.
//  Copyright © 2020 David Phillip Oster. All rights reserved.
// Open Source under Apache 2 license. See LICENSE in https://github.com/DavidPhillipOster/fileboss/ .
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  CGRect bounds = [[UIScreen mainScreen] bounds];
  ViewController *vc = [[ViewController alloc] init];
  UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
  UIWindow *window = [[UIWindow alloc] initWithFrame:bounds];
  [window setRootViewController:nc];
  [self setWindow:window];
  [window makeKeyAndVisible];
  return YES;
}


@end
