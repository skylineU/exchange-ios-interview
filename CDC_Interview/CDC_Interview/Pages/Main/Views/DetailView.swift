//
//  DetailView.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import SwiftUI

struct DetailView: View {
    let crypto: Crypto
    @EnvironmentObject private var settings: SettingsService
    
    var body: some View {
        VStack(spacing: 24) {
            
            Text(crypto.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            .padding(.top, 40)
            
            VStack(alignment: .leading, spacing: 16) {
                PriceRow(title: "USD", value: CryptoFormatter.format(value: crypto.usdPrice))
                
                if settings.supportEUR, let eur = crypto.eurPrice {
                    PriceRow(title: "EUR", value: CryptoFormatter.format(value: eur))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationBarTitle(crypto.name, displayMode: .inline)
    }
}

//#Preview {
//    DetailView()
//}
