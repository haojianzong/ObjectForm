//
//  TextViewVC.swift
//  Mocha
//
//  Created by Jake on 1/29/20.
//  Copyright © 2020 Mocha. All rights reserved.
//

import Foundation
import UIKit

protocol TextViewVCDelegate: AnyObject {
    func textViewVCDidSave(_ textViewVC: TextViewVC, with value: String)
}

// A simple text view in a viewController that provides full screen text editing
class TextViewVC: UIViewController {

    let textView = UITextView()

    weak var delegate: TextViewVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        textView.font = .systemFont(ofSize: 18.0)

        view.addSubview(textView)
        textView.pinMargins(to: view, edges: [.leading, .trailing, .top])
        textView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    @objc private func saveButtonTapped() {
        delegate?.textViewVCDidSave(self, with: textView.text)
        navigationController?.popViewController(animated: true)
    }

}
