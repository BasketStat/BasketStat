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
import DropDown
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameStat") // Core Data 모델 이름
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase 초기화
        FirebaseApp.configure()
        // Kakao 초기화
        if let kakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as? String {
            KakaoSDK.initSDK(appKey: kakaoAppKey)
        }
        // DropDown 라이브러리 초기화
        DropDown.startListeningToKeyboard()

        
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

extension UIViewController {
   
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
      
    

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight + 100
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}

