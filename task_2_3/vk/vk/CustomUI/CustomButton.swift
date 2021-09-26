//
//  CustomButton.swift
//  vk
//
//  Created by Дмитрий Никишов on 20.09.2021.
//

import UIKit

class CustomButton : UIButton {
    public var clickHandler : UiViewClickHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action: #selector(buttonClickHandler), for: .touchUpInside)
    }
    
    convenience init(frame: CGRect, title : String, titleColor : UIColor?) {
        self.init(frame : frame)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonClickHandler()
    {
        clickHandler?()
    }
}
