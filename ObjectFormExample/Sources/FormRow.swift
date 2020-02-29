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
    var updateTag: String? { get set }
}

class BaseRow : NSObject, Taggable {
    typealias validationBlock = (() -> Bool)

    var title: String?
    var icon: String?
    var updateTag: String?
    var placeholder: String?
    var validation: validationBlock?
    var validationFailed: Bool?

    var baseCell: FormInputCell {
        fatalError("Subclass should override")
    }

    public var baseValue: CustomStringConvertible? {
        set { fatalError("Subclass should override") }
        get { fatalError("Subclass should override") }
    }
}

/// Model for inputing a value
class TypedRow<T>: BaseRow where T: CustomStringConvertible, T: Equatable {
    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? T }
    }

    public override var baseCell: FormInputCell {
        return cell
    }

    var value: T?
    let cell: TypedInputCell<T>

    override var description: String {
        return value?.description ?? ""
    }
    required init(title: String, icon: String, updateTag: String, value: T?, placeholder: String? = nil, validation: validationBlock? = nil) {
        self.cell = TypedInputCell()
        super.init()
        self.title = title
        self.icon = icon
        self.value = value
        self.updateTag = updateTag
        self.placeholder = placeholder
        self.validation = validation
    }
}

typealias SelectRowConvertible = CustomStringConvertible&SelectCellOutputible&Equatable
/// Model for a row that selects a value from a list of values
class SelectRow<T>: BaseRow where T: SelectRowConvertible {

    typealias ValueChangedBlock = ((T?) -> Void)

    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? T }
    }
    public override var baseCell: FormInputCell {
        return cell
    }

    var value: T?
    var cell: SelectInputCell<T>

    private var valueChangeBlock: ValueChangedBlock?
    
    override var description: String {
        return value?.description ?? ""
    }

    required init(title: String,
                  icon: String,
                  updateTag: String,
                  value: T?,
                  listOfValues: [T],
                  valueChangeBlock: ValueChangedBlock? = nil) {
        self.cell = SelectInputCell(listOfValues: listOfValues, valueChangeBlock: valueChangeBlock)
        super.init()
        self.title = title
        self.icon = icon
        self.value = value
        self.updateTag = updateTag
        self.placeholder = placeholder
        self.valueChangeBlock = valueChangeBlock
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
        self.updateTag = nil
        self.placeholder = nil
    }
}

/// Model for a row that is a button
class TextViewRow: BaseRow {

    public override var baseCell: FormInputCell {
        return cell
    }

    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? String }
    }
    
    var value: String?

    var cell: TextViewInputCell

    override var description: String {
        return "<TextViewRow> \(title ?? "")"
    }

    required init(title: String, updateTag: String, value: String?) {
        self.cell = TextViewInputCell()

        super.init()

        self.title = title
        self.updateTag = updateTag
        self.value = value
        self.placeholder = nil
    }
}

typealias StringRow = TypedRow<String>
typealias DoubleRow = TypedRow<Double>
typealias DateRow = TypedRow<Date>
