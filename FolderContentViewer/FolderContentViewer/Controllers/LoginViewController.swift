//
//  LoginViewController.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//

import UIKit

class LoginViewController: UIViewController & Coordinating {
    var coordinator: Coordinator?
    
    private var appPasswordFromKeychain : String?
    
    private let passwordHolder = PasswordCreationHolder()
    
    private var loginState : LoginState = .initialState {
        didSet {
            if oldValue == .initialState && loginState == .createPasswordStage1  {
                setLoginButtonTitle(title: "Create password")
            } else if oldValue == .initialState && loginState == .checkWithExistingPassword  {
                setLoginButtonTitle(title: "Type password")
            } else if oldValue == .createPasswordStage1 && loginState == .createPasswordStage2 {
                setLoginButtonTitle(title: "Retype password")
            }
        }
    }
    
    private func setLoginButtonTitle(title : String)
    {
        if let view = self.view as? LoginView {
            view.setLoginButtonTitle(title: title)
        }
    }
    
    private func handlePasswordCreatePhase1(password : String)
    {
        if password.count < AppCommonSettings.passwordMinLength {
            AppAlert.showAppNotification(controller: self.navigationController, notificationText: "Not enough password length, must be at least \(AppCommonSettings.passwordMinLength)")
        } else {
            passwordHolder.setStage1Password(password: password)
            loginState = .createPasswordStage2
        }
    }
    
    private func handlePasswordCreatePhase2(password : String)
    {
        loginState = .initialState
        
        if passwordHolder.checkRetypedPassword(password: password) {
            coordinator?.processEvent(with: .loginToFolderContentEvent)
            AppKeychain.savePassword(password: password)
            appPasswordFromKeychain = password
        } else {
            AppAlert.showAppNotification(controller: self.navigationController, notificationText: "Retyped password mismatch")
        }

        passwordHolder.reset()
        assignCurrentLoginState()
    }
    
    private func handleCheckWithExistingPassword(password : String)
    {
        loginState = .initialState
        
        if passwordHolder.checkRetypedPassword(password: password) {
            coordinator?.processEvent(with: .loginToFolderContentEvent)
        } else {
            AppAlert.showAppNotification(controller: self.navigationController, notificationText: "Password mismatch")
        }
        
        passwordHolder.reset()
        assignCurrentLoginState()
    }
    
    private func handleLoginClickEvent(data : String)
    {
        switch loginState {
        case .initialState:
            ()
        case .createPasswordStage1:
            handlePasswordCreatePhase1(password: data)
        case .createPasswordStage2:
            handlePasswordCreatePhase2(password: data)
        case .checkWithExistingPassword:
            handleCheckWithExistingPassword(password: data)
        }
    }
    
    private func setupView()
    {
        let loginView = LoginView(viewFrame: self.view.frame)
        loginView.loginClickHandler = { [weak self] password in
            guard let this = self else {
                return
            }
            
            this.handleLoginClickEvent(data : password)
        }

        self.view = loginView
    }
     
    private func assignCurrentLoginState()
    {
        if let password = appPasswordFromKeychain {
            self.loginState = .checkWithExistingPassword
            passwordHolder.setStage1Password(password: password)
        } else {
            self.loginState = .createPasswordStage1
        }
    }
    
    private func initializeViewBasedOnKeychainContent()
    {
        if let keychainPassword = AppKeychain.getPassword() {
            self.loginState = .checkWithExistingPassword
            passwordHolder.setStage1Password(password: keychainPassword)
            appPasswordFromKeychain = keychainPassword
        } else {
            self.loginState = .createPasswordStage1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupView()
        
        initializeViewBasedOnKeychainContent()
    }
}
