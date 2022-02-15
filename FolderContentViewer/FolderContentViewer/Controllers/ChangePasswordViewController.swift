//
//  ChangePasswordViewController.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 27.11.2021.
//

import UIKit

class ChangePasswordViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        createTheView()
     }

    private let popUpTitle : UILabel = {
        let view = UILabel()
        view.text = "Enter new password"
        view.numberOfLines = 1
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: AppLayoutSettings.enterNewPasswordLabelFontSize)
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
        view.backgroundColor = .systemBlue

        return view
    }()

    @objc
    private func applyButtonClickHandler()
    {
        if let passwordFromUser = passwordTextField.text {
            if passwordFromUser.count >= AppCommonSettings.passwordMinLength {
                AppKeychain.savePassword(password: passwordFromUser)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private let applyButton : UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(applyButtonClickHandler), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Apply", for: .normal)
        view.backgroundColor = .systemBlue
        view.tintColor = .white
        view.layer.cornerRadius = AppLayoutSettings.passwordButtonCorderRadius
        return view
    }()


     private func createTheView() {

         let yCoord = self.view.bounds.height / 2 - 100

         let centeredView = UIView(frame: CGRect(x: 0, y: yCoord, width: self.view.bounds.width, height: 200))
         centeredView.backgroundColor = .lightGray
         
         centeredView.addSubview(popUpTitle)
         centeredView.addSubview(passwordTextField)
         centeredView.addSubview(applyButton)
         
         self.view.addSubview(centeredView)
         
         let constraints = [
            popUpTitle.topAnchor.constraint(equalTo: centeredView.topAnchor, constant: 10),
            popUpTitle.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
            popUpTitle.trailingAnchor.constraint(equalTo: centeredView.trailingAnchor),
            
            passwordTextField.centerXAnchor.constraint(equalTo: centeredView.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: centeredView.centerYAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.9),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            applyButton.bottomAnchor.constraint(equalTo: centeredView.bottomAnchor, constant: -10),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.centerXAnchor.constraint(equalTo: centeredView.centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.9),
         ]
         
         NSLayoutConstraint.activate(constraints)
     }}
