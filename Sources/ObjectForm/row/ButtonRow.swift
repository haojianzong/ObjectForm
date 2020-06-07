//
//  File.swift
//  
//
//  Created by Jake on 3/2/20.
//

import Foundation
import UIKit

/// Model for a row that is a button
public class ButtonRow: BaseRow {

    public override var baseValue: CustomStringConvertible? {
        get { return nil }
        set { }
    }

    public override var baseCell: FormInputCell {
        return cell
    }

    var cell: ButtonCell

    public let actionTag: String
    public let image: UIImage
    public let tintColor: UIColor

    public override var description: String {
        return "<ButtonRow> \(title ?? "")"
    }

    public required init(title: String, image: UIImage, tintColor: UIColor, actionTag: String) {
        self.actionTag = actionTag
        self.image = image
        self.tintColor = tintColor

        self.cell = ButtonCell()

        super.init()
        self.title = title

        self.kvcKey = nil
        self.placeholder = nil
    }
}
