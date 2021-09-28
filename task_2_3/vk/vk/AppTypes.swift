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
typealias PasswordCrackerNotificationHandler = (String) -> Void

