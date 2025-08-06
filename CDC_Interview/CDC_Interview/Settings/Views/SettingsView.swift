//
//  SettingsView.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsService
    
    var body: some View {
        Form {
            Section("") {
                Toggle("Support EUR", isOn: $settings.supportEUR)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView().environmentObject(SettingsService())
}
