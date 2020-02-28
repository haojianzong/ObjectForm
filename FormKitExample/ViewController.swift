//
//  ViewController.swift
//  FormKitExample
//
//  Created by Jake on 2/29/20.
//  Copyright © 2020 Jake. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var fruitList = [
        Fruit(name: "Apple",
              price: 12.0,
              weight: 23.0,
              seller: "Walmart",
              note: "Due soon"),
        Fruit(name: "Banana",
              price: 24.0,
              weight: 100.0,
              seller: "McDonald",
              note: nil),
        Fruit(name: "Peach",
              price: 19.0,
              weight: 72.1,
              seller: "Carrefour",
              note: "Call seller this afternoon"),
        Fruit(name: "Kiwi",
              price: 98.0,
              weight: 33.0,
              seller: "Walmart",
              note: nil),
    ]

    private var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .tertiarySystemBackground
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "Fruit Shop"

        tableView.dataSource = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruitList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = fruitList[indexPath.row].name
        cell.detailTextLabel?.text = String(fruitList[indexPath.row].price ?? 0)
        return cell
    }
}
