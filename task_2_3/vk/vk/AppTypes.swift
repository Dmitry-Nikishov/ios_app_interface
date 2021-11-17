//
//  AppTypes.swift
//  vk
//
//  Created by Дмитрий Никишов on 09.07.2021.
//

import Foundation
import UIKit

typealias UiViewClickHandler = () -> Void
typealias UserStatusChecker = (String) -> Bool
typealias UserStatusCheckerResult = (Bool) -> Void
typealias ImageProcessorHandler = ([UIImage?]) -> Void
typealias PasswordCrackerNotificationHandler = (Result<String, ApiError>) -> Void
typealias AppBlockerEvent = (Int) -> Void

enum ApiError : Error {
    case incorrectPasswordError
    case bruteForceNotAbleToCrackError
}

typealias InternalApiResult = Result<Void, ApiError>
