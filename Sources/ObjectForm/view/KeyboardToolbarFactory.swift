import UIKit

struct KeyboardToolbarFactory {
    static func factoryKeyboardButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.bordered()
        config.attributedTitle = AttributedString(title, attributes: {
            var container = AttributeContainer()
            container.font = .systemFont(ofSize: 17.0, weight: .medium)
            return container
        }())
        config.baseForegroundColor = .label
        config.baseBackgroundColor = Self.keyboardToolbarButtonBackground
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 1.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.configuration = config
        return button
    }

    static var keyboardToolbarButtonBackground: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return .systemGray2
            } else {
                return .systemBackground
            }
        }
    }

    static func factoryKeyboardToolbar(leadingButtonList: [UIBarButtonItem], trailingButtonList: [UIBarButtonItem]? = nil) -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        var buttonItemList = leadingButtonList
        buttonItemList.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        if let trailingButtonList {
            buttonItemList.append(contentsOf: trailingButtonList)
        }
        toolbar.setItems(buttonItemList, animated: true)
        return toolbar
    }
} 
