//
//  MainViewModel.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import Foundation
import Combine
import RxSwift
import RxRelay

// MARK: - Main ViewModel
final class MainViewModel: ObservableObject {
    // Input
    let searchText = BehaviorRelay<String>(value: "")
    
    // Output
    @Published var cryptos: [Crypto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Services
    private let networkService: NetworkServiceType?
    private let settingsService: SettingsServiceType?
    private let disposeBag = DisposeBag()
    
    init() {
        let dependency = Dependency.shared
        self.networkService = dependency.resolve(NetworkService.self)
        self.settingsService = dependency.resolve(SettingsService.self)
        
        setupBindings()
    }
    
    // retry
    func retry() {
        loadData()
    }
    
    private func setupBindings() {
        settingsService?.settingsChanged
            .subscribe(onNext: { [weak self] in
                self?.loadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        isLoading = true
        errorMessage = nil
        
        guard let networkService, let settingsService else { return }
        // Trigger different APIs based on the supportEUR
        let request = settingsService.supportEUR
        ? networkService.fetchAllPrices()
        : networkService.fetchUSDPrices()
        
        request
            .asObservable()
            .catch { [weak self] error in
                self?.handleError(error)
                return .just([])
            }
            .flatMapLatest { [weak self] cryptos -> Observable<[Crypto]> in
                guard let self else { return .just([]) }
                return self.applySearchFilter(to: cryptos)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] filteredCryptos in
                self?.isLoading = false
                self?.cryptos = filteredCryptos
            })
            .disposed(by: disposeBag)
    }
    
    // Apply search filter
    private func applySearchFilter(to cryptos: [Crypto]) -> Observable<[Crypto]> {
        return searchText
            .map { search in
                // If there is no search, then return all.
                guard !search.isEmpty else { return cryptos }
                // Return search results
                return cryptos.filter {
                    $0.name.lowercased().contains(search.lowercased())
                }
            }
    }
    
    // Error handling
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = "Fail to load: \(error.localizedDescription)"
        }
    }
}
