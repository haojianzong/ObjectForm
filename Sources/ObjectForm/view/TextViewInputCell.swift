//
//  TextViewInputCell.swift
//  Mocha
//
//  Created by Jake on 1/29/20.
//  Copyright © 2020 Mocha. All rights reserved.
//

import Foundation
import UIKit

open class TextViewInputCell: FormInputCell {

    private let textViewVC = TextViewVC()

    private var textViewRow: TextViewRow?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textField.isUserInteractionEnabled = false
        accessoryType = .disclosureIndicator

        textViewVC.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func showTextView(in vc: UIViewController) {
        textViewVC.textView.text = textViewRow?.value
        vc.navigationController?.pushViewController(textViewVC, animated: true)
    }

    public override func setup(_ row: BaseRow) {
        guard let row = row as? TextViewRow else {
            assertionFailure("Row type must match cell type")
            return
        }

        self.textViewRow = row

        titleLabel.text = row.title
        textField.text = row.value
    }
}

extension TextViewInputCell: TextViewVCDelegate {
    func textViewVCDidSave(_ textViewVC: TextViewVC, with value: String) {
        textField.text = value
        textViewRow?.value = value
        delegate?.cellDidChangeValue(self, value: value)
    }
}
