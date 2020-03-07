//
//  File.swift
//  
//
//  Created by Jake on 3/2/20.
//

import Foundation
import UIKit

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

    // Select row can define its outputValue
    override func isValueMatchRowType(value: Any) -> Bool {
        return true
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

