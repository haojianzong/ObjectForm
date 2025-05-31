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
        formatter.maximumFractionDigits = 20
        return formatter
    }()
    
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
    
    public override func setup(_ row: BaseRow) {
        // Remove any existing views before setting up
        if let decimalButton = self.decimalButton {
            decimalButton.removeFromSuperview()
        }
        self.decimalButton = nil
        
        titleLabel.text = row.title
        
        // Create and setup the decimal button
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 17.0)
        button.titleLabel?.textAlignment = .right
        if let number = row.baseValue as? NSDecimalNumber {
            button.setTitle(numberFormatter.string(from: number), for: .normal)
        } else {
            button.setTitle("", for: .normal)
        }
        button.addTarget(self, action: #selector(decimalButtonTapped), for: .touchUpInside)
        self.decimalButton = button
        
        appendView(view: button)
        
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
        let alertController = UIAlertController(title: "Enter Number", message: nil, preferredStyle: .alert)
        
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

            self.decimalButton?.setTitle(text, for: .normal)
            self.delegate?.cellDidChangeValue(self, value: number)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        viewController.present(alertController, animated: true)
    }
}
