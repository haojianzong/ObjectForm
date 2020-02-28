//
//  FruitFormVC.swift
//  Mocha
//
//  Created by Jake on 2/12/20.
//  Copyright © 2020 Mocha. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FruitFormVC: UIViewController {

    private var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.rowHeight = UITableView.automaticDimension
        view.keyboardDismissMode = .onDrag
        return view
    }()

    private let dataSource: FruitFormData

    init(_ fruit: Fruit) {
        dataSource = FruitFormData(fruit)

        super.init(nibName: nil, bundle: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }

    private func dismiss() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc private func saveButtonTapped() {
        // Do nothing
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implementef")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self

        view.addSubview(tableView)
        tableView.pinEdges(to: view)
    }
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
