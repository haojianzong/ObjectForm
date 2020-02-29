//
//  layoutUtility.swift
//  zhiwoKit
//
//  Created by Jake on 7/15/19.
//  Copyright © 2019 Jake. All rights reserved.
//

import Foundation
import UIKit

// MARK: - NSLayoutDimension shortcuts
public extension UIView {

    struct PinOptions: OptionSet {

        public let rawValue: Int

        public static let all: PinOptions = [.top, .trailing, .bottom, .leading]

        public static let top = PinOptions(rawValue: 1 << 0)
        public static let trailing = PinOptions(rawValue: 1 << 1)
        public static let bottom = PinOptions(rawValue: 1 << 2)
        public static let leading = PinOptions(rawValue: 1 << 3)

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    /// Add layout constraints. Also sets translatesAutoresizingMaskIntoConstraints to false.
    ///
    /// - Parameters:
    ///   - parentView: parent view
    ///   - edges: choose which edge to add
    func pinEdges(to parentView: UIView, edges: PinOptions = .all) {

        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.leading) {
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        }

        if edges.contains(.trailing) {
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        }

        if edges.contains(.top) {
            topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        }

        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo:parentView.bottomAnchor).isActive = true
        }
    }

    /// Add layout constraints. Also sets translatesAutoresizingMaskIntoConstraints to false.
    ///
    /// - Parameters:
    ///   - parentView: parent view
    ///   - edges: choose which edge to add
    func pinMargins(to parentView: UIView, edges: PinOptions = .all) {

        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.leading) {
            leadingAnchor.constraint(equalTo: parentView.layoutMarginsGuide.leadingAnchor).isActive = true
        }

        if edges.contains(.trailing) {
            trailingAnchor.constraint(equalTo: parentView.layoutMarginsGuide.trailingAnchor).isActive = true
        }

        if edges.contains(.top) {
            topAnchor.constraint(equalTo: parentView.layoutMarginsGuide.topAnchor).isActive = true
        }

        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo:parentView.layoutMarginsGuide.bottomAnchor).isActive = true
        }
    }

}
