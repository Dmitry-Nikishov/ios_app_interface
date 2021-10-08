//
//  CoordinatorTypes.swift
//  vk
//
//  Created by Дмитрий Никишов on 24.09.2021.
//

import Foundation
import UIKit

enum CoordinatorEvent {
    case loginToFeedEvent(User?)
    case feedToPhotoEvent
}

protocol Coordinator : AnyObject {
    var navigationController : UINavigationController? { get set }
    
    func processEvent(with type : CoordinatorEvent)
    func start()
}

protocol Coordinating : AnyObject {
    var coordinator : Coordinator? { get set }
}

enum CoordinatingViewModelTypes {
    case loginViewModel
    case feedViewModel(User)
    case photoViewModel
}
