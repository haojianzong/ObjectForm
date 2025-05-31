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
    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter
    }()
    
    var numberLocale: Locale?
    private var decimalButton: UIButton?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var outputValue: NSDecimalNumber? {
        if let text = decimalButton?.title(for: .normal) {
            return NSDecimalNumber(string: text)
        }
        return nil
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
        button.addTarget(self, action: #selector(decimalButtonTapped), for: .touchUpInside)
        self.decimalButton = button

        let pencilImageView = UIImageView(image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"))
        pencilImageView.tintColor = .systemBlue
        pencilImageView.contentMode = .scaleAspectFit
        pencilImageView.setContentHuggingPriority(.required, for: .horizontal)
        pencilImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        let hStack = UIStackView(arrangedSubviews: [UIView(), button, pencilImageView])
        hStack.spacing = 8
        appendView(view: hStack)
        
        if row.validationFailed == true {
            titleLabel.textColor = .systemRed
        } else {
            titleLabel.textColor = .label
        }
    }
    
    @objc private func decimalButtonTapped() {
        // This will be handled by the row's showDecimalInput method
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

            let number = NSDecimalNumber(string: text)
            guard number != NSDecimalNumber.notANumber else {
                return
            }

            self.decimalButton?.setTitle(text, for: .normal)
            self.delegate?.cellDidChangeValue(self, value: number)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        viewController.present(alertController, animated: true)
    }
}
