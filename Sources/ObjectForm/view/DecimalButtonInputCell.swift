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

    var numberLocale: Locale?
    private var decimalButton: UIButton?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var outputValue: NSDecimalNumber? {
        guard let text = decimalButton?.title(for: .normal) else {
            return nil
        }

        let number = getNumberFrom(text: text)

        guard number != .notANumber else {
            return nil
        }

        return number
    }

    private func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 17.0)
        button.titleLabel?.textAlignment = .right
        return button
    }

    public override func setup(_ row: BaseRow) {
        textField.isHidden = true

        if let numberLocale {
            numberFormatter.locale = numberLocale
        }

        // Remove any existing views before setting up
        if let decimalButton = self.decimalButton {
            decimalButton.removeFromSuperview()
        }
        self.decimalButton = nil
        
        titleLabel.text = row.title

        let button = createButton()
        if let number = row.baseValue as? NSDecimalNumber {
            button.setTitle(numberFormatter.string(from: number), for: .normal)
        } else {
            button.setTitle("", for: .normal)
        }

        button.isUserInteractionEnabled = false
        self.decimalButton = button

        let pencilImageView = UIImageView(image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"))
        pencilImageView.tintColor = button.tintColor
        pencilImageView.contentMode = .scaleAspectFit
        pencilImageView.setContentHuggingPriority(.required, for: .horizontal)
        pencilImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        let hStack = UIStackView(arrangedSubviews: [UIView(), pencilImageView, button])
        hStack.spacing = 8
        appendView(view: hStack)
        
        if row.validationFailed == true {
            titleLabel.textColor = .systemRed
        } else {
            titleLabel.textColor = .label
        }
    }

    // Try to get a number from the text using the number formatter with and without the grouping separator
    private func getNumberFrom(text: String) -> NSDecimalNumber {
        let noSeparatorFormatter = Self.factoryNumberFormatter(usesGroupingSeparator: false)
        if let number = noSeparatorFormatter.number(from: text) {
            return NSDecimalNumber(decimal: number.decimalValue)
        }
        if let number2 = numberFormatter.number(from: text) {
            return NSDecimalNumber(decimal: number2.decimalValue)
        }
        return NSDecimalNumber.notANumber
    }

    public func showDecimalInput(in viewController: UIViewController) {
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.keyboardType = .decimalPad
            if let currentValue = self.outputValue {
                textField.text = self.numberFormatter.string(from: currentValue)
            }
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

            self.decimalButton?.setTitle(numberFormatter.string(from: number), for: .normal)
            self.delegate?.cellDidChangeValue(self, value: number)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        viewController.present(alertController, animated: true)
    }
}
