//
//  ORAppDelegate.m
//  Melia
//
//  Created by orta therox on 08/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "APP_SETUP.h"

@implementation ORAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FBSession setDefaultAppID:FACEBOOK_API_KEY];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"MeliaNavBar.png"] forBarMetrics:UIBarMetricsDefault];


    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [FBSession.activeSession close];
}

@end
