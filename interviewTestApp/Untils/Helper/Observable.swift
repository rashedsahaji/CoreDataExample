//
//  Obser.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 24/06/23.
//

import Foundation
class Observable<T> {
    var value: T {
        didSet {
            for item in self.listener {
                item?(value)
            }
        }
    }
    private var listener: [((T) -> Void)?] = []

    init(_ value: T) {
        self.value = value
    }
    func bind(_ closure: @escaping (T) -> Void) {
        listener.append(closure)
    }
}

protocol ObservableUIVC : AnyObject {
    func setupUI()
}
protocol ObservableVM : AnyObject {
    func fetchData()
    var error : Observable<String?> { get }
}
