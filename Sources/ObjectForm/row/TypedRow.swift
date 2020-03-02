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
public typealias DateRow = TypedRow<Date>

// A generic model for inputing a value
public class TypedRow<T>: BaseRow where T: CustomStringConvertible, T: Equatable {
    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? T }
    }

    public override var baseCell: FormInputCell {
        return cell
    }

    var value: T?
    public let cell: TypedInputCell<T>

    public override var description: String {
        return value?.description ?? ""
    }

    override func isValueMatchRowType(value: Any) -> Bool {
        let t = type(of: value)
        return T.self == t
    }

    public required init(title: String, icon: String, kvcKey: String, value: T?, placeholder: String? = nil, validator: Validator? = nil) {
        self.cell = TypedInputCell()
        super.init()
        self.title = title
        self.icon = icon
        self.value = value
        self.kvcKey = kvcKey
        self.placeholder = placeholder
        self.validator = validator
    }
}
