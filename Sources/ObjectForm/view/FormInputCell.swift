//
//  FormInputCell.swift
//  Mocha
//
//  Created by Jake on 1/29/20.
//  Copyright © 2020 Mocha. All rights reserved.
//

import Foundation
import UIKit

public protocol FormCellDelegate: AnyObject {
    // Notify that the cell's value has been changed
    func cellDidChangeValue(_ cell: UITableViewCell, value: Any?)
}

// Define common styles & validation
public class FormInputCell: UITableViewCell {

    static let identifier = "FormInputCell"

    public weak var delegate: FormCellDelegate?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 17.0)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 17.0)
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let hStack = UIStackView(arrangedSubviews: [titleLabel, textField])
        contentView.addSubview(hStack)
        hStack.setCustomSpacing(16.0, after: titleLabel)
        hStack.setCustomSpacing(8.0, after: textField)
        hStack.pinMargins(to: contentView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup(_ row: BaseRow) {
        fatalError("Subclass must override")
    }
}
