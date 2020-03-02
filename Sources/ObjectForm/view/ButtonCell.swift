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
        titleLabel.text = row.title
        titleLabel.textColor = .blue
    }

}
