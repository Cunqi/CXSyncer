//
//  AppDelegate.swift
//  CXSyncDemo
//
//  Created by Cunqi Xiao on 3/29/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXSyncer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        CXSyncerConfiguration.defaultStrategy = DemoSyncStrategy()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

class DemoSyncStrategy: CXSyncProcessStrategy {
    var index = 0
    override func sync(with item: CXSyncable, successCompletion: @escaping CXSyncProcessSuccess, failureCompletion: @escaping CXSyncProcessFailure) {
        Thread.sleep(forTimeInterval: 3)
        if index % 3 == 0 {
            failureCompletion(item, 400, nil)
            print("Failure 400 processed")
        } else if index % 5 == 0 {
            failureCompletion(item, 501, nil)
            print("Failure 500 processed")
        } else {
            successCompletion(item, 200)
            print("Success 200 processed")
        }
        index += 1
    }
}

