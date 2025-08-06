//
//  ViewModelTests.swift
//  CDC_InterviewTests
//
//  Created by M on 2025/8/6.
//

import XCTest
@testable import CDC_Interview

// MARK: - MainViewModelTests
class MainViewModelTests: TestCase {
    var viewModel: MainViewModel!
    var mockNetworkService: MockNetworkService!
    var mockSettingsService: MockSettingsService!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService(fileLoader: FileLoaderService())
        mockSettingsService = MockSettingsService()
        
        dependency.registerForTesting(MockNetworkService.self, mock: mockNetworkService)
        dependency.registerForTesting(MockSettingsService.self, mock: mockSettingsService)
        
        viewModel = MainViewModel()
    }
    
    func testInitialState() {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.cryptos.isEmpty)
    }
}
