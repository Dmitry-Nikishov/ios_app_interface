//
//  LoginViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 08.07.2021.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private let credentialsCheckerDelegate : CredentialsChecker
    
    private let executionQueue = OperationQueue()
    
    private lazy var passwordCracker = PasswordCracker(executor: self.executionQueue)
    
    private var appBlocker : AppBlocker?
    
    private var logInMode : LoginMode = .logIn
    
    init(credentialsChecker : CredentialsChecker) {
        credentialsCheckerDelegate = credentialsChecker
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc
    private func timerHandler() {
        print("timer")
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
        view.leftViewMode = .always
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return view
    }()
    
    private let infoLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    private let planetInfoLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    private let expiryLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        view.leftViewMode = .always
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))

        return view
    }()
    
    private let activitySpinner : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var logInButton : CustomButton = {
        let button = CustomButton(frame : self.view.frame, title: "Log in", titleColor: .white)
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        return button
    }()
    
    private lazy var passwordCrackerButton : CustomButton = {
        let button = CustomButton(frame : self.view.frame, title: "Crack password", titleColor: .white)
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        return button
    }()
    
    private let dbDataProvider = DbDataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide

//        checkFirebaseCurrentUser()
        
        setupViews()
        
        checkRealmCredentials()
        
//        showRestToDoInfo()
        
