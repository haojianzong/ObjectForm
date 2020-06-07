//
//  InputRow.swift
//  Mocha
//
//  Created by Jake on 2/20/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

// A simple button
class ButtonCell: FormInputCell {

    override func setup(_ row: BaseRow) {
        guard let row = row as? ButtonRow else {
            assertionFailure("row type does not match")
            return
        }

        imageView?.image = row.image

        textLabel?.text = row.title
        textLabel?.font = .systemFont(ofSize: 18.0, weight: .medium)
        textLabel?.textColor = row.tintColor

        textField.isUserInteractionEnabled = false
    }

}
