//
//  File.swift
//
//
//  Created by Jake on 3/2/20.
//

import Foundation
import UIKit

// Provide concrete type to make your own rows
public typealias StringRow = TypedRow<String>
public typealias DoubleRow = TypedRow<Double>
public typealias DecimalRow = TypedRow<NSDecimalNumber> // Objective does not support Decimal type
public typealias DateRow = TypedRow<Date>

// A generic model for inputing a value
public class TypedRow<T>: NSObject, BaseRow where T: CustomStringConvertible, T: Equatable {

    public lazy var baseCell: FormInputCell = {
        return TypedInputCell<T>()
    }()

    public var title: String?
    public var icon: String?
    public var kvcKey: String?
    public var placeholder: String?

    public var value: T

    public required init(title: String, icon: String, kvcKey: String, value: T, placeholder: String? = nil) {
        self.value = value
        super.init()

        self.title = title
        self.icon = icon
        self.kvcKey = kvcKey
        self.placeholder = placeholder
    }
}
