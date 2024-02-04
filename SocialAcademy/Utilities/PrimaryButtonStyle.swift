//
//  PrimaryButtonStyle.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/4/24.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled
    
    
    func makeBody(configuration: Configuration) -> some View {
        
        Group {
            if isEnabled {
                configuration.label
            } else {
                ProgressView()
            }
        }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .bold()
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
