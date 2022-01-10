//
//  PerDayHeaderAreaView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 25.12.2021.
//

import UIKit

class PerDayHeaderAreaView : UIView
{
    @objc
    private func detailsTappedHandler()
    {
        print("details tapped")
    }
    
    private let collectionViewLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.text = "Ежедневный прогноз"
        view.textAlignment = .left
        return view
    }()
    
    private lazy var detailsViewLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "25 дней", attributes: underlineAttribute)
        view.attributedText = underlineAttributedString
        view.font = UIFont.systemFont(ofSize: 16)
        view.textAlignment = .right
        view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(detailsTappedHandler))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private func setupLayout()
    {
        addSubview(collectionViewLabel)
        addSubview(detailsViewLabel)
        
        let constraints = [
            collectionViewLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            collectionViewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionViewLabel.widthAnchor.constraint(equalToConstant: 200),
            collectionViewLabel.heightAnchor.constraint(equalToConstant: 22),
            
            detailsViewLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            detailsViewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            detailsViewLabel.widthAnchor.constraint(equalToConstant: 83),
            detailsViewLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupViews()
    {
        self.backgroundColor = .white
        
        setupLayout()
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for PerDayHeaderAreaView")
    }
}
