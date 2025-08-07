//
//  ServiceTests.swift
//  CDC_InterviewTests
//
//  Created by M on 2025/8/6.
//

import XCTest
@testable import CDC_Interview

// MARK: - FileLoaderServiceTests
class FileLoaderServiceTests: TestCase {
    var mockFileLoaderService: FileLoaderService!
    
    override func setUp() {
        super.setUp()
        mockFileLoaderService = FileLoaderService()
    }
    
    func testLoadUSDPriceResponseSuccess() {
        let expectation = self.expectation(description: "Load USD price")
        
        mockFileLoaderService.loadUSDPriceResponse()
            .subscribe(onSuccess: { response in
                XCTAssertEqual(response.code, "1")
                XCTAssertFalse(response.data.isEmpty)
                expectation.fulfill()
            }, onFailure: { error in
                XCTFail("Load failed: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadAllPriceResponseSuccess() {
        let expectation = self.expectation(description: "Load all prices")
        
        mockFileLoaderService.loadAllPriceResponse()
            .subscribe(onSuccess: { response in
                XCTAssertEqual(response.code, "1")
                XCTAssertFalse(response.data.isEmpty)
                expectation.fulfill()
            }, onFailure: { error in
                XCTFail("Load failed: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

// MARK: - NetworkServiceTests
class NetworkServiceTests: TestCase {
    var mockNetworkService: MockNetworkService!
    var mockFileLoaderService: MockFileLoaderService!
    
    override func setUp() {
        super.setUp()
        mockFileLoaderService = MockFileLoaderService()
        mockNetworkService = MockNetworkService(fileLoader: mockFileLoaderService)
    }
    
    func testFetchUSDPricesSuccess() {
        let expectedCryptos = [TestDataFactory.createCrypto()]
        let response = TestDataFactory.createCryptoResponse(data: expectedCryptos)
        mockFileLoaderService.usdResponseResult = .success(response)
        
        let expectation = self.expectation(description: "Get USD price successfully")
        
        mockNetworkService.fetchUSDPrices()
            .subscribe(onSuccess: { cryptos in
                XCTAssertEqual(cryptos, expectedCryptos)
                expectation.fulfill()
            }, onFailure: { error in
                XCTFail("Request failed: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchAllPricesSuccess() {
        let expectedCryptos = [TestDataFactory.createCrypto()]
        let response = TestDataFactory.createCryptoResponse(data: expectedCryptos)
        mockFileLoaderService.allResponseResult = .success(response)
        
        let expectation = self.expectation(description: "Get all prices successfully")
        
        mockNetworkService.fetchAllPrices()
            .subscribe(onSuccess: { cryptos in
                XCTAssertEqual(cryptos, expectedCryptos)
                expectation.fulfill()
            }, onFailure: { error in
                XCTFail("Request failed: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchUSDPricesFailure() {
        let error = NSError(domain: "TestError", code: 404, userInfo: nil)
        mockFileLoaderService.usdResponseResult = .failure(error)
        
        let expectation = self.expectation(description: "Failed to get USD price")
        
        mockNetworkService.fetchUSDPrices()
            .subscribe(onSuccess: { _ in
                XCTFail("Return an error")
                expectation.fulfill()
            }, onFailure: { receivedError in
                XCTAssertEqual((receivedError as NSError).code, 404)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

// MARK: - SettingsServiceTests
class SettingsServiceTests: TestCase {
    var mockSettingsService: MockSettingsService!
    
    override func setUp() {
        super.setUp()
        mockSettingsService = MockSettingsService()
    }
    
    func testSettingsChangeNotification() {
        let exp = expectation(description: "Should get change event")
        
        mockSettingsService.settingsChanged
            .subscribe(onNext: {
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        
        mockSettingsService.supportEUR = true
        
        waitForExpectations(timeout: 1)
    }
    
    func testTwoWayBinding() {
        mockSettingsService.supportEUR = true
        XCTAssertTrue(mockSettingsService.supportEUR)
        
        mockSettingsService.supportEUR = false
        XCTAssertFalse(mockSettingsService.supportEUR)
    }
}
