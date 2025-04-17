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
    
    var body: some View {
        VStack(alignment: .trailing, spacing: -8) {
            Text(topText)
                .roundedShadowed(textSize: 35)
            Text(bottomText)
                .roundedShadowed(textSize: 20)
        }
    }
}
