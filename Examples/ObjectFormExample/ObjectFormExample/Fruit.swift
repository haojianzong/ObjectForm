//
//  Fruit.swift
//  ObjectFormExample
//
//  Created by Jake on 2/29/20.
//  Copyright © 2020 Jake. All rights reserved.
//

import Foundation

@objc class Fruit: NSObject {
    @objc dynamic var name: String?
    @objc dynamic var price: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var retailer: String?
    @objc dynamic var note: String?
    @objc dynamic var date: Date?

    convenience init(name: String?, price: Double, weight: Double, retailer: String?, note: String?, date: Date? = Date()) {
        self.init()
        self.name = name
        self.price = price
        self.weight = weight
        self.retailer = retailer
        self.note = note
    }
}
