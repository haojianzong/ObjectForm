//
//  SettingVC.swift
//  Mocha
//
//  Created by Jake on 3/17/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

public typealias PickerCompletionHandler = (_ selectedIndex: Int) -> Void

protocol CollectionPicker {
    init(collection: [Any], completionHandler: @escaping PickerCompletionHandler)
}

// A selection picker implemented with UITableView
public class TableCollectionPicker: UIViewController, CollectionPicker {

    public var selectedRow: Int? {
        didSet {
            tableView.reloadData()
        }
    }

    private struct Constants {
        static let CellIdentifier = "CellIdentifier"
    }

    private var tableView: UITableView = {
        let view: UITableView
        if #available(iOS 13, *) {
            view = UITableView(frame: .zero, style: .insetGrouped)
        }
        else
        {
            view = UITableView(frame: .zero)
        }
        return view
    }()

    private var completionHandler: PickerCompletionHandler?
    private var collection: [Any]

    public required init(collection: [Any], completionHandler: @escaping PickerCompletionHandler) {
        self.completionHandler = completionHandler
        self.collection = collection
        super.init(nibName: nil, bundle: nil)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier)

        tableView.allowsMultipleSelection = false

        view.addSubview(tableView)
        tableView.pinEdges(to: view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}

extension TableCollectionPicker: UITableViewDataSource, UITableViewDelegate {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier)!
        cell.textLabel?.text = String(describing: collection[indexPath.row])

        if let selectedRow = selectedRow,
            selectedRow == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        completionHandler?(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
