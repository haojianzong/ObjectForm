//
//  InputRow.swift
//  Mocha
//
//  Created by Jake on 2/20/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

public class DecimalButtonInputCell: FormInputCell {
    private lazy var numberFormatter: NumberFormatter = {
        return Self.factoryNumberFormatter(usesGroupingSeparator: true)
    }()

    private static func factoryNumberFormatter(usesGroupingSeparator: Bool) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 20
        formatter.currencySymbol = ""
        formatter.usesGroupingSeparator = usesGroupingSeparator
        return formatter
    }

    private static func textByRemovingGroupingSeparator(_ text: String, locale: Locale?) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale ?? .current

        guard let groupingSeparator = formatter.groupingSeparator, !groupingSeparator.isEmpty else {
            return text
        }

        return text.replacingOccurrences(of: groupingSeparator, with: "")
    }

    var numberLocale: Locale?
    private weak var alertController: UIAlertController?
    
    private lazy var decimalButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 17.0)
        button.titleLabel?.textAlignment = .right
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var pencilImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"))
        imageView.tintColor = decimalButton.tintColor
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [UIView(), pencilImageView, decimalButton])
        stack.spacing = 8
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var outputValue: NSDecimalNumber? {
        guard let text = decimalButton.title(for: .normal) else {
            return nil
        }

        let number = getNumberFrom(text: text)

        guard number != .notANumber else {
            return nil
        }

        return number
    }

    public override func setup(_ row: BaseRow) {
        textField.isHidden = true

        if let numberLocale {
            numberFormatter.locale = numberLocale
        }

        // Remove existing stack view if it exists
        hStack.removeFromSuperview()
        appendView(view: hStack)
        titleLabel.text = row.title

        if let number = row.baseValue as? NSDecimalNumber {
            decimalButton.setTitle(numberFormatter.string(from: number), for: .normal)
        } else {
            decimalButton.setTitle("", for: .normal)
        }
        
        if row.validationFailed == true {
            titleLabel.textColor = .systemRed
        } else {
            titleLabel.textColor = .label
        }
    }

    // Try to get a number from the text using the number formatter with and without the grouping separator
    private func getNumberFrom(text: String) -> NSDecimalNumber {
        let noSeparatorFormatter = Self.factoryNumberFormatter(usesGroupingSeparator: false)
        noSeparatorFormatter.locale = numberFormatter.locale
        let noSeparatorText = Self.textByRemovingGroupingSeparator(text, locale: numberFormatter.locale)
        if let number = noSeparatorFormatter.number(from: noSeparatorText) {
            return NSDecimalNumber(decimal: number.decimalValue)
        }
        if let number2 = numberFormatter.number(from: text) {
            return NSDecimalNumber(decimal: number2.decimalValue)
        }
        return NSDecimalNumber.notANumber
    }

    public func showDecimalInput(in viewController: UIViewController) {
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        self.alertController = alertController
        
        alertController.addTextField { [weak self] textField in
            guard let self = self else { return }
            textField.keyboardType = .decimalPad
            if let currentValue = self.outputValue {
                textField.text = self.numberFormatter.string(from: currentValue)
            }
            
            // Add +/- button to keyboard toolbar
            let minusButton = KeyboardToolbarFactory.factoryKeyboardButton(title: "+/-")
            minusButton.addTarget(self, action: #selector(self.minusButtonTapped(_:)), for: .touchUpInside)
            textField.inputAccessoryView = KeyboardToolbarFactory.factoryKeyboardToolbar(leadingButtonList: [UIBarButtonItem(customView: minusButton)])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self,
                  let text = alertController.textFields?.first?.text else {
                return
            }

            let number = getNumberFrom(text: text)
            guard number != NSDecimalNumber.notANumber else {
                return
            }

            guard number != outputValue else {
                return
            }

            self.decimalButton.setTitle(numberFormatter.string(from: number), for: .normal)
            self.delegate?.cellDidChangeValue(self, value: number)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        viewController.present(alertController, animated: true)
    }
    
    @objc private func minusButtonTapped(_ button: UIButton) {
        guard let textField = alertController?.textFields?.first,
              let text = textField.text else {
            return
        }
        
        let token = "-"
        if text.hasPrefix(token) {
            textField.text = text.replacingOccurrences(of: token, with: "")
        } else {
            textField.text = token + text
        }
    }
}
