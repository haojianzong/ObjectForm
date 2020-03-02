//
//  FormRow.swift
//  Mocha
//
//  Created by Jake on 2/23/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

protocol Taggable: AnyObject {
    var kvcKey: String? { get set }
}

public class BaseRow : NSObject, Taggable {
    public typealias Validator = (() -> Bool)

    var title: String?
    var icon: String?

    // Update object properties using the key with key-value-coding
    var kvcKey: String?

    var placeholder: String?
    var validator: Validator?
    var validationFailed: Bool?

    public var baseCell: FormInputCell {
        fatalError("Subclass should override")
    }

    public var baseValue: CustomStringConvertible? {
        set { fatalError("Subclass should override") }
        get { fatalError("Subclass should override") }
    }

    // Used to check type when updating object's value with key `-value-coding
    func isValueMatchRowType(value: Any) -> Bool {
        fatalError("Subclass must override")
    }
}
