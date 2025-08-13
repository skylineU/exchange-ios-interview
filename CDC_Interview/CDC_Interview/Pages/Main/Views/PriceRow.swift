//
//  PriceRow.swift
//  CDC_Interview
//
//  Created by M on 2025/8/6.
//

import SwiftUI

struct PriceRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .frame(width: 60, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .font(.title2)
                .monospacedDigit()
        }
    }
}

#Preview {
    PriceRow(title: "USD", value: "89208.98")
}
