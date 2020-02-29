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

class TextViewVC: UIViewController {

    let textView = UITextView()

//    private let placeholderText = "在此写下账户备注"

    weak var delegate: TextViewVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

        view.backgroundColor = .systemBackground

        textView.font = .systemFont(ofSize: 18.0)
//        textView.delegate = self

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
//
//extension TextViewVC: UITextViewDelegate {
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == placeholderText {
//            textView.text = ""
//        }
//    }
//
//}
