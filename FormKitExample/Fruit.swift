//
//  Fruit.swift
//  FormKitExample
//
//  Created by Jake on 2/29/20.
//  Copyright © 2020 Jake. All rights reserved.
//

import Foundation

@objc class Fruit: NSObject {
    var name: String?
    var price: Double?
    var weight: Double?
    var seller: String?
    var note: String?

    convenience init(name: String?, price: Double?, weight: Double?, seller: String?, note: String?) {
        self.init()
        self.name = name
        self.price = price
        self.weight = weight
        self.seller = seller
        self.note = note
    }
}
