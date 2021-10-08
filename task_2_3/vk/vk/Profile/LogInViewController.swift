//
//  LoginViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 08.07.2021.
//

import UIKit

class LogInViewController: UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private let credentialsCheckerDelegate : CredentialsChecker
    
    init(credentialsChecker : CredentialsChecker) {
        credentialsCheckerDelegate = credentialsChecker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var safeArea : UILayoutGuide!
    
    private let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    private let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let logoView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "logo")
        return view
    }()
    
    private let emailOrPhoneTextFieldView : UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10
        view.placeholder = "Email or phone"
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.textColor = .black
        view.autocapitalizationType = .none
        view.tintColor = UIColor(named: "myColor")
        view.backgroundColor = .systemGray6
        
        return view
    }()
    
    private let passwordTextFieldView : UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10
        view.placeholder = "Password"
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.textColor = .black
        view.autocapitalizationType = .none
        view.tintColor = UIColor(named: "myColor")
        view.isSecureTextEntry = true
        view.backgroundColor = .systemGray6

        return view
    }()
    
    private lazy var logInButton : CustomButton = {
        let button = CustomButton(frame : self.view.frame, title: "Log in", titleColor: .white)
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide

        setupViews()
    }

    
    private func setupViews()
    {
        view.addSubview(scrollView)
        
        containerView.addSubview(logoView)
        containerView.addSubview(emailOrPhoneTextFieldView)
        containerView.addSubview(passwordTextFieldView)
        
        logInButton.clickHandler = { [weak self] in
            guard let self = self else {
                return
            }
            
            guard let uiDirector = self.coordinator else {
                return
            }
            
            let loginToVerify = self.emailOrPhoneTextFieldView.text ?? ""
            let passwordToVerify = self.passwordTextFieldView.text ?? ""
            
            let verificationResult = self.credentialsCheckerDelegate.areCredentialsOk(
                                            login: loginToVerify,
                                            password: passwordToVerify)
            
            if verificationResult {
                uiDirector.processEvent(with: .loginToFeedEvent(User(fullName : loginToVerify, avatarPath : "avatar", status : "initial")))
            } else {
                uiDirector.processEvent(with: .loginToFeedEvent(nil))
            }
        }
        
        containerView.addSubview(logInButton)

        scrollView.addSubview(containerView)

        let constraints = [
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            logoView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 120),
            logoView.widthAnchor.constraint(equalToConstant: 100),
            logoView.heightAnchor.constraint(equalToConstant: 100),
            logoView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            emailOrPhoneTextFieldView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            emailOrPhoneTextFieldView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            emailOrPhoneTextFieldView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 120),
            emailOrPhoneTextFieldView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextFieldView.topAnchor.constraint(equalTo: emailOrPhoneTextFieldView.bottomAnchor),
            passwordTextFieldView.leadingAnchor.constraint(equalTo: emailOrPhoneTextFieldView.leadingAnchor),
            passwordTextFieldView.heightAnchor.constraint(equalToConstant: 50),
            passwordTextFieldView.trailingAnchor.constraint(equalTo: emailOrPhoneTextFieldView.trailingAnchor),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor),
            logInButton.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

//MARK: Keyboard Notifications
private extension LogInViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}
