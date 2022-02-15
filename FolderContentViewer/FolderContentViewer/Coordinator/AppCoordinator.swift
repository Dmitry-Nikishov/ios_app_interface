//
//  AppCoordinator.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//

import Foundation
import UIKit

class AppCoordinator : Coordinator {
    var navigationController: UINavigationController?
    var children : [String : Coordinator]?
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .loginToFolderContentEvent :
            children?["folderContent"]?.processEvent(with: type)
        }
    }

    private let viewModelFactory = ViewModelFactoryImpl()
    
    func start() {
        let loginCoordinator = LoginCoordinator(viewModelFactory: self.viewModelFactory)
        loginCoordinator.navigationController = self.navigationController
        loginCoordinator.coordinator = self
                
        let folderContentCoordinator = FolderContentCoordinator(viewModelFactory: self.viewModelFactory)
        folderContentCoordinator.navigationController = self.navigationController
        folderContentCoordinator.coordinator = self

        self.children = [
            "login" : loginCoordinator,
            "folderContent" : folderContentCoordinator
        ]

        loginCoordinator.start()
    }
}
