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

    public var title: String?
    public var icon: String?
    public var kvcKey: String?
    public var placeholder: String?

    public var value: String

    public required init(title: String, kvcKey: String, value: String) {
        self.value = value
        super.init()

        self.title = title
        self.kvcKey = kvcKey
        self.placeholder = nil
    }
}
