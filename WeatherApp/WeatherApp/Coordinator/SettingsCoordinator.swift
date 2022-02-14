//
//  SettingsCoordinator.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import UIKit

class SettingsCoordinator : Coordinator, Coordinating {
    weak var coordinator: Coordinator?
    
    weak var navigationController: UINavigationController?
    
    private let viewModelFactory : ViewModelFactory
    
    private func handleSwitchFromMainViewToSettingsView()
    {
        let settingsController = viewModelFactory.createViewModel(with: .settingsViewModel, coordinator: self)
        
        navigationController?.pushViewController(settingsController, animated: true)
    }
    
    private func handlerSwitchToMainViewFromSettings()
    {
        navigationController?.popViewController(animated: true)
        if let vc = navigationController?.topViewController as? MainViewController{
            vc.refreshAfterSettingsChange()
        }
    }
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .mainViewToSettingsViewEvent :
            handleSwitchFromMainViewToSettingsView()
            
        case .settingsViewToMainViewEvent :
            handlerSwitchToMainViewFromSettings()
        
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


