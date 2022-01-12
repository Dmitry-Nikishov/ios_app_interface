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
    
    private let viewModelFactory : ViewModelFactory
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .onboardingViewToMainViewEvent :
            self.coordinator?.processEvent(with: type)
        
        default :
            showUnexpectedCoordinatorEventAlert()
        }
    }
    
    func start() {
        let onboardingController = viewModelFactory.createViewModel(with: .onboardingModel, coordinator: self)
        
        navigationController?.setViewControllers([onboardingController], animated: true)
    }
    
    init(viewModelFactory : ViewModelFactory)
    {
        self.viewModelFactory = viewModelFactory
    }
}

