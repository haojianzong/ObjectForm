//
//  File.swift
//  
//
//  Created by Jake on 3/2/20.
//

import Foundation

public class TextViewRow: BaseRow {

    public override var baseCell: FormInputCell {
        return cell
    }

    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? String }
    }

    var value: String?

    public var cell: TextViewInputCell

    public override var description: String {
        return "<TextViewRow> \(title ?? "")"
    }

    override func isValueMatchRowType(value: Any) -> Bool {
        let t = type(of: value)
        return String.self == t
    }

    public required init(title: String, kvcKey: String, value: String?) {
        self.cell = TextViewInputCell()

        super.init()

        self.title = title
        self.kvcKey = kvcKey
        self.value = value
        self.placeholder = nil
    }
}
