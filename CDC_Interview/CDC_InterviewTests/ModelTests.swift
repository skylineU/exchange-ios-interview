//
//  ModelTests.swift
//  CDC_InterviewTests
//
//  Created by M on 2025/8/6.
//

import XCTest
@testable import CDC_Interview

class ModelTests: TestCase {
    func testCryptoDecodingV1Format() {
        let json = """
        {
            "id": 1,
            "name": "BTC",
            "usd": 19999.89,
            "tags": ["withdrawal"]
        }
        """.data(using: .utf8)!
        
        do {
            let crypto = try JSONDecoder().decode(Crypto.self, from: json)
            
            // 验证
            XCTAssertEqual(crypto.id, 1)
            XCTAssertEqual(crypto.name, "BTC")
            XCTAssertEqual(crypto.usdPrice, Decimal(19999.89))
            XCTAssertNil(crypto.eurPrice)
            XCTAssertEqual(crypto.tags, [.withdrawal])
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
    
    func testCryptoDecodingV2Format() {
        let json = """
        {
            "id": 1,
            "name": "BTC",
            "price": {
                "usd": 19999.89,
                "eur": 18888.89
            },
            "tags": ["withdrawal", "deposit"]
        }
        """.data(using: .utf8)!
        
        do {
            let crypto = try JSONDecoder().decode(Crypto.self, from: json)
            
            XCTAssertEqual(crypto.id, 1)
            XCTAssertEqual(crypto.name, "BTC")
            XCTAssertEqual(crypto.usdPrice, Decimal(19999.89))
            XCTAssertEqual(crypto.eurPrice, Decimal(18888.89))
            XCTAssertEqual(crypto.tags, [.withdrawal, .deposit])
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
    
    func testCryptoResponseDecoding() {
        let json = """
        {
            "code": "1",
            "data": [
                {
                    "id": 1,
                    "name": "BTC",
                    "usd": 50000.0,
                    "tags": ["withdrawal"]
                }
            ]
        }
        """.data(using: .utf8)!
        
        do {
            let response = try JSONDecoder().decode(CryptoResponse.self, from: json)
            
            XCTAssertEqual(response.code, "1")
            XCTAssertEqual(response.data.count, 1)
            XCTAssertEqual(response.data[0].name, "BTC")
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
}
