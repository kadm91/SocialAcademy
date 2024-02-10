//
//  MainTabView.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/1/24.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject private var factory: ViewModelFactory
    
    var body: some View {
        TabView {
            NavigationStack {
                PostsList(vm: factory.makePostViewModel())
            }
            .tabItem { Label("Posts", systemImage: "list.dash") }
            
            NavigationStack {
                PostsList(vm: factory.makePostViewModel(filter: .favorites))
            }
            .tabItem { Label("Favorites", systemImage: "heart") }
           
            
            ProfileView(vm: factory.makeProfileViewModel())
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}

//MARK: - Preview

#Preview {
    MainTabView()
        .environmentObject(ViewModelFactory.preview)
}
