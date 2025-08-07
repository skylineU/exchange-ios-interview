//
//  MainView.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import SwiftUI
import RxSwift

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @State private var searchText = ""
    @EnvironmentObject private var settings: SettingsService
    
    init() {
        let dependency = Dependency.shared
        let networkService = dependency.resolve(NetworkService.self)
        let settingsService = dependency.resolve(SettingsService.self)
        let viewModel = MainViewModel(networkService: networkService, settingsService: settingsService)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // SearchBar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                if viewModel.isLoading { // Loading
                    ProgressView("Loading...")
                        .frame(maxHeight: .infinity)
                } else if let error = viewModel.errorMessage { // Error
                    ErrorView(error: error, retryAction: viewModel.retry)
                } else { // ListView
                    ListView(cryptos: viewModel.cryptos)
                }
            }
            .navigationTitle("Prices")
            .onChange(of: searchText) { // Monitor search results
                viewModel.searchText.accept($0)
            }
        }
    }
}

#Preview {
    MainView()
}
