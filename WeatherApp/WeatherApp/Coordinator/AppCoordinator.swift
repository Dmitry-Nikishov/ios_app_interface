//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import Foundation
import UIKit

class AppCoordinator : Coordinator {
    var navigationController: UINavigationController?
    var children : [String : Coordinator]?
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .onboardingViewToMainViewEvent :
            children?["main"]?.processEvent(with: type)
            
        case .mainViewToSettingsViewEvent :
            children?["settings"]?.processEvent(with: type)

        case .mainViewToDaySummaryViewEvent :
            children?["daySummary"]?.processEvent(with: type)
            
        case .mainViewToHourSummaryViewEvent :
            children?["hourSummary"]?.processEvent(with: type)
            
        default :
            ()
        }
    }

    private let viewModelFactory = ViewModelFactoryImpl()
    
    private func createCoordinator(type : CoordinatingViewModelTypes) -> Coordinator & Coordinating {
        var result : Coordinator & Coordinating
        
        switch type {
            case .onboardingModel:
                result = OnboardingCoordinator(viewModelFactory: self.viewModelFactory)
            case .mainViewModel:
                result = MainCoordinator(viewModelFactory: self.viewModelFactory)
            case .settingsViewModel:
                result = SettingsCoordinator(viewModelFactory: self.viewModelFactory)
            case .daySummaryViewModel:
                result = DaySummaryCoordinator(viewModelFactory: self.viewModelFactory)
            case .hourSummaryViewModel:
                result = HourSummaryCoordinator(viewModelFactory: self.viewModelFactory)
        }
        
        result.navigationController = self.navigationController
        result.coordinator = self
        
        return result
    }
    
    func start() {
        self.children = [
            "onboarding" : createCoordinator(type : .onboardingModel),
            "main" : createCoordinator(type : .mainViewModel),
            "settings" : createCoordinator(type: .settingsViewModel),
            "daySummary" : createCoordinator(type: .daySummaryViewModel),
            "hourSummary" : createCoordinator(type: .hourSummaryViewModel)
        ]
        
        self.children?["onboarding"]?.start()
    }
}


