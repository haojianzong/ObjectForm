//
//  DecimalButtonRow.swift
//  
//
//  Created by Jake on 3/2/20.
//

import Foundation
import UIKit

/// Model for a row that displays a decimal number with a button input
public class DecimalButtonRow: BaseRow {
    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? NSDecimalNumber }
    }

    public override var baseCell: FormInputCell {
        return cell
    }

    var value: NSDecimalNumber?
    public let cell: DecimalButtonInputCell

    public override var description: String {
        return value?.description ?? ""
    }

    open override func isValueMatchRowType(value: Any) -> Bool {
        return value is NSDecimalNumber
    }

    public required init(title: String, icon: String, kvcKey: String, value: NSDecimalNumber?, placeholder: String? = nil, validator: Validator? = nil) {
        self.cell = DecimalButtonInputCell()
        super.init()
        self.title = title
        self.icon = icon
        self.value = value
        self.kvcKey = kvcKey
        self.placeholder = placeholder
        self.validator = validator
    }
    
    public func showDecimalInput(in viewController: UIViewController) {
        cell.showDecimalInput(in: viewController)
    }
} 