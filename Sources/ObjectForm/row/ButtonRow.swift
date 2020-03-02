//
//  File.swift
//  
//
//  Created by Jake on 3/2/20.
//

import Foundation
import UIKit

/// Model for a row that is a button
class ButtonRow: BaseRow {

    public override var baseValue: CustomStringConvertible? {
        get { return nil }
        set { }
    }

    public override var baseCell: FormInputCell {
        return cell
    }

    var cell: ButtonCell

    let actionTag: String

    override var description: String {
        return "<ButtonRow> \(title ?? "")"
    }

    required init(title: String, icon: String, actionTag: String) {
        self.actionTag = actionTag

        self.cell = ButtonCell()

        super.init()
        self.title = title
        self.icon = icon
        self.kvcKey = nil
        self.placeholder = nil
    }
}
