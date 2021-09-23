//
//  CustomButton.swift
//  vk
//
//  Created by Дмитрий Никишов on 20.09.2021.
//

import UIKit

class CustomButton {
    private let button : UIButton
    
    public var clickHandler : UiViewClickHandler?
    
    init() {
        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonClickHandler), for: .touchUpInside)
    }
    
    convenience init(title : String, titleColor : UIColor?) {
        self.init()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
    }
        
    public func setBackgroundImage(image : UIImage?) {
        button.setBackgroundImage(image, for: .normal)
    }
    
    public func setBackgroundColor(color : UIColor?)
    {
        button.backgroundColor = color
    }
    
    public func setIsHiddenState(isHidden : Bool)
    {
        button.isHidden = isHidden
    }
    
    public func getInternalUi() -> UIButton {
        return button
    }
    
    @objc private func buttonClickHandler()
    {
        clickHandler?()
    }
}
