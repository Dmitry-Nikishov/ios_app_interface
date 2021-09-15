//
//  TestUserService.swift
//  vk
//
//  Created by Дмитрий Никишов on 10.09.2021.
//

import Foundation

class TestUserService : UserService {
    func getUserByName(fullName: String) -> User? {
        return User(fullName: "test user", avatarPath: "avatar", status: "testing")
    }
}

