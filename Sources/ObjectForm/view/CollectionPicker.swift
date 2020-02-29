//
//  SettingVC.swift
//  Mocha
//
//  Created by Jake on 3/17/19.
//  Copyright © 2019 Mocha. All rights reserved.
//

import Foundation
import UIKit

public typealias PickerCompletionBlock = (_ selectedIndex: Int) -> Void

protocol CollectionPicker {
    init(collection: [Any], completionCallback:@escaping PickerCompletionBlock)
}

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
        let view = UITableView(frame: .zero)
        return view
    }()

    private var completionCallback: PickerCompletionBlock?
    private var collection: [Any]

    public required init(collection: [Any], completionCallback: @escaping PickerCompletionBlock) {
        self.completionCallback = completionCallback
        self.collection = collection
        super.init(nibName: nil, bundle: nil)
        title = "设置"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier)

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
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completionCallback?(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
