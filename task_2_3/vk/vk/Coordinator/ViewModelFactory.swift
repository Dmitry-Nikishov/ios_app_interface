//
//  ViewModelFactory.swift
//  vk
//
//  Created by Дмитрий Никишов on 27.09.2021.
//

import Foundation
import UIKit

protocol ViewModelFactory {
    func createViewModel(with type : CoordinatingViewModelTypes, coordinator : Coordinator ) -> UIViewController & Coordinating
}

class ViewModelFactoryImpl : ViewModelFactory {
    private let credentialsInspectorFactory = CredentialsCheckerFactoryImpl()
    
    private func createViewModelBasedOnType(with type: CoordinatingViewModelTypes) -> UIViewController & Coordinating
    {
        switch type {
        case .loginViewModel :
            return LogInViewController(credentialsChecker : credentialsInspectorFactory.createCredentialsInspector())
         
        case .photoViewModel :
            return PhotosViewController()
            
        case .feedViewModel(let usr) :
            let profileTabViewController = ProfileTabBarController()
            profileTabViewController.setUserIdentity(userIdentity: usr)
            return profileTabViewController
        }
    }
    
    func createViewModel(with type: CoordinatingViewModelTypes, coordinator: Coordinator) -> UIViewController & Coordinating {
        let viewModel = createViewModelBasedOnType(with : type)
        viewModel.coordinator = coordinator
        return viewModel
    }
}
