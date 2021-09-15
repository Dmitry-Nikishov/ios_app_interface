//
//  CurrentUserService.swift
//  vk
//
//  Created by Дмитрий Никишов on 10.09.2021.
//

import Foundation

class CurrentUserService : UserService {
    private let user : User
    
    init(user : User) {
        self.user = user
    }
    
    func getUserByName(fullName: String) -> User? {
        return user.getFullName() == fullName ? user : nil
    }
}

