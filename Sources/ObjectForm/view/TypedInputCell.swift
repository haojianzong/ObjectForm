//
//  InputRow.swift
//  Mocha
//
//  Created by Jake on 2/20/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

public class TypedInputCell<T>: FormInputCell, UITextFieldDelegate {

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTapped))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleButton, doneButton], animated: false)

        textField.inputAccessoryView = toolbar
        textField.delegate = self
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
            return Double(text) ?? Double(0)
        case is Date.Type:
            return dateFormatter.date(from: text)
        default:
            return nil
        }
    }

    func updateKeyboardType(row: BaseRow) {
        switch T.self {
        case is String.Type:
            textField.keyboardType = .default
            textField.addTarget(self, action: #selector(textFieldValueChange(_ :)), for: .editingChanged)

        case is Double.Type:
            textField.keyboardType = .decimalPad
            textField.addTarget(self, action: #selector(textFieldValueChange(_ :)), for: .editingChanged)

        case is Date.Type:

            let datePicker = UIDatePicker()
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            textField.inputView = datePicker

            if let date = row.baseValue as? Date {
                datePicker.date = date
            }

        default:
            textField.keyboardType = .default
        }
    }

    public override func setup(_ row: BaseRow) {

        titleLabel.text = row.title
        if let number = row.baseValue as? Double, number < Double.ulpOfOne {
            // clear the text so that user can start input from integer value
            textField.text = ""
        } else if let date = row.baseValue as? Date {
            textField.text = dateFormatter.string(from: date)
        } else {
            textField.text = row.description
        }

        updateKeyboardType(row: row)

        textField.placeholder = row.placeholder

        if row.validationFailed == true {
            if #available(iOS 13, *) {
                titleLabel.textColor = .systemRed
            } else {
                titleLabel.textColor = .red
            }
        } else {
            if #available(iOS 13, *) {
                titleLabel.textColor = .label
            } else {
                titleLabel.textColor = .black
            }
        }
    }

    @objc private func doneBtnTapped() {
        _ = resignFirstResponder()
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        textField.text = dateFormatter.string(from: sender.date)
        self.delegate?.cellDidChangeValue(self, value: outputValue)
    }

    @objc private func textFieldValueChange(_ sender: UITextField) {
        self.delegate?.cellDidChangeValue(self, value: outputValue)
    }

    public override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textField.resignFirstResponder()
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let inputView = textField.inputView else {
            return true
        }
        let isDatePicker = inputView.isKind(of: UIDatePicker.self)

        return !isDatePicker
    }

}
