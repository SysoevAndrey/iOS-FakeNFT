//
//  Observable.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

@propertyWrapper
final class Observable<Value> {
	private var onChange: ((Value) -> Void)? = nil

	var wrappedValue: Value {
		didSet {
			onChange?(wrappedValue)
		}
	}

	var projectedValue: Observable<Value> {
		return self
	}
	
	init(wrappedValue: Value) {
		self.wrappedValue = wrappedValue
	}

	func bind(action: @escaping (Value) -> Void) {
		self.onChange = action
	}
}
