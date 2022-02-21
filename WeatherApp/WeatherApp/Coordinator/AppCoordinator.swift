//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import Foundation
import UIKit

enum Screen: String {
    case main
    case settings
    case daySummary
    case hourSummary
    case onboarding
}

class AppCoordinator : Coordinator {
    var navigationController: UINavigationController?
    var children : [Screen: Coordinator]?
    
    func processEvent(with type: CoordinatorEvent) {
        switch type {
        case .onboardingViewToMainViewEvent :
            children?[.main]?.processEvent(with: type)
            
        case .mainViewToSettingsViewEvent :
            children?[.settings]?.processEvent(with: type)

        case .mainViewToDaySummaryViewEvent :
            children?[.daySummary]?.processEvent(with: type)
            
        case .mainViewToHourSummaryViewEvent :
            children?[.hourSummary]?.processEvent(with: type)
            
        default :
            ()
        }
    }

    private let viewControllerFactory = ViewControllerFactoryImpl()
    
    private func createCoordinator(type : CoordinatingViewModelTypes) -> Coordinator & Coordinating {
        var result : Coordinator & Coordinating
        
        switch type {
            case .onboardingModel:
                result = OnboardingCoordinator(viewControllerFactory: self.viewControllerFactory)
            case .mainViewModel:
                result = MainCoordinator(viewControllerFactory: self.viewControllerFactory)
            case .settingsViewModel:
                result = SettingsCoordinator(viewControllerFactory: self.viewControllerFactory)
            case .daySummaryViewModel:
                result = DaySummaryCoordinator(viewControllerFactory: self.viewControllerFactory)
            case .hourSummaryViewModel:
                result = HourSummaryCoordinator(viewControllerFactory: self.viewControllerFactory)
        }
        
        result.navigationController = self.navigationController
        result.coordinator = self
        
        return result
    }
    
    func start() {
        self.navigationController?.isNavigationBarHidden = true
                
        self.children = [
            .onboarding : createCoordinator(type : .onboardingModel),
            .main : createCoordinator(type : .mainViewModel),
            .settings : createCoordinator(type: .settingsViewModel),
            .daySummary : createCoordinator(type: .daySummaryViewModel),
            .hourSummary : createCoordinator(type: .hourSummaryViewModel)
        ]
        
        self.children?[.onboarding]?.start()
    }
}


