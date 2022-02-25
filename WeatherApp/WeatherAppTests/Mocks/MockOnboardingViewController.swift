//
//  MockOnboardingViewController.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 25.02.2022.
//

import Foundation
import UIKit

@testable import WeatherApp

class MockOnboardingViewController : UIViewController,
                                     Coordinating,
                                     MockControllerStatisticsProtocol,
                                     MockControllerCoordinatorEventProtocol
{
    func event(type: CoordinatorEvent) {
        coordinator?.processEvent(with: type)
    }
    
    var timesDidAppeared: Int {
        get {
            return appearedCounter
        }
    }
        
    private var appearedCounter : Int = 0
    
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        appearedCounter += 1
    }
    
}

