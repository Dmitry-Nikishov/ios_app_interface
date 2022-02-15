//
//  ViewModelFactory.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//
import UIKit

protocol ViewModelFactory {
    func createViewModel(with type : CoordinatingViewModelTypes,
                         coordinator : Coordinator ) -> UIViewController & Coordinating
}

class ViewModelFactoryImpl : ViewModelFactory {
    private let tabBarController = TabBarController()
    
    private func createViewModelBasedOnType(with type: CoordinatingViewModelTypes) -> UIViewController & Coordinating
    {
        switch type {
        case .loginViewModel :
            return LoginViewController()
         
        case .tabViewModel :
            return tabBarController
        }
    }
    
    func createViewModel(with type: CoordinatingViewModelTypes, coordinator: Coordinator) -> UIViewController & Coordinating {
        let viewModel = createViewModelBasedOnType(with : type)
        viewModel.coordinator = coordinator
        return viewModel
    }
}
