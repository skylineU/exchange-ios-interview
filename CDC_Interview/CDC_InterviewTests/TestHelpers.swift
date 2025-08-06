//
//  TestHelpers.swift
//  CDC_InterviewTests
//
//  Created by M on 2025/8/6.
//

import XCTest
import RxSwift
import RxTest
@testable import CDC_Interview

// MARK: - TestCase
class TestCase: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var dependency = Dependency.shared
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
}

// MARK: - Dependency extension
extension Dependency {
    
    func registerForTesting<T>(_ serviceType: T.Type, mock: T) {
        register(serviceType) { _ in
            mock
        }
    }
    
    func resolveForTesting<T>(_ serviceType: T.Type) -> T? {
        resolve(serviceType)
    }
}

// MARK: - Mock Service
class MockFileLoaderService: FileLoaderType {
    var usdResponseResult: Result<CryptoResponse, Error>?
    var allResponseResult: Result<CryptoResponse, Error>?
    
    func loadUSDPriceResponse() -> Single<CryptoResponse> {
        return resultToSingle(usdResponseResult)
    }
    
    func loadAllPriceResponse() -> Single<CryptoResponse> {
        return resultToSingle(allResponseResult)
    }
    
    private func resultToSingle<T>(_ result: Result<T, Error>?) -> Single<T> {
        guard let result = result else {
            return .error(NSError(domain: "FileLoaderService", code: -1, userInfo: nil))
        }
        switch result {
        case .success(let value): return .just(value)
        case .failure(let error): return .error(error)
        }
    }
}

class MockNetworkService: NetworkServiceType {
    private let fileLoader: FileLoaderType
    
    init(fileLoader: FileLoaderType) {
        self.fileLoader = fileLoader
    }
    
    var fetchUSDPricesResult: Result<[Crypto], Error> = .success([])
    var fetchAllPricesResult: Result<[Crypto], Error> = .success([])
    
    func fetchUSDPrices() -> Single<[Crypto]> {
        switch fetchUSDPricesResult {
        case .success(let value): return .just(value)
        case .failure(let error): return .error(error)
        }
    }
    
    func fetchAllPrices() -> Single<[Crypto]> {
        switch fetchAllPricesResult {
        case .success(let value): return .just(value)
        case .failure(let error): return .error(error)
        }
    }
}

class MockSettingsService: SettingsServiceType, ObservableObject {
    var supportEUR: Bool = false
    var settingsChanged: Observable<Void> {
        return supportEURSubject.asObservable()
    }
    
    private let supportEURSubject = PublishSubject<Void>()
    
    func setSupportEUR(_ value: Bool) {
        supportEUR = value
        supportEURSubject.onNext(())
    }
}

// MARK: - TestDataFactory
struct TestDataFactory {
    static func createCrypto(
        id: Int = 1,
        name: String = "BTC",
        usdPrice: Decimal? = Decimal(1000),
        eurPrice: Decimal? = Decimal(900),
        tags: [Tag] = [.deposit]
    ) -> Crypto {
        return Crypto(
            id: id,
            name: name,
            usdPrice: usdPrice,
            eurPrice: eurPrice,
            tags: tags
        )
    }
    
    static func createCryptoResponse(
        code: String = "1",
        data: [Crypto] = [createCrypto()]
    ) -> CryptoResponse {
        return CryptoResponse(code: code, data: data)
    }
}

extension Crypto: @retroactive Equatable {
    public static func == (lhs: Crypto, rhs: Crypto) -> Bool {
        guard lhs.id == rhs.id,
              lhs.name == rhs.name,
              lhs.tags == rhs.tags else {
            return false
        }
        
        switch (lhs.usdPrice, rhs.usdPrice) {
        case (nil, nil): break
        case let (l?, r?): guard l == r else { return false }
        default: return false
        }
        
        switch (lhs.eurPrice, rhs.eurPrice) {
        case (nil, nil): break
        case let (l?, r?): guard l == r else { return false }
        default: return false
        }
        
        return true
    }
}
