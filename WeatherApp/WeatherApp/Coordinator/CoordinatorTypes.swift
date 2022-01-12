//
//  CoordinatorTypes.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import Foundation
import UIKit

enum OnboardingMode {
    case withCurrentLocation
    case withoutCurrentLocation
}

enum CoordinatorEvent {
    case onboardingViewToMainViewEvent(OnboardingMode)
    case mainViewToSettingsViewEvent
    case settingsViewToMainViewEvent
    case mainViewToDaySummaryViewEvent
    case daySummaryViewToMainViewEvent
    case mainViewToHourSummaryViewEvent
    case hourSummaryViewToMainViewEvent
}

protocol Coordinator : AnyObject {
    var navigationController : UINavigationController? { get set }
    
    func processEvent(with type : CoordinatorEvent)
    func start()
    
    func showUnexpectedCoordinatorEventAlert()
}

protocol Coordinating : AnyObject {
    var coordinator : Coordinator? { get set }
}

enum CoordinatingViewModelTypes {
    case onboardingModel
    case mainViewModel
    case settingsViewModel
    case daySummaryViewModel
    case hourSummaryViewModel
}

extension Coordinator {
    func showUnexpectedCoordinatorEventAlert()
    {
        AppAlert.showAppNotification(controller: navigationController,
                                     notificationText: "Unexpected coordinator event")
    }
}
