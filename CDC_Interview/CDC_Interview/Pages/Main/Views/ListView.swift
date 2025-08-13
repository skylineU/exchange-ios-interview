//
//  ListView.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import SwiftUI

struct ListView: View {
    let cryptos: [Crypto]
    
    var body: some View {
        if cryptos.isEmpty {
            Text("No matching token was found.")
                .padding(10)
                .foregroundColor(.secondary)
            Spacer()
        } else {
            List(cryptos) { crypto in
                NavigationLink(destination: DetailView(crypto: crypto)) {
                    CryptoRow(crypto: crypto)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    ListView(cryptos: [])
}
