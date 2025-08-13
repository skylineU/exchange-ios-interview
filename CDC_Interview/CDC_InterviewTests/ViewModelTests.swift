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
        
        mockNetworkService = MockNetworkService(fileLoader: MockFileLoaderService())
        mockSettingsService = MockSettingsService()
        
        viewModel = MainViewModel(networkService: mockNetworkService, settingsService: mockSettingsService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockSettingsService = nil
        super.tearDown()
    }
    
    func testSuccessfulInitialLoad() {
        let mockCryptos = [
            TestDataFactory.createCrypto(id: 1, name: "BTC", usdPrice: 50000),
            TestDataFactory.createCrypto(id: 2, name: "ETH", usdPrice: 2000)
        ]
        mockNetworkService.fetchUSDPricesResult = .success(mockCryptos)
        mockSettingsService.supportEUR = false
        
        let exp = expectation(description: "Should load USD cryptos")
        
        viewModel.$cryptos
            .sink { cryptos in
                print("mike - cryptos:\(cryptos)")
                XCTAssertEqual(cryptos.count, 2)
                XCTAssertEqual(cryptos[0].name, "BTC")
                XCTAssertEqual(cryptos[1].name, "ETH")
                XCTAssertFalse(self.viewModel.isLoading)
                XCTAssertNil(self.viewModel.errorMessage)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailedLoad() {
        let error = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockNetworkService.fetchUSDPricesResult = .failure(error)
        
        let exp = expectation(description: "Show error message")
        
        viewModel.$errorMessage
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                XCTAssertTrue(errorMessage?.contains("fail") == true)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func testCurrencySwitch() {
        let mockCryptosUSD = [
            TestDataFactory.createCrypto(id: 1, name: "BTC", usdPrice: 50000),
            TestDataFactory.createCrypto(id: 2, name: "ETH", usdPrice: 2000)
        ]
        mockNetworkService.fetchUSDPricesResult = .success(mockCryptosUSD)
        mockSettingsService.supportEUR = false
        let mockSupportEUR = [
            TestDataFactory.createCrypto(id: 1, name: "BTC", usdPrice: 50000, eurPrice: 40000),
            TestDataFactory.createCrypto(id: 2, name: "ETH", usdPrice: 2000, eurPrice: 1000)
            
        ]
        
        let expUSD = expectation(description: "Initial USD load")
        let expEUR = expectation(description: "Switch to EUR")
        
        var callCount = 0
        viewModel.$cryptos
            .sink { cryptos in
                callCount += 1
                print("mike - cryptos:\(cryptos)")
                if callCount == 1 {
                    XCTAssertEqual(cryptos.first?.name, "BTC")
                    expUSD.fulfill()
                    
                    self.mockNetworkService.fetchAllPricesResult = .success(mockSupportEUR)
                    self.mockSettingsService.supportEUR = true
                } else if callCount == 2 {
                    XCTAssertEqual(cryptos.first?.name, "BTC")
                    expEUR.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expUSD, expEUR], timeout: 2)
    }
}
