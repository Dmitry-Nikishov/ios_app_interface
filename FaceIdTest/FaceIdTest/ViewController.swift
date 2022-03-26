//
//  ViewController.swift
//  FaceIdTest
//
//  Created by Дмитрий Никишов on 04.03.2022.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    
    private func getTitleForAuthorizationButton() -> String {
        return LocalAuthorizationService.shared.getBiometricType().rawValue
    }
    
    private func setupView()
    {
        let button = UIButton(frame : CGRect(x: 0, y: 0, width: 200, height : 50))
        view.addSubview(button)
        button.center = view.center
        button.setTitle(self.getTitleForAuthorizationButton(), for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(authorizeClicked), for: .touchUpInside)
    }

    private func handleAuthorizationFailure()
    {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Failed to Authenticate", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self?.present(alert, animated: true)
        }
    }
    
    private func handleAuthorizationOk()
    {
        DispatchQueue.main.async { [weak self] in
            let vc = UIViewController()
            vc.title = "Welcome!"
            vc.view.backgroundColor = .systemTeal
            self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }
    
    @objc
    private func authorizeClicked()
    {
        LocalAuthorizationService.shared.authorizeIfPossible { [weak self] status in
            if status {
                self?.handleAuthorizationOk()
            } else {
                self?.handleAuthorizationFailure()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

