//
//  AppDelegate.swift
//  iChat
//
//  Created by Constantine Nikolsky on 12.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    
    var window: UIWindow?
    
}

extension AppDelegate: UIApplicationDelegate {
   
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        printAppState(from: .notRunning, to: .inactive)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        printAppState(from: .inactive, to: .inactive)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        printAppState(from: .inactive, to: .active)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        printAppState(from: .background, to: .inactive)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        printAppState(from: .active, to: .inactive)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        printAppState(from: .inactive, to: .background)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        printAppState(from: .background, to: .suspended)
    }
    
    func printAppState(from: ApplicationState, to: ApplicationState, functionName: String = #function){
        "Application moved from '\(from)' to '\(to)': \(functionName)".log()
    }
    
        func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
            trace()
        }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

