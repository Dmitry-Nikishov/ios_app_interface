//
//  HourSummaryCoordinator.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import UIKit

class HourSummaryCoordinator : Coordinator, Coordinating {
    weak var coordinator: Coordinator?
    
    weak var navigationController: UINavigationController?
    
    private let viewControllerFactory : ViewControllerFactory
    
    private func handleSwitchFromMainViewToHourSummaryView(poiName : String?,
                                                           dataForUi : WeatherDataHourly?)
    {
        let hourSummaryController = viewControllerFactory.createViewController(with: .hourSummaryViewModel(poiName, dataForUi), coordinator: self)
        
        navigationController?.pushViewController(hourSummaryController, animated: true)
    }
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .mainViewToHourSummaryViewEvent(let poiName, let dataForUi) :
            handleSwitchFromMainViewToHourSummaryView(poiName : poiName,
                                                      dataForUi: dataForUi)
            
        case .hourSummaryViewToMainViewEvent :
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
