//
//  CoordinatorTypes.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//

import Foundation
import UIKit

enum CoordinatorEvent {
    case loginToFolderContentEvent
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
    case tabViewModel
}
