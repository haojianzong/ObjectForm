//
//  File.swift
//  
//
//  Created by Jake on 3/2/20.
//

import Foundation

public class TextViewRow: NSObject, BaseRow {

    public lazy var baseCell: FormInputCell = {
        return TextViewInputCell()
    }()

    public var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? String }
    }

    public var title: String?
    public var icon: String?
    public var kvcKey: String?
    public var placeholder: String?

    var value: String?

    public required init(title: String, kvcKey: String, value: String?) {
        super.init()

        self.title = title
        self.kvcKey = kvcKey
        self.value = value
        self.placeholder = nil
    }
}
