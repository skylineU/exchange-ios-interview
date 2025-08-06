//
//  CryptoRow.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import SwiftUI

struct CryptoRow: View {
    let crypto: Crypto
    @EnvironmentObject private var settings: SettingsService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(crypto.name)
                .font(.headline)
            
            Text("USD: \(CryptoFormatter.format(value: crypto.usdPrice))")
                .font(.subheadline)
            
            if settings.supportEUR, let eur = crypto.eurPrice {
                Text("EUR: \(CryptoFormatter.format(value: eur))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
