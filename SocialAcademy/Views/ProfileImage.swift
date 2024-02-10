//
//  ProfileImage.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/9/24.
//

import SwiftUI

struct ProfileImage: View {
    let url: URL?
    
    
    var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: url) { image in
                    image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "person")
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(Color.gray.opacity(0.30)))
            
        }
    }
}

#Preview {
    ProfileImage(url: User.testUser.imageURL)
}
