//
//  LoginCoordinator.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//

import Foundation
import UIKit

class LoginCoordinator : Coordinator, Coordinating {
    weak var coordinator: Coordinator?
    
    weak var navigationController: UINavigationController?
    
    private let viewModelFactory : ViewModelFactory
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .loginToFolderContentEvent :
            self.coordinator?.processEvent(with: type)
            
        default :
            AppAlert.showAppNotification(
                controller: navigationController,
                notificationText: "Unexpected coordinator event")
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