//        showRestPlanetInfo()
        
        
//        setupInternalEvents()
    }
    
    private func checkRealmCredentials()
    {
        if let credentials = dbDataProvider.getCredentials(userId: AppCommon.userId) {
            self.coordinator?.processEvent(with: .loginToFeedEvent(User(fullName : credentials.email, avatarPath : "avatar", status : "initial")))

        }
    }
    
    private func checkFirebaseCurrentUser()
    {
        let fbUser = FirebaseAuth.Auth.auth().currentUser
        if fbUser != nil {
            self.logInMode = .logOut
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.logInButton.title = "Log Out"
                self.emailOrPhoneTextFieldView.isUserInteractionEnabled = false
                self.passwordTextFieldView.isUserInteractionEnabled = false
            }
        }
    }
    
    private func showRestPlanetInfo()
    {
        let dataHandler : RestDataHandler = { data in
            guard let responseData = data else {
                return
            }
            
            do {
                let planetData = try JSONDecoder().decode(PlanetData.self, from: responseData)
                
                DispatchQueue.main.async {
                    self.planetInfoLabel.text = "orbital_period = \(planetData.orbitalPeriod)"
                }
            }catch{}
        }

        NetworkManager.execute(masterServerUrl: "https://swapi.dev",
                               endpointConfig: AppConfiguration.planets,
                               dataHandler: dataHandler)
    }
    
    private func showRestToDoInfo()
    {
        let dataHandler : RestDataHandler = { data in
            guard let responseData = data else {
                return
            }
             
            do {
                  guard let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                      return
                  }
                
                if let userId = json["userId"] as? Int,
                   let id = json["id"] as? Int,
                   let title = json["title"] as? String,
                   let completed = json["completed"] as? Bool
                {
                    let result = ToDoData(userId: userId,
                                          id: id,
                                          title: title,
                                          completed: completed)
                    
                    DispatchQueue.main.async {
                        self.infoLabel.text = result.title
                    }
                }
            } catch  {}
        }

        NetworkManager.execute(masterServerUrl: "https://jsonplaceholder.typicode.com",
                               endpointConfig: AppConfiguration.todos,
                               dataHandler: dataHandler)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetInternalEvents()
    }

    private func resetInternalEvents()
    {
        appBlocker?.stop()
        appBlocker = nil
    }
    
    private func setupInternalEvents()
    {
        appBlocker = AppBlocker()
        appBlocker?.handler = { [weak self] timeBeforeBlock in
            if timeBeforeBlock <= 0 {
                self?.appBlocker?.stop()
                self?.logInButton.isEnabled = false
                self?.passwordTextFieldView.isEnabled = false
                self?.passwordCrackerButton.isEnabled = false
                self?.emailOrPhoneTextFieldView.isEnabled = false
                self?.expiryLabel.text = "App is blocked - you are a fraud"
            } else {
                self?.expiryLabel.text = "\(timeBeforeBlock) sec left before app block"
            }
        }
        
        appBlocker?.start(appBlockTimeInSeconds: 10)
    }
    
    private func showCreateAccount(email : String, password : String) {
        let alert = UIAlertController(title: "Create Firebase Account",
                                      message: "Would you like to create an account",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: { _ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email,
                                                password: password,
                                                completion: { result, error in
                guard error == nil else {
                    print("Account creation failure : \(error)")
                    return
                }
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: { _ in
            
        }))
        
        present(alert, animated: true)
    }
    
    private func setupViews()
    {
        view.addSubview(scrollView)
        
        containerView.addSubview(logoView)
        containerView.addSubview(emailOrPhoneTextFieldView)
        containerView.addSubview(passwordTextFieldView)
        containerView.addSubview(expiryLabel)
        containerView.addSubview(planetInfoLabel)
        
        logInButton.clickHandler = { [weak self] in
            guard let self = self,
                  let uiDirector = self.coordinator else {
                      return
                  }

            let loginEmail = self.emailOrPhoneTextFieldView.text ?? ""
            let loginPassword = self.passwordTextFieldView.text ?? ""

            let checkError = self.credentialsCheckerDelegate.areCredentialsOk(
                login: loginEmail,
                password: loginPassword)
            
            if checkError == .success {
                uiDirector.processEvent(with: .loginToFeedEvent(User(fullName : loginEmail, avatarPath : "avatar", status : "initial")))
                
                let dbCredentials = DbAppCredentials(
                    id : AppCommon.userId,
                    email: loginEmail,
                    password: loginPassword)
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else {
                        return
                    }

                    self.dbDataProvider.addCredentials(credentials: dbCredentials)
                }
            }
            
//            if self.logInMode == .logIn {
//                let loginEmail = self.emailOrPhoneTextFieldView.text ?? ""
//                let loginPassword = self.passwordTextFieldView.text ?? ""
//
//                guard !loginEmail.isEmpty,
//                      !loginPassword.isEmpty else {
//                    uiDirector.processEvent(with: .loginToFeedEvent(nil))
//                    return
//                }
//
//                FirebaseAuth.Auth.auth().signIn(withEmail: loginEmail, password: loginPassword, completion: { [weak self] result, error in
//                        guard let strongSelf = self else {
//                            return
//                        }
//
//                        guard error == nil else {
//                            strongSelf.showCreateAccount(email: loginEmail, password: loginPassword)
//                            return
//                        }
//
//                    DispatchQueue.main.async {
//                        strongSelf.logInButton.title = "Log Out"
//                        strongSelf.passwordTextFieldView.isUserInteractionEnabled = false
//                        strongSelf.emailOrPhoneTextFieldView.isUserInteractionEnabled = false
//                    }
//
//                    uiDirector.processEvent(with: .loginToFeedEvent(User(fullName : loginEmail, avatarPath : "avatar", status : "initial")))
//                })
//            } else {
//                do {
//                    try FirebaseAuth.Auth.auth().signOut()
//                    self.logInMode = .logIn
//                    DispatchQueue.main.async {
//                        self.logInButton.title = "Log In"
//                        self.passwordTextFieldView.isUserInteractionEnabled = true
//                        self.emailOrPhoneTextFieldView.isUserInteractionEnabled = true
//                    }
//                }catch {}
//            }
            
        }
        
        passwordCrackerButton.clickHandler = { [weak self] in
            guard let self = self else {
                return
            }
                
            self.activitySpinner.startAnimating()
            
            self.passwordCracker.asyncCrack(credentialsChecker: self.credentialsCheckerDelegate)
            { (password : Result<String, ApiError>) in
                switch password {
                case .success(let success):
                    DispatchQueue.main.async{
                        self.activitySpinner.stopAnimating()
                        self.passwordTextFieldView.isSecureTextEntry = false
                        self.passwordTextFieldView.text = success
                    }
                case .failure:
                    preconditionFailure("Brute force did not crack the password")
                }
            }
        }
        
        containerView.addSubview(logInButton)
        containerView.addSubview(passwordCrackerButton)
        containerView.addSubview(activitySpinner)
        containerView.addSubview(infoLabel)

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
            
            activitySpinner.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor),
            activitySpinner.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor),
            activitySpinner.heightAnchor.constraint(equalToConstant: 50),
            activitySpinner.widthAnchor.constraint(equalToConstant: 50),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor),
            logInButton.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            passwordCrackerButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 16),
            passwordCrackerButton.leadingAnchor.constraint(equalTo: logInButton.leadingAnchor),
            passwordCrackerButton.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
            passwordCrackerButton.heightAnchor.constraint(equalToConstant: 50),

            expiryLabel.topAnchor.constraint(equalTo: passwordCrackerButton.bottomAnchor, constant: 16),
            expiryLabel.leadingAnchor.constraint(equalTo: passwordCrackerButton.leadingAnchor),
            expiryLabel.trailingAnchor.constraint(equalTo: passwordCrackerButton.trailingAnchor),
            expiryLabel.heightAnchor.constraint(equalToConstant: 25),

            infoLabel.topAnchor.constraint(equalTo: expiryLabel.bottomAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: expiryLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: expiryLabel.trailingAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 50),

            planetInfoLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            planetInfoLabel.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            planetInfoLabel.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            planetInfoLabel.heightAnchor.constraint(equalToConstant: 25),

            planetInfoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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
