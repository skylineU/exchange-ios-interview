//
//  FileLoader.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import Foundation
import RxSwift

protocol FileLoaderType {
    func loadUSDPriceResponse() -> Single<CryptoResponse>
    func loadAllPriceResponse() -> Single<CryptoResponse>
}

final class FileLoaderService: FileLoaderType {
    
    func loadUSDPriceResponse() -> Single<CryptoResponse> {
        loadJSON(filename: "usdPrices", type: CryptoResponse.self)
    }
    
    func loadAllPriceResponse() -> Single<CryptoResponse> {
        loadJSON(filename: "allPrices", type: CryptoResponse.self)
    }
    
    private func loadJSON<T: Decodable>(filename: String, type: T.Type) -> Single<T> {
        Single.create { observer in
            guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
                observer(.failure(NSError(domain: "FileLoader", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found: \(filename)"])))
                return Disposables.create()
            }
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                observer(.success(result))
            } catch {
                observer(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
