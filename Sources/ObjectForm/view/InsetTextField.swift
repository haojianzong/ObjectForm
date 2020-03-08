//
//  File.swift
//  
//
//  Created by Jake on 3/8/20.
//

import Foundation
import UIKit

class InsetTextField: UITextField {

    @IBInspectable var inset: CGPoint = .zero

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset.x, dy: inset.y)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

}
