//
//  SocialAcademyApp.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/22/24.
//

import SwiftUI
import Firebase

@main
struct SocialAcademyApp: App {
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            PostsList()
        }
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application (_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        
//        FirebaseApp.configure()
//        
//        return true
//    }
//}
