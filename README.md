![](https://github.com/haojianzong/ObjectForm/blob/develop/banner.png?raw=true)

[![ObjectForm](https://github.com/haojianzong/ObjectForm/workflows/ObjectForm/badge.svg)](https://github.com/haojianzong/ObjectForm/actions?query=workflow%3AObjectForm)

ObjectForm
=======

A simple yet powerful library to build form for your class models.

<img width="200" src="https://github.com/haojianzong/ObjectForm/blob/develop/demo.gif?raw=true" />

## Motivations

I found most form libraries for swift are too complicated to bootstrap a simple project. So I write ObjectForm to make it dead simple for building forms and binding model classes.

ObjectForm doesn't fight with you to write UIKit code. By design, it is simple to understand and extend. If you follow the example project carefully, you would find it easy to fit in your Swift project.

This project has no dependency of any other library.

Application
=======

In my application ([a personal finance app](https://xxz.jakehao.com)), I use ObjectForm to make forms for multiple classes as well as different variants for the same class, which saves me from writing duplicate code.

![](https://github.com/haojianzong/ObjectForm/blob/develop/application.jpg?raw=true")

## Features

- Bind class model to form rows
- Automatic keyboards types according to model types
- Form rows are type safe
- Fully customizable form validation rules
- A list of built-in UITableViewCell to support multiple types
- Work amazingly well with your UITableView code

## Requirements

- iOS >= 11.0

## Usage

1. Copy sources
  - Copy files under [/Sources](https://github.com/haojianzong/ObjectForm/tree/develop/Sources/ObjectForm) into your project.
2. Carthage (Coming soon)
3. [Swift Package Manager](https://swift.org/package-manager/)
  - Click "Files -> Swift Package Manager -> Add Package Dependency..." in Xcode's menu
  - Search "https://github.com/haojianzong/ObjectForm".
  - Select "master" branch or input "Next major version"

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


### Tutorials

You can follow [ObjectFormExample](https://github.com/haojianzong/ObjectForm/tree/develop/Examples/ObjectFormExample) in `ObjectFormExample` to learn how to build a simple form with a class model. 

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
                                 kvcKey: "name",
                                 value: fruit.name ?? "",
                                 placeholder: nil,
                                 validator: nil))

      // Row are type safe
      basicRows.append(DoubleRow(title: "Price",
                                 icon: "",
                                 kvcKey: "price",
                                 value: fruit.price,
                                 placeholder: "",
                                 validator: nil))

      // You can build as many rows as you want
      basicRows.append(TextViewRow(title: "Note",
                                   kvcKey: "note",
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

### Data Validation

By providing a validation block when building a row, you can provide any validaiton rules.

<img width="300" src="https://github.com/haojianzong/ObjectForm/blob/develop/validation.gif?raw=true" />

```swift
basicRows.append(StringRow(title: "Name",
                           icon: "",
                           kvcKey: "name",
                           value: fruit.name ?? "",
                           placeholder: nil,
                           validator: {
                           // Custom rules for row validation
                            return !(fruit.name?.isEmpty ?? true)

}))
```

```swift
@objc private func saveButtonTapped() {
    guard dataSource.validateData() else {
        tableView.reloadData()
        return
    }

    navigationController?.popViewController(animated: true)
}
```

### Row Type Safety

Since a form row use key-value-coding to update its bind model, it is important to keep the row value type the same as the object's variable type. ObjectForm enforces type safe. Every row must implement the following method:

  override func isValueMatchRowType(value: Any) -> Bool

This is already implemented by built-in generic rows, for example, `TypedRow<T>` and `SelectRow<T>`.

### Make Your Own Row

Making your own row and cell is easy. You have 2 options:

1. Create concrete type using `TypedRow`

```swift
typealias StringRow = TypedRow<String>
```

2. Subclass `BaseRow`

```swift
class TextViewRow: BaseRow {

    public override var baseCell: FormInputCell {
        return cell
    }

    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? String }
    }

    var value: String?

    var cell: TextViewInputCell

    override func isValueMatchRowType(value: Any) -> Bool {
        let t = type(of: value)
        return String.self == t
    }

    override var description: String {
        return "<TextViewRow> \(title ?? "")"
    }

    required init(title: String, kvcKey: String, value: String?) {
        self.cell = TextViewInputCell()

        super.init()

        self.title = title
        self.kvcKey = kvcKey
        self.value = value
        self.placeholder = nil
    }
}
```
