<p>
<img src="https://github.com/haojianzong/FormKit/blob/master/banner.png?raw=true"/>
</p>

FormKit
=======

A simple yet powerful library to build form for your class models.

## Motivations

I found most form libraries for swift are too complicated to bootstrap a simple project. So I write FormKit to make it dead simple for building forms and binding model classes.

FormKit doesn't fight with you to write UIKit code. By design, it is simple to understand and extend. If you follow the example project carefully, you would find it easy to fit in your Swift project.

This project has no depenency of any other library.

## Features
- Bind class model to form rows
- Work well with UITableView
- Customize keyboards according to model types
- Type safe
- Form validation is supported
- A list of Built-in UITableViewCell to support multiple types 

## Available Rows & Cells

### Rows

- `StringRow`: Row to support string input, full keyboard
- `DoubleRow`: Row to support number input, numeric keyboard
- `DateRow`: Row to bind Date value

### Cells

- `TextViewInputCell`: text input cell
- `SelectInputCell`: support selection, provided by `CollectionPicker`
- `TextViewVC`: A view controller with UITextView to input long text
- `ButtonCell`: Show a button in the form
- `TypedInputCell`: Generic cell to support type binding
- `FormInputCell`: The base class for all cells

## Usage

You can follow the example in `FormKitExample` to learn how to build a simplke form with a class model. 

### Binding Model to Form

```swift
class FruitFormData: NSObject, FormDataSource {
      // Bind your custom model
      typealias BindModel = Fruit
      var basicRows: [BaseRow] = []

      func numberOfSections() -> Int {...}
      func numberOfRows(at section: Int) -> Int {...}
      func row(at indexPath: IndexPath) -> BaseRow {...}

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

      // You can build as many rows as you want
      basicRows.append(TextViewRow(title: "Note",
                                   updateTag: "note",
                                   value: fruit.note ?? "-"))

  }
}
```

### Showing FormDataSource in a UITableView

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

```

### Listening to Cell Value Change

```swift
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
