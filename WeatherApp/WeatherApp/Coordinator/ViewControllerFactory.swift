//
//  ViewModelFactory.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import Foundation
import UIKit

protocol ViewControllerFactory {
    func createViewController(with type : CoordinatingViewModelTypes, coordinator : Coordinator ) -> UIViewController & Coordinating
}

class ViewControllerFactoryImpl : ViewControllerFactory {
    private func createViewModelBasedOnType(with type: CoordinatingViewModelTypes) -> UIViewController & Coordinating
    {
        switch type {
            case .onboardingModel :
                return OnboardingViewController()
            
            case .mainViewModel :
                return MainViewController()
            
            case .daySummaryViewModel :
                return DaySummaryController()
            
            case .hourSummaryViewModel :
                return HourSummaryViewController()
            
            case .settingsViewModel :
                return SettingsViewController()
        }
    }
    
    func createViewController(with type: CoordinatingViewModelTypes, coordinator: Coordinator) -> UIViewController & Coordinating {
        let viewModel = createViewModelBasedOnType(with : type)
        viewModel.coordinator = coordinator
        return viewModel
    }
}

