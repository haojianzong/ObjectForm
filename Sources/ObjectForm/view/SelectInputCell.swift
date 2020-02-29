//
//  TextViewInputCell.swift
//  Mocha
//
//  Created by Jake on 1/29/20.
//  Copyright © 2020 Mocha. All rights reserved.
//

import Foundation
import UIKit

protocol SelectCellOutputible {
    // Output value is used to update the model
    var outputValue: Any? { get }
}

extension String: SelectCellOutputible {
    var outputValue: Any? {
        return self
    }
}

class SelectInputCell<T: SelectRowConvertible>: FormInputCell {
    
    typealias ValueChangedBlock = ((T) -> Void)

    private var collectionPicker: TableCollectionPicker?

    private var listOfValues: [T]?

    private var valueChangeBlock: SelectRow<T>.ValueChangedBlock?

    convenience init(listOfValues: [T], valueChangeBlock: SelectRow<T>.ValueChangedBlock?) {
        self.init(style: .default, reuseIdentifier: "InputCellIdentifier")
        self.listOfValues = listOfValues

        self.collectionPicker = TableCollectionPicker(collection: listOfValues, completionCallback: { [weak self] pickedIndex in
            guard let self = self else { return }
            self.textField.text = String(describing: listOfValues[pickedIndex])
            self.delegate?.cellDidChangeValue(self, value: listOfValues[pickedIndex].outputValue)

            valueChangeBlock?(listOfValues[pickedIndex])
        })

        textField.isUserInteractionEnabled = false
        accessoryType = .disclosureIndicator
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textField.isUserInteractionEnabled = false
        accessoryType = .disclosureIndicator
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showPicker(in vc: UIViewController) {
        if let collectionPicker = collectionPicker {
            vc.navigationController?.pushViewController(collectionPicker, animated: true)
        }
    }

    override func setup(_ row: BaseRow) {
        guard let row = row as? SelectRow<T> else {
            assertionFailure("Row type must match cell type")
            return
        }

        titleLabel.text = row.title
        textField.text = row.value?.description

        if let value = row.value,
            let index = self.listOfValues?.firstIndex(of: value) {
            self.collectionPicker?.selectedRow = index
        }
    }
}
