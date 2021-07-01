//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Дмитрий Никишов on 29.06.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    private let leftOffset : CGFloat = 16
    private let topOffset : CGFloat = 16
    private let statusLblHeight : CGFloat = 50
    private var statusText : String = ""
    
    private var avatarImage: UIImageView = {
//        var image : UIImage = UIImage(systemName: "face.smiling")!
        var image : UIImage = UIImage(named: "Avatar")!
        let avatar = UIImageView(image : image)
        avatar.layer.cornerRadius = 8.0
        avatar.clipsToBounds = true
        avatar.layer.borderWidth = 3
        avatar.layer.borderColor = UIColor.white.cgColor

        return avatar
    }()
        
    private var statusLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Waiting for something"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = .gray
        return lbl
    }()
    
    private var avatarLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Hipster Pinguin"
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        return lbl
    }()
    
    private var showStatusButton : UIButton = {
        let button = UIButton()
        button.setTitle("Show status", for: .normal)
        button.setTitleColor(.white, for : .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 14
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        return button
    }()
    
    private var inputTextField : TextFieldWithPadding = {
        let fld = TextFieldWithPadding()
        fld.placeholder = "add smth to show as status"
        fld.layer.cornerRadius = 12
        fld.layer.borderWidth = 1
        fld.layer.borderColor = UIColor.black.cgColor
        fld.backgroundColor = .white
        fld.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        fld.textColor = .black
        return fld
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(avatarImage)
        addSubview(statusLabel)
        addSubview(showStatusButton)
        addSubview(avatarLabel)
        addSubview(inputTextField)
        
        showStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        inputTextField.addTarget(self, action: #selector(statusTextChanged), for : .editingChanged)
    }
    
    @objc func buttonPressed()
    {
        statusLabel.text = statusText
//        print(statusLabel.text ?? "")
    }
    
    @objc func statusTextChanged(_ textField: UITextField)
    {
        statusText = textField.text ?? ""
    }
    
    override func layoutSubviews() {
        avatarImage.frame = CGRect(x : leftOffset,
                                   y : self.safeAreaInsets.top + topOffset,
                                   width : 100,
                                   height: 100)
        
        avatarImage.layer.cornerRadius = avatarImage.bounds.height/2
        
        showStatusButton.frame = CGRect(x : leftOffset,
                                        y : self.safeAreaInsets.top + topOffset + avatarImage.frame.height + topOffset,
                                        width : UIScreen.main.bounds.width - 2*leftOffset,
                                        height : 50)

        
        statusLabel.frame = CGRect(x : leftOffset + avatarImage.frame.width + leftOffset,
                             y : showStatusButton.frame.minY - 34 - statusLblHeight,
                             width : UIScreen.main.bounds.width - 2*leftOffset - avatarImage.frame.width - leftOffset,
                             height: statusLblHeight)
        
        
        avatarLabel.frame = CGRect(x : statusLabel.frame.minX,
                                   y : self.safeAreaInsets.top + 27,
                                   width : statusLabel.frame.width,
                                   height : statusLabel.frame.height)
        
        inputTextField.frame = CGRect( x : statusLabel.frame.minX,
                                       y : showStatusButton.frame.minY - 40 - 5,
                                       width : statusLabel.frame.width,
                                       height : 40)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
