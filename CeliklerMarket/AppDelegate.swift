//
//  AppDelegate.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 1.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        rememberUser()
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle
/*
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        
    }*/
    
    func rememberUser() {
        let user : String? =  UserDefaults.standard.string(forKey: "username")
        if user != nil  {
            let board  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbar =  board.instantiateViewController(withIdentifier: "tabBarViewController") as! UITabBarController
            window?.rootViewController = tabbar
        }
    }
}

