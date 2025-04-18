//
//  AnimatedXBackground.swift
//  Multiplications
//
//  Created by Lorenzo Ilardi on 18/04/25.
//

import SwiftUI

struct AnimatedXBackground: View {
    // Configuration
    private let symbol = "×"
    private let symbolCount = 10
    private let animationDuration: Double = 8
    private let symbolSizeRange: ClosedRange<CGFloat> = 35...65
    private let symbolOpacity: Double = 0.8
    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]
    
    // Track animation state
    @State private var animating = false
    
    private var randomSize: CGFloat { .random(in: symbolSizeRange) }
    private var symbolOpacityValue: Double { (randomSize/Double(100)) + 0.2 }
    private var randomColor: Color { colors.randomElement() ?? .white }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<symbolCount, id: \.self) { index in
                    Text(symbol)
                        .font(.system(size: randomSize, weight: .heavy, design: .rounded))
                        .foregroundColor(randomColor.opacity(symbolOpacityValue))
                        .shadow(radius: 0.2)
                        .position(
                            x: .random(in: 0..<geo.size.width),
                            y: animating ? -50 : geo.size.height + 50
                        )
                        .animation(
                            .linear(duration: animationDuration)
                            .delay(Double(index) * (animationDuration / Double(symbolCount)))
                            .repeatForever(autoreverses: false),
                            value: animating)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation {
                animating = true
            }
        }
    }
}

#Preview {
    AnimatedXBackground()
        .background(.black)
}
