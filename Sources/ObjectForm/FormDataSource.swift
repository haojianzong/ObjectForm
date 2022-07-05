//
//  AccountFormData.swift
//  Mocha
//
//  Created by Jake on 2/20/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

/// Bind model for the form
public protocol Bindable {
    associatedtype BindModel: NSObject
    var bindModel: BindModel { set get }
}

/// Conform to feed UITableView with editable rows
public protocol FormDataSource: Bindable {
    func numberOfSections() -> Int
    func numberOfRows(at section: Int) -> Int
    func row(at indexPath: IndexPath) -> any BaseRow

    func updateItem(at indexPath: IndexPath, value: Any?) -> Bool
}

extension FormDataSource {

    public func updateItem(at indexPath: IndexPath, value: Any?) -> Bool {
        let currentRow = row(at: indexPath)
        guard let keyPath = currentRow.kvcKey else {
            assertionFailure("Row keyPath should not be empty")
            return false
        }
        // TODO: Check type
//        guard checkTypeMatch(row: currentRow, value: value) else {
//            assertionFailure("Type for value and cell must match")
//            return false
//        }
        bindModel.setValue(value, forKeyPath: keyPath)
        return true
    }

}
