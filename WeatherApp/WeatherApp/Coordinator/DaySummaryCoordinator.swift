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
    
    private let viewControllerFactory : ViewControllerFactory
    
    private func handleSwitchFromMainViewToDaySummaryView(poiName : String?, weatherData : WeatherDataMonthly?)
    {
        let daySummaryController = viewControllerFactory.createViewController(with: .daySummaryViewModel, coordinator: self)

        if let vc = daySummaryController as? DaySummaryController {
            vc.applyUiSettings(poiName: poiName, weatherData: weatherData)
        }
        
        navigationController?.pushViewController(daySummaryController, animated: true)
    }
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .mainViewToDaySummaryViewEvent(let poiName, let weatherData) :
            handleSwitchFromMainViewToDaySummaryView(poiName: poiName, weatherData: weatherData)
            
        case .daySummaryViewToMainViewEvent :
            navigationController?.popViewController(animated: true)
            
        default :
            showUnexpectedCoordinatorEventAlert()
        }
    }
    
    func start() {}
    
    init(viewControllerFactory : ViewControllerFactory)
    {
        self.viewControllerFactory = viewControllerFactory
    }
}
