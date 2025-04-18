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
    
    // Track animation state
    @State private var animating = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<symbolCount, id: \.self) { index in
                    Text(symbol)
                        .font(.system(size: .random(in: symbolSizeRange), weight: .heavy, design: .rounded))
                        .foregroundColor(.white.opacity(symbolOpacity))
                        .shadow(radius: 1)
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
