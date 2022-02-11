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
    
    private let viewModelFactory : ViewModelFactory
    
    private func handleSwitchFromMainViewToHourSummaryView(poiName : String?,
                                                           dataForUi : WeatherDataHourly?)
    {
        let hourSummaryController = viewModelFactory.createViewModel(with: .hourSummaryViewModel, coordinator: self)
        
        if let vc = hourSummaryController as? HourSummaryViewController {
            vc.applyUiSettings(poiName : poiName, dataForUi: dataForUi)
        }

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
    
    init(viewModelFactory : ViewModelFactory)
    {
        self.viewModelFactory = viewModelFactory
    }
}
