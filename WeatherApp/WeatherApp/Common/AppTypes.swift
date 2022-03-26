//
//  AppTypes.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 18.12.2021.
//

import Foundation
import UIKit

typealias UiViewClickHandler = () -> Void
typealias UiUpdateWithWeatherDataRequestHandler = (String) -> Void
typealias UiViewClickHandlerWithStringParam = (String) -> Void
typealias UiSelectedDayChangedHandler = (Int) -> Void
typealias CustomUiViewController = UIViewController & Coordinating
