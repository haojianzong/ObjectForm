//
//  FormRow.swift
//  Mocha
//
//  Created by Jake on 2/23/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

protocol Taggable: AnyObject {
    var kvcKey: String? { get set }
}

public class BaseRow : NSObject, Taggable {
    public typealias Validator = (() -> Bool)

    var title: String?
    var icon: String?

    // Update object properties using the key with key-value-coding
    var kvcKey: String?

    var placeholder: String?
    var validator: Validator?
    var validationFailed: Bool?

    public var baseCell: FormInputCell {
        fatalError("Subclass should override")
    }

    public var baseValue: CustomStringConvertible? {
        set { fatalError("Subclass should override") }
        get { fatalError("Subclass should override") }
    }

    // Used to check type when updating object's value with key `-value-coding
    func isValueMatchRowType(value: Any) -> Bool {
        fatalError("Subclass must override")
    }
}

/// Model for inputing a value
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

public typealias SelectRowConvertible = CustomStringConvertible & SelectCellOutputible & Equatable

/// Model for a row that selects a value from a list of values
public class SelectRow<T>: BaseRow where T: SelectRowConvertible {

    public typealias ValueChangedHandler = ((T?) -> Void)

    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? T }
    }
    public override var baseCell: FormInputCell {
        return cell
    }

    var value: T?
    public var cell: SelectInputCell<T>

    private var valueChangedHandler: ValueChangedHandler?
    
    public override var description: String {
        return value?.description ?? ""
    }

    override func isValueMatchRowType(value: Any) -> Bool {
        let t = type(of: value)
        return T.self == t
    }

    public required init(
        title: String,
        icon: String,
        kvcKey: String,
        value: T?,
        listOfValues: [T],
        valueChangedHandler: ValueChangedHandler? = nil
    ) {
        self.cell = SelectInputCell(listOfValues: listOfValues, valueChangedHandler: valueChangedHandler)
        super.init()
        self.title = title
        self.icon = icon
        self.value = value
        self.kvcKey = kvcKey
        self.placeholder = placeholder
        self.valueChangedHandler = valueChangedHandler
    }
}

/// Model for a row that is a button
class ButtonRow: BaseRow {
    
    public override var baseValue: CustomStringConvertible? {
        get { return nil }
        set { }
    }

    public override var baseCell: FormInputCell {
        return cell
    }

    var cell: ButtonCell

    let actionTag: String

    override var description: String {
        return "<ButtonRow> \(title ?? "")"
    }

    required init(title: String, icon: String, actionTag: String) {
        self.actionTag = actionTag

        self.cell = ButtonCell()

        super.init()
        self.title = title
        self.icon = icon
        self.kvcKey = nil
        self.placeholder = nil
    }
}

public class TextViewRow: BaseRow {

    public override var baseCell: FormInputCell {
        return cell
    }

    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? String }
    }
    
    var value: String?

    public var cell: TextViewInputCell

    public override var description: String {
        return "<TextViewRow> \(title ?? "")"
    }

    override func isValueMatchRowType(value: Any) -> Bool {
        let t = type(of: value)
        return String.self == t
    }

    public required init(title: String, kvcKey: String, value: String?) {
        self.cell = TextViewInputCell()

        super.init()

        self.title = title
        self.kvcKey = kvcKey
        self.value = value
        self.placeholder = nil
    }
}

public typealias StringRow = TypedRow<String>
public typealias DoubleRow = TypedRow<Double>
public typealias DateRow = TypedRow<Date>
