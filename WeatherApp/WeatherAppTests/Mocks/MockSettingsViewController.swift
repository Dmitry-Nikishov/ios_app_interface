//
//  MockSettingsViewController.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 25.02.2022.
//

import Foundation
import UIKit

@testable import WeatherApp

class MockSettingsViewController : UIViewController,
                                   Coordinating,
                                   MockControllerStatisticsProtocol,
                                   MockControllerCoordinatorEventProtocol
{
    func event(type: CoordinatorEvent) {
        coordinator?.processEvent(with: type)
    }

    var coordinator: Coordinator?
    
    var timesDidAppeared: Int {
        get {
            return appearedCounter
        }
    }
        
    private var appearedCounter : Int = 0

    override func viewDidLoad() {
        appearedCounter += 1
    }
}
