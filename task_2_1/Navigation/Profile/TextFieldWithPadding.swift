//
//  TextFieldWithPadding.swift
//  Navigation
//
//  Created by Дмитрий Никишов on 29.06.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )

        override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
}
