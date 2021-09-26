//
//  LoginCoordinator.swift
//  vk
//
//  Created by Дмитрий Никишов on 24.09.2021.
//

import Foundation
import UIKit

class LoginCoordinator : Coordinator, Coordinating {
    weak var coordinator: Coordinator?
    
    weak var navigationController: UINavigationController?
    
    private let viewModelFactory : ViewModelFactory
    
    private func showUnexpectedCoordinatorEventAlert()
    {
        let alert = UIAlertController(title: "VK App", message: "Unexpected coordinator event", preferredStyle: .alert)
            
        let ok = UIAlertAction(title: "OK", style: .default)

        alert.addAction(ok)
        
        navigationController?.present(alert, animated: true)
    }

    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .loginToFeedEvent :
            self.coordinator?.processEvent(with: type)
        
        default :
            showUnexpectedCoordinatorEventAlert()
        }
    }
    
    func start() {
        let loginViewModel = viewModelFactory.createViewModel(with: .loginViewModel, coordinator: self)
        
        navigationController?.setViewControllers([loginViewModel], animated: true)
    }
    
    init(viewModelFactory : ViewModelFactory)
    {
        self.viewModelFactory = viewModelFactory
    }
}
