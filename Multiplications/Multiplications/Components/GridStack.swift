//
//  GridStack.swift
//  Multiplications
//
//  Created by Lorenzo Ilardi on 16/04/25.
//

import SwiftUI

struct GridStack<Content: View>: View {
    typealias Row = Int
    typealias Column = Int
    
    let rows: Row
    let columns: Column
    let rowSpacing: CGFloat
    let columnsSpacing: CGFloat
    let content: (Row, Column) -> Content
    
    var body: some View {
        VStack(spacing: rowSpacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: columnsSpacing) {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}
