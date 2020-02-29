<p>
<img src="test"/>
</p>

FormKit
=======

A simple yet powerful component to build form for your class models.

## Motivations

I found most form libraries for swift are too complicated to bootstrap a simple project. So I write FormKit to make it dead simple to build forms for any model class.

By design, FormKit is minimalist, easy to extend and works well with your UIKit projects.

This project has no depenency of any other library.

## Featuers
- Bind class model variables to form rows
- Different keyboard for different variable types
- Type safe
- Form validation
- Fully customizable form rows

## Available Rows & Cells

### Rows

- StringRow: Row to support string input, full keyboard
- DoubleRow: Row to support number input, numeric keyboard
- DateRow: Row to bind Date value

### Cells

- TextViewInputCell: text input cell
- SelectInputCell: support selection, provided by `CollectionPicker`
- TextViewVC: A view controller with UITextView to input long text
- ButtonCell: Show a button in the form
- TypedInputCell: Generic cell to support type binding
- FormInputCell: The base for all cells

## Usage

You can follow the example in `FormKitExample` to learn how to build a simplke form with a class model. 

### Binding a Model to a Form

```swift
class FruitFormData: NSObject, FormDataSource {
      // Bind your custom model
      typealias BindModel = Fruit
      var basicRows: [BaseRow] = []

      func numberOfSections() -> Int {

      ...
      self.bindModel = fruit

      basicRows.append(StringRow(title: "Name",
                                 icon: "",
                                 updateTag: "name",
                                 value: fruit.name ?? "",
                                 placeholder: nil,
                                 validation: nil))

      // Row are type safe
      basicRows.append(DoubleRow(title: "Price",
                                 icon: "",
                                 updateTag: "price",
                                 value: fruit.price,
                                 placeholder: "",
                                 validation: nil))

      // You can make as many rows as needed
      basicRows.append(TextViewRow(title: "Note",
                                   updateTag: "note",
                                   value: fruit.note ?? "-"))

  }
}
```

### Use FormDataSource in a UITableView

```swift

class FruitFormVC: UIViewController {
  private let dataSource: FruitFormData
}

extension FruitFormVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.numberOfRows(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = dataSource.row(at: indexPath)
        row.baseCell.setup(row)
        row.baseCell.delegate = self
        return row.baseCell
    }
}

extension FruitFormVC: FormCellDelegate {
    func cellDidChangeValue(_ cell: UITableViewCell, value: Any?) {
        let indexPath = tableView.indexPath(for: cell)!
        _ = dataSource.updateItem(at: indexPath, value: value)
    }
}

```

License
-------
	Copyright (C) 2020 Jake Hao

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
