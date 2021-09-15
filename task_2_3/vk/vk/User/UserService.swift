//
//  UserService.swift
//  vk
//
//  Created by Дмитрий Никишов on 10.09.2021.
//

import Foundation

protocol UserService {
    func getUserByName(fullName : String) -> User?
}
