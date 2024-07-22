//
//  AppDelegate.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/9/24.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase 초기화
        FirebaseApp.configure()
        // Kakao 초기화
        KakaoSDK.initSDK(appKey: "61bd93bb18af831c8f6a58018fe4c998")

        return true
    }
    
   func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        var handled: Bool
        
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            print("\(handled) handled")
            return true
        }
        print("\(handled) handled")
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

