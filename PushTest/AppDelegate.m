//
//  AppDelegate.m
//  PushTest
//
//  Created by 선민 on 2017. 2. 11..
//  Copyright © 2017년 kuu. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // - 푸쉬 승인 요청 팝업.
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    // - 푸쉬 사용 승인 시 디바이스 토큰 가져오기.
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // Initialize the Amazon Cognito credentials provider
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionAPNortheast2
                                                          identityPoolId:@"Your Cognito PoolId"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPNortheast2 credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // - <> 를 제거하고, 공백을 제거함.
    NSString* token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];

    // - AWSSNS 선언.
    AWSSNS* client = [AWSSNS defaultSNS];
    
    // - SNS에 등록된 ARN에 token을 보낼 준비를 해준다.
    AWSSNSCreatePlatformEndpointInput* input = [AWSSNSCreatePlatformEndpointInput new];
    input.token             = token;
    input.platformApplicationArn = @"Your arn apns code";
    
    // - endpoint 등록.
    [[client createPlatformEndpoint:input] continueWithSuccessBlock:^id _Nullable(AWSTask<AWSSNSCreateEndpointResponse *> * _Nonnull task) {
     
        NSLog(@"Create Endpoint Success");
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"success" message:@"토큰 등록 성공" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return nil;
    }];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"token error : %@", error.description);
}

@end
