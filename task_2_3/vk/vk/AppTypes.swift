//
//  AppTypes.swift
//  vk
//
//  Created by Дмитрий Никишов on 09.07.2021.
//

import Foundation

typealias LogInHandler = (User?) -> Void
typealias PhotoNavigationHandler = () -> Void
typealias UiViewClickHandler = () -> Void
typealias UserStatusChecker = (String) -> Bool
typealias UserStatusCheckerResult = (Bool) -> Void
