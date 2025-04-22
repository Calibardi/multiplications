//
//  TextModifiers.swift
//  Multiplications
//
//  Created by Lorenzo Ilardi on 17/04/25.
//

import SwiftUI

extension View {
    func colorfulTextBox(textSize: CGFloat, backgroundColor: Color, foregroundColor: Color = .white) -> some View {
        self.modifier(ColorfulTextBox(textSize: textSize, foregroundColor: foregroundColor, backgroundColor: backgroundColor))
    }
    
    func roundedShadowed(textSize: CGFloat, foregroundColor: Color = .white) -> some View {
        self.modifier(RoundedShadowedText(textSize: textSize, foregroundColor: foregroundColor))
    }
}

struct ColorfulTextBox: ViewModifier {
    let textSize: CGFloat
    let foregroundColor: Color
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .roundedShadowed(textSize: textSize, foregroundColor: foregroundColor)
            .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(backgroundColor.gradient)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 5, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.white, lineWidth: 3)
                    )
            )
    }
}


struct RoundedShadowedText: ViewModifier {
    let textSize: CGFloat
    let foregroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: textSize, weight: .black, design: .rounded))
            .foregroundColor(foregroundColor)
            .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
    }
}
