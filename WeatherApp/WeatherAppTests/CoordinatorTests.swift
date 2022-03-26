//
//  CoordinatorTests.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 26.02.2022.
//

import XCTest
import UIKit
@testable import WeatherApp

class CoordinatorTests: XCTestCase {

    func testOnboardingViewShouldAppearFirst() throws {
        let navigationVC = UINavigationController()

        let viewFactory = ViewControllerFactoryMock()
        let appCoordinator = AppCoordinator(controllerViewFactory: viewFactory)
        appCoordinator.navigationController = navigationVC
        appCoordinator.start()
        
        XCTAssertEqual(viewFactory.controllers[.onboarding]?.timesDidAppeared, 1)
    }

    func testOnboardingToMainViewSwitchShouldBeOk() throws {
        let navigationVC = UINavigationController()

        let viewFactory = ViewControllerFactoryMock()
        let appCoordinator = AppCoordinator(controllerViewFactory: viewFactory)
        appCoordinator.navigationController = navigationVC
        appCoordinator.start()
        
        viewFactory.controllers[.onboarding]?.event(type: .onboardingViewToMainViewEvent(.withCurrentLocation))
        
        XCTAssertEqual(viewFactory.controllers[.onboarding]?.timesDidAppeared, 1)
        XCTAssertEqual(viewFactory.controllers[.main]?.timesDidAppeared, 1)
    }

    func testOnboardingToMainAndThenToSettingsViewSwitchShouldBeOk() throws {
        let navigationVC = UINavigationController()

        let viewFactory = ViewControllerFactoryMock()
        let appCoordinator = AppCoordinator(controllerViewFactory: viewFactory)
        appCoordinator.navigationController = navigationVC
        appCoordinator.start()
        
        viewFactory.controllers[.onboarding]?.event(type: .onboardingViewToMainViewEvent(.withCurrentLocation))

        viewFactory.controllers[.main]?.event(type: .mainViewToSettingsViewEvent)

        XCTAssertEqual(viewFactory.controllers[.onboarding]?.timesDidAppeared, 1)
        XCTAssertEqual(viewFactory.controllers[.main]?.timesDidAppeared, 1)
        XCTAssertEqual(viewFactory.controllers[.settings]?.timesDidAppeared, 1)
    }

}
