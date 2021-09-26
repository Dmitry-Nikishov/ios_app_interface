//
//  UserStatusModel.swift
//  vk
//
//  Created by Дмитрий Никишов on 21.09.2021.
//

import Foundation

enum UserStatusModelPolicy {
    case noValidation
    case onlyLettersPossible
}

class UserStatusModel {
    private let statusChecker : UserStatusChecker
        
    init(policy : UserStatusModelPolicy) {
        switch policy {
        case .noValidation:
            statusChecker = { status in
                return true
            }
            
        case .onlyLettersPossible :
            statusChecker = { status in
                for chr in status {
                   if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                      return false
                   }
                }
                return true
            }
        }
    }
    
    public func checkStatus(status : String, resultCallback : UserStatusCheckerResult) {
        let checkResult = statusChecker(status)
        resultCallback(checkResult)
    }
}
