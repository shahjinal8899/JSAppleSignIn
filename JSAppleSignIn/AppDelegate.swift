//
//  AppDelegate.swift
//  JSAppleSignIn
//
//  Created by The Shiva's Girl on 23/06/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Splash Sleep
        Thread.sleep(forTimeInterval: 3.0)

        //App only for Light Mode
        self.window?.overrideUserInterfaceStyle = .light

        return true
    }
}

