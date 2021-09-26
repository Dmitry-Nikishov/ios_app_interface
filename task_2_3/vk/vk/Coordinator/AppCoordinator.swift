//
//  AppCoordinator.swift
//  vk
//
//  Created by Дмитрий Никишов on 24.09.2021.
//

import Foundation
import UIKit

class AppCoordinator : Coordinator {
    var navigationController: UINavigationController?
    var children : [Coordinator]?
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .loginToFeedEvent :
            children?[1].processEvent(with: type)
        
        default :
            ()
        }
    }

    private let viewModelFactory = ViewModelFactoryImpl()
    
    func start() {
        let loginCoordinator = LoginCoordinator(viewModelFactory: self.viewModelFactory)
        loginCoordinator.navigationController = self.navigationController
        loginCoordinator.coordinator = self
        
        let feedCoordinator = FeedCoordinator(viewModelFactory: self.viewModelFactory)
        feedCoordinator.navigationController = self.navigationController
        feedCoordinator.coordinator = self
        
        self.children = [loginCoordinator, feedCoordinator]
        
        loginCoordinator.start()
    }
}
