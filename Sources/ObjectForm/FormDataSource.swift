//
//  AccountFormData.swift
//  Mocha
//
//  Created by Jake on 2/20/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

/// bind/get model for the form
public protocol Bindable {
    associatedtype BindModel: NSObject
    var bindModel: BindModel { set get }
}

/// Conform to feed UITableView with editable rows
public protocol FormDataSource: Bindable {
    func numberOfSections() -> Int
    func numberOfRows(at section: Int) -> Int
    func row(at indexPath: IndexPath) -> BaseRow

    func updateItem(at indexPath: IndexPath, value: Any?) -> Bool

    func validateData() -> Bool
}

extension FormDataSource {

    /// TODO: refactor updateItem and save as protocol method with default implementations
    public func updateItem(at indexPath: IndexPath, value: Any?) -> Bool {
        let currentRow = row(at: indexPath)
        guard let keyPath = currentRow.updateTag else {
            assertionFailure("Row keyPath should not be empty")
            return false
        }
        guard checkTypeMatch(row: currentRow, value: value) else {
            assertionFailure("Type for value and cell must match")
            return false
        }
        bindModel.setValue(value, forKeyPath: keyPath)
        return true
    }

    private func checkTypeMatch(row: BaseRow, value: Any?) -> Bool {
        guard let value = value else { return true }
        switch row {
        case is StringRow: return (value is String)
        case is DoubleRow: return (value is Double)
        case is DateRow: return (value is Date)
        case is SelectRow<String>: return (value is String)
        case is TextViewRow: return (value is String)
        default: return false
        }
    }

    public func validateData() -> Bool {
        var isValid = true

        for section in 0..<numberOfSections() {
            for rowIndex in 0..<numberOfRows(at: section) {
                let currentRow = row(at: IndexPath(row: rowIndex, section: section))

                if let validation = currentRow.validation, validation() == false {
                    isValid = false
                    currentRow.validationFailed = true
                }
            }
        }

        return isValid
    }
}

