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

public class BaseRow : NSObject, Taggable {
    public typealias validationBlock = (() -> Bool)

    var title: String?
    var icon: String?
    var updateTag: String?
    var placeholder: String?
    var validation: validationBlock?
    var validationFailed: Bool?

    public var baseCell: FormInputCell {
        fatalError("Subclass should override")
    }

    public var baseValue: CustomStringConvertible? {
        set { fatalError("Subclass should override") }
        get { fatalError("Subclass should override") }
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

    public required init(title: String, icon: String, updateTag: String, value: T?, placeholder: String? = nil, validation: validationBlock? = nil) {
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

public typealias SelectRowConvertible = CustomStringConvertible & SelectCellOutputible & Equatable

/// Model for a row that selects a value from a list of values
public class SelectRow<T>: BaseRow where T: SelectRowConvertible {

    public typealias ValueChangedBlock = ((T?) -> Void)

    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? T }
    }
    public override var baseCell: FormInputCell {
        return cell
    }

    var value: T?
    public var cell: SelectInputCell<T>

    private var valueChangeBlock: ValueChangedBlock?
    
    public override var description: String {
        return value?.description ?? ""
    }

    public required init(
        title: String,
        icon: String,
        updateTag: String,
        value: T?,
        listOfValues: [T],
        valueChangeBlock: ValueChangedBlock? = nil
    ) {
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

    public required init(title: String, updateTag: String, value: String?) {
        self.cell = TextViewInputCell()

        super.init()

        self.title = title
        self.updateTag = updateTag
        self.value = value
        self.placeholder = nil
    }
}

public typealias StringRow = TypedRow<String>
public typealias DoubleRow = TypedRow<Double>
public typealias DateRow = TypedRow<Date>
