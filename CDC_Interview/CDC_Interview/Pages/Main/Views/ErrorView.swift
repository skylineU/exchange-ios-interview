//
//  ErrorView.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text(error)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    ErrorView(error: "Error", retryAction: {
        print("Retry")
    })
}
