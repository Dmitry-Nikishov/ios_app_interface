//
//  MockControllerCoordinatorEventProtocol.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 26.02.2022.
//

import Foundation
@testable import WeatherApp

protocol MockControllerCoordinatorEventProtocol {
    func event(type : CoordinatorEvent)
}
