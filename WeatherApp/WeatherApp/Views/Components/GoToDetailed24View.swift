//
//  GoToDetailed24View.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 23.12.2021.
//

import UIKit

class GoToDetailed24View : UIView {
    
    @objc
    private func clickHandler()
    {
        print("tapped")
    }
    
    private lazy var gotoLabel : UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 16)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Подробнее на 24 часа", attributes: underlineAttribute)
        view.attributedText = underlineAttributedString
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        let clickEvent = UITapGestureRecognizer()
        clickEvent.addTarget(self, action: #selector(clickHandler))
        
        view.addGestureRecognizer(clickEvent)
        return view
    }()
    
    private func setupViews()
    {
        self.addSubview(gotoLabel)
        
        let constraints = [
            gotoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            gotoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for GoToDetailed24View")
    }
}
