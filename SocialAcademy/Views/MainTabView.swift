//
//  MainTabView.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/1/24.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            PostsList()
                .tabItem { Label("Posts", systemImage: "list.dash") }
            
            PostsList(vm: PostsViewModel(filter: .favorites))
                .tabItem { Label("Favorites", systemImage: "heart") }
        }
    }
}

//MARK: - Preview

#Preview {
    MainTabView()
}
