//
//  FolderContentCoordinator.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//

import Foundation
import UIKit

class FolderContentCoordinator : Coordinator, Coordinating {
    var coordinator: Coordinator?
    
    var navigationController: UINavigationController?
    
    private let viewModelFactory : ViewModelFactory
    
    private func handleSwitchToSettingsFromContentView(with type: CoordinatorEvent)
    {
        self.coordinator?.processEvent(with: type)
    }

    private func handleSwitchToFolderContentFromLoginView()
    {
        let folderContentView = viewModelFactory.createViewModel(with: .tabViewModel, coordinator: self)

        self.navigationController?.setViewControllers([folderContentView], animated: true)
    }

    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .loginToFolderContentEvent :
            handleSwitchToFolderContentFromLoginView()
        }
    }
    
    func start() {}
    
    init(viewModelFactory : ViewModelFactory)
    {
        self.viewModelFactory = viewModelFactory
    }
}
