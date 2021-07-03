//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Дмитрий Никишов on 29.06.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    private var statusText : String = ""
        
    @IBOutlet weak var fullNameLabel: UILabel! {
        didSet {
            fullNameLabel.text = "Hipster Pinguin"
            fullNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            fullNameLabel.textColor = .black
        }
    }
    
    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            let image : UIImage = UIImage(named: "Avatar")!
            avatarImage.layer.cornerRadius = 8.0
            avatarImage.clipsToBounds = true
            avatarImage.layer.borderWidth = 3
            avatarImage.layer.borderColor = UIColor.white.cgColor
            avatarImage.image = image
            avatarImage.contentMode = .scaleAspectFill
            avatarImage.layer.cornerRadius = avatarImage.bounds.height/2
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.text = "Waiting for something"
            statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            statusLabel.textColor = .gray
        }
    }
    
    @IBOutlet weak var statusTextField: UITextField! {
        didSet {
            statusTextField.placeholder = "add smth to show as status"
            statusTextField.layer.cornerRadius = 12
            statusTextField.layer.borderWidth = 1
            statusTextField.layer.borderColor = UIColor.black.cgColor
            statusTextField.backgroundColor = .white
            statusTextField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            statusTextField.textColor = .black
            statusTextField.backgroundColor = .white.withAlphaComponent(0)
            statusTextField.addTarget(self, action: #selector(statusTextChanged), for : .editingChanged)
        }
    }
    
    @IBOutlet weak var setStatusButton: UIButton! {
        didSet {
            setStatusButton.setTitle("Show status", for: .normal)
            setStatusButton.setTitleColor(.white, for : .normal)
            setStatusButton.backgroundColor = .blue
            setStatusButton.layer.cornerRadius = 14
            setStatusButton.layer.shadowRadius = 4
            setStatusButton.layer.shadowColor = UIColor.black.cgColor
            setStatusButton.layer.shadowOpacity = 0.7
            setStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
            setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
    }
    
    @objc func buttonPressed()
    {
        statusLabel.text = statusText
    }
    
    @objc func statusTextChanged(_ textField: UITextField)
    {
        statusText = textField.text ?? ""
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
