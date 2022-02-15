//
//  LoginView.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//

import UIKit

class LoginView : UIView {
    var loginClickHandler : LoginClickHandler?
    
    @objc
    private func loginClickInternalHandler()
    {
        loginClickHandler?(self.passwordTextField.text ?? "")
        self.passwordTextField.text = ""
    }
    
    private let viewLabel : UILabel = {
        let view = UILabel()
        view.text = "Login"
        view.numberOfLines = 1
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: AppLayoutSettings.loginLabelFontSize)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.textAlignment = .center
        return view
    }()
    
    private let passwordTextField : UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = AppLayoutSettings.passwordTextInputCornerRadius
        view.placeholder = "type password here"
        view.isSecureTextEntry = true
        let paddingView = UIView(frame: CGRect(x : 0, y : 0,
                                               width : AppLayoutSettings.passwordTextInputLeftPadding,
                                               height : view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        view.backgroundColor = .lightGray

        return view
    }()
    
    private let loginButton : UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(loginClickInternalHandler), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Create password", for: .normal)
        view.backgroundColor = .systemBlue
        view.tintColor = .white
        view.layer.cornerRadius = AppLayoutSettings.passwordButtonCorderRadius
        return view
    }()
    
    
    func setLoginButtonTitle(title : String)
    {
        loginButton.setTitle(title, for: .normal)
    }
    
    private func addSubviews()
    {
        addSubview(viewLabel)
        addSubview(passwordTextField)
        addSubview(loginButton)
    }
    
    private func setupViews()
    {
        self.backgroundColor = .white
        
        addSubviews()
        
        let itemsYOffset = self.bounds.height*AppLayoutSettings.topBottomLayoutOffsetInPercentage
        
        let itemsXOffset = self.bounds.width*AppLayoutSettings.leftMarginLayoutOffsetInPercentage
        
        let constraints = [
            viewLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -itemsYOffset),
            
            
            passwordTextField.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: itemsYOffset/2),
            passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: itemsXOffset),
            passwordTextField.heightAnchor.constraint(equalToConstant: itemsYOffset/2),

            passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -itemsXOffset),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: itemsYOffset/2),
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
        
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented for LoginView")
    }
}

