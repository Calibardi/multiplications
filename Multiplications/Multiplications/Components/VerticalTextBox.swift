//
//  VerticalTextBox.swift
//  Multiplications
//
//  Created by Lorenzo Ilardi on 17/04/25.
//

import SwiftUI

struct VerticalTextBox: View {
    let topText: String
    let bottomText: String
    let horizontalAlignment: HorizontalAlignment
    
    var body: some View {
        VStack(alignment: horizontalAlignment, spacing: -8) {
            Text(topText)
                .roundedShadowed(textSize: 35)
            Text(bottomText)
                .roundedShadowed(textSize: 20)
        }
    }
}
