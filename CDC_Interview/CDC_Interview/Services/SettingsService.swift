//
//  SettingsService.swift
//  CDC_Interview
//
//  Created by M on 2025/8/5.
//

import Foundation
import RxSwift

protocol SettingsServiceType: AnyObject {
    var supportEUR: Bool { get set }
    var settingsChanged: Observable<Void> { get }
}

final class SettingsService: SettingsServiceType, ObservableObject {
    private let supportEURSubject = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    @Published var supportEUR: Bool = false {
        didSet {
            supportEURSubject.onNext(supportEUR)
        }
    }
    
    var settingsChanged: Observable<Void> {
        // Use .map() to convert Bool to Void
        supportEURSubject.map { _ in () }
    }
    
    init() {
        if let initialValue = try? supportEURSubject.value() {
            supportEUR = initialValue
        }
        
        supportEURSubject
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                if self?.supportEUR != value {
                    self?.supportEUR = value
                }
            })
            .disposed(by: disposeBag)
    }
}
