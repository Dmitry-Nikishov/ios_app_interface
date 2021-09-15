//
//  Utility.swift
//  vk
//
//  Created by Дмитрий Никишов on 12.09.2021.
//

import Foundation

class Utility {
    static func getUserName(service : UserService, userName : String ) -> User? {
        return service.getUserByName(fullName: userName)
    }
}
