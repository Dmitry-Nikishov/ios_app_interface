//
//  User.swift
//  vk
//
//  Created by Дмитрий Никишов on 10.09.2021.
//

import Foundation

class User {
    private let fullName : String
    private let avatarPath : String
    private let status : String
    
    init(fullName : String, avatarPath : String, status : String ) {
        self.fullName = fullName
        self.avatarPath = avatarPath
        self.status = status
    }
    
    public func getFullName() -> String {
        return fullName
    }
    
    public func getAvatarPath() -> String {
        return avatarPath
    }
    
    public func getStatus() -> String {
        return status
    }
}
