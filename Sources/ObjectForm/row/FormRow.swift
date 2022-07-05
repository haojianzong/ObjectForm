//
//  FormRow.swift
//  Mocha
//
//  Created by Jake on 2/23/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

public protocol Taggable: AnyObject {
    var kvcKey: String? { get set }
}

public protocol BaseRow : NSObject, Taggable {
    var title: String? { get set }
    var icon: String? { get set }

    // Update object properties using the key with key-value-coding
    var kvcKey: String? { get set }

    var placeholder: String? { get set }

    var baseCell: FormInputCell { get set }
    var baseValue: CustomStringConvertible? { get set }
}
