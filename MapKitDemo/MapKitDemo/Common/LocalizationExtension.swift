//
//  LocalizationExtension.swift
//  MapKitDemo
//
//  Created by Дмитрий Никишов on 19.02.2022.
//

import Foundation

enum Strings : String {
    case DeleteRoutesMenuItem
    case RemoveMapPinsMenuItem
    case CreateRouteMenuItem
    case CreateRouteAlertTitle
    case CreateRouteAlertMessage
    case MapMenuName
    case AlertButtonTitle

    var localized : String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
