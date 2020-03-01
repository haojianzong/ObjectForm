//
//  AccountForm+UITableVIew.swift
//  Mocha
//
//  Created by Jake on 6/16/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import ObjectForm
import UIKit

class FruitFormData: NSObject, FormDataSource {
    typealias BindModel = Fruit

    var basicRows: [BaseRow] = []

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(at section: Int) -> Int {
        switch section {
        case 0: return basicRows.count
        default: fatalError()
        }
    }

    func row(at indexPath: IndexPath) -> BaseRow {
        switch indexPath.section {
        case 0: return basicRows[indexPath.row]
        default: fatalError()
        }
    }

    var bindModel: Fruit

    init(_ fruit: Fruit) {
        self.bindModel = fruit

        basicRows.append(StringRow(title: "Name",
                                   icon: "",
                                   updateTag: "name",
                                   value: fruit.name ?? "",
                                   placeholder: nil,
                                   validator: {
                                    return !(fruit.name?.isEmpty ?? true)

        }))

        basicRows.append(DoubleRow(title: "Price",
                                   icon: "",
                                   updateTag: "price",
                                   value: fruit.price,
                                   placeholder: ""))

        basicRows.append(DoubleRow(title: "Weight",
                                   icon: "",
                                   updateTag: "weight",
                                   value: fruit.weight,
                                   placeholder: ""))

        basicRows.append(TextViewRow(title: "Note",
                                     updateTag: "note",
                                     value: fruit.note ?? "-"))

        basicRows.append(SelectRow(title: "Retailer",
                                   icon: "",
                                   updateTag: "retailer",
                                   value: fruit.retailer,
                                     listOfValues: ["Walmart", "McDonald", "Carrefour"]))
    }

    override init() { fatalError("not implemented") }
}
