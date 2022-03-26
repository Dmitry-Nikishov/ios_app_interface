//
//  OnboardingCoordinator.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import UIKit

class OnboardingCoordinator : Coordinator, Coordinating {    
    weak var coordinator: Coordinator?
    
    weak var navigationController: UINavigationController?
    
    private let viewControllerFactory : ViewControllerFactory
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .onboardingViewToMainViewEvent :
            self.coordinator?.processEvent(with: type)
        
        default :
            showUnexpectedCoordinatorEventAlert()
        }
    }
    
    func start() {
        let onboardingController = viewControllerFactory.createViewController(with: .onboardingModel, coordinator: self)
        
        navigationController?.setViewControllers([onboardingController], animated: true)
    }
    
    init(viewControllerFactory : ViewControllerFactory)
    {
        self.viewControllerFactory = viewControllerFactory
    }
}

