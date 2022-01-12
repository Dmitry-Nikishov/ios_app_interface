//
//  MainCoordinator.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import UIKit

class MainCoordinator : Coordinator, Coordinating {
    weak var coordinator: Coordinator?
    
    weak var navigationController: UINavigationController?
    
    private let viewModelFactory : ViewModelFactory
    
    private func handleMainViewDisplay(mode : OnboardingMode)
    {
        let mainController = viewModelFactory.createViewModel(with: .mainViewModel, coordinator: self)
        
        navigationController?.pushViewController(mainController, animated: true)
    }
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
            case .mainViewToSettingsViewEvent,
                 .mainViewToDaySummaryViewEvent,
                 .mainViewToHourSummaryViewEvent :
                self.coordinator?.processEvent(with: type)
            
            case .onboardingViewToMainViewEvent(let onboardingMode) :
                handleMainViewDisplay(mode : onboardingMode)
                    
            default :
                showUnexpectedCoordinatorEventAlert()
        }
    }
    
    func start() {}
    
    init(viewModelFactory : ViewModelFactory)
    {
        self.viewModelFactory = viewModelFactory
    }
}
