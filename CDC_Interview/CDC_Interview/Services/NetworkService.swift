//
//  NetworkService.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import Foundation
import RxSwift

protocol NetworkServiceType {
    func fetchUSDPrices() -> Single<[Crypto]>
    func fetchAllPrices() -> Single<[Crypto]>
}

class NetworkService: NetworkServiceType {
    private let fileLoader: FileLoaderType
    
    init(fileLoader: FileLoaderType) {
        self.fileLoader = fileLoader
    }
    
    func fetchUSDPrices() -> Single<[Crypto]> {
        fileLoader.loadUSDPriceResponse()
            .map { $0.data } // Extract the "data" array
            .catchAndReturn([])
    }
    
    func fetchAllPrices() -> Single<[Crypto]> {
        fileLoader.loadAllPriceResponse()
            .map { $0.data } // Extract the "data" array
            .catchAndReturn([])
    }
}
