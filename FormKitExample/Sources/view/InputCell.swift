//
//  InputRow.swift
//  Mocha
//
//  Created by Jake on 2/20/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

class TypedInputCell<T>: FormInputCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textField.addTarget(self, action: #selector(textFieldValueChange(_ :)), for: .editingChanged)
        updateKeyboardType()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var outputValue: Any? {
        let text = textField.text ?? ""
        switch T.self {
        case is String.Type:
            return text
        case is Double.Type:
            return Double(text) ?? 0 as NSNumber
        default:
            return nil
        }
    }

    func updateKeyboardType() {
        switch T.self {
        case is String.Type:
            textField.keyboardType = .default
        case is Double.Type:
            textField.keyboardType = .decimalPad
        default:
            textField.keyboardType = .default
        }
    }

    override func setup(_ row: BaseRow) {

        titleLabel.text = row.title
        if let number = row.baseValue as? Double, number < Double.ulpOfOne {
            // clear the text so that user can start input from integer value
            textField.text = ""
        } else {
            textField.text = row.description
        }
        textField.placeholder = row.placeholder

        if row.validationFailed == true {
            titleLabel.textColor = .systemRed
        } else {
            titleLabel.textColor = .label
        }
    }

    @objc private func textFieldValueChange(_ sender: UITextField) {
        self.delegate?.cellDidChangeValue(self, value: outputValue)
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textField.resignFirstResponder()
    }
}
