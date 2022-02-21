//
//  FeedCoordinator.swift
//  vk
//
//  Created by Дмитрий Никишов on 24.09.2021.
//

import Foundation
import UIKit

class FeedCoordinator : Coordinator, Coordinating {
    var coordinator: Coordinator?
    
    var navigationController: UINavigationController?
    
    private let viewModelFactory : ViewModelFactory
    
    private func showInvalidUserAlert()
    {
        let alert = UIAlertController(title: "VK App", message: "Invalid user name. Try again", preferredStyle: .alert)
            
        let ok = UIAlertAction(title: "OK", style: .default)

        alert.addAction(ok)
        
        navigationController?.present(alert, animated: true)
    }

    private func handleSwitchToFeedEvent(user : User?)
    {
        guard let usr = user else {
            showInvalidUserAlert()
            return
        }
        
        let viewModel = viewModelFactory.createViewModel(with: .feedViewModel(usr), coordinator: self)

        navigationController?.pushViewController(viewModel, animated: true)
    }
    
    private func handleToPhotoControllerEvent()
    {
        let viewMode = viewModelFactory.createViewModel(with: .photoViewModel, coordinator: self)
        self.navigationController?.pushViewController(viewMode, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }

    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .loginToFeedEvent(let user) :
            handleSwitchToFeedEvent(user: user)
        
        case .feedToPhotoEvent :
            handleToPhotoControllerEvent()
        }
    }
    
    func start() {}
    
    init(viewModelFactory : ViewModelFactory)
    {
        self.viewModelFactory = viewModelFactory
    }
}
