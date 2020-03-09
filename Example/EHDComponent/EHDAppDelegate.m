//
//  EHDAppDelegate.m
//  EHDComponent
//
//  Created by luohs on 10/19/2017.
//  Copyright (c) 2017 luohs. All rights reserved.
//

#import "EHDAppDelegate.h"
#import <EHDLocalConfig/EHDLoadLocalConfig.h>
#import <EHDComponent/EHDComponent.h>
@interface EHDAppDelegate () <EHDComponentRoutable>
@property (nonatomic, strong) EHDEventBus *ebus;
@end

@implementation EHDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [EHDComponentConfig defaultConfig];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"component" ofType:@"json" inDirectory:nil];
    if (!filePath) {
        filePath = [ComponentConfig bundleResourcePath];
    }
    
    id cipher = nil;//[[EHDCryptCipherService alloc] init];
    NSLog(@"--------------------这是是分割线1---------------\n");
    NSLog(@"%@\n", [EHDLoadLocalConfig loadLocalConfigJSON:filePath model:nil cipher:cipher]);
    [ComponentConfig registerComponentStructs:[EHDLoadLocalConfig loadLocalConfigJSON:filePath model:nil cipher:cipher]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[[EHDUIBus alloc] initWithComponentRoutable:self] open:@"TestA" transitionBlock:^(__kindof UIViewController *thisInterface, __kindof UIViewController * nextInterface, TransitionCompletionBlock completionBlock) {
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nextInterface];
        nav.navigationBar.barTintColor = [UIColor colorWithRed:217/255.0 green:108/255.0 blue:0/255.0 alpha:1];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.window.rootViewController = nextInterface.navigationController ?: nextInterface;
        [self.window makeKeyAndVisible];
    } extraData:@{@"user_id": @1900} completion:^(id  _Nonnull result) {
        [[[EHDEventBus  alloc] initWithComponentRoutable:self] sendEventName:@"TestA" intentData:@{@"user_id": @1901}, @"TestA", nil];
    }];
    
    self.ebus = [[EHDEventBus alloc] initWithComponentRoutable:self];
    [self.ebus registerNotifications:[NSArray arrayWithObject:@"appdelegate"]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)receiveComponentEventName:(NSString *)eventName intentData:(id)intentData
{
    EHD_EventIs(@"appdelegate", {
        NSLog(@"%@, %@", eventName, intentData);
    })
}
@end
