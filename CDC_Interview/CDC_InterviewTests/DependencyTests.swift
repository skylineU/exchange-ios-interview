//
//  DependencyTests.swift
//  CDC_InterviewTests
//
//  Created by M on 2025/8/6.
//

import XCTest

final class DependencyTests: TestCase {
    
    func testRegisterAndResolve() {
        let mockService = MockSettingsService()
        
        dependency.registerForTesting(MockSettingsService.self, mock: mockService)
        let resolved = dependency.resolveForTesting(MockSettingsService.self)
        
        XCTAssertTrue(resolved === mockService)
    }
    
    func testResolveUnregisteredService() {
        XCTExpectFailure("Unregistered service should trigger fatalError") {
            _ = dependency.resolveForTesting(MockSettingsService.self)
        }
    }
}
