//
//  DaySummaryCoordinator.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import UIKit

class DaySummaryCoordinator : Coordinator, Coordinating {
    weak var coordinator: Coordinator?
    
    weak var navigationController: UINavigationController?
    
    private let viewModelFactory : ViewModelFactory
    
    private func handleSwitchFromMainViewToDaySummaryView()
    {
        let daySummaryController = viewModelFactory.createViewModel(with: .daySummaryViewModel, coordinator: self)

        navigationController?.pushViewController(daySummaryController, animated: true)
    }
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .mainViewToDaySummaryViewEvent :
            handleSwitchFromMainViewToDaySummaryView()
            
        case .daySummaryViewToMainViewEvent :
            navigationController?.popViewController(animated: true)
            
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
