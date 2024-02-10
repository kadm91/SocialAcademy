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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
           AuthView()
                
        }
    }
}


