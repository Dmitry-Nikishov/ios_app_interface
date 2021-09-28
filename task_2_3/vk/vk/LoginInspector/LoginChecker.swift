//
//  LoginChecker.swift
//  vk
//
//  Created by Дмитрий Никишов on 13.09.2021.
//

import Foundation

class LoginChecker {
    static let shared = LoginChecker(login: Credentials.predefinedLogin,
                                     password: Credentials.predefinedPassword)
    
    private let loginHash : Int
    private let passwordHash : Int
    
    private init(login : String, password : String) {
        self.loginHash = login.hash
        self.passwordHash = password.hash
    }
    
    public func isLoginAndPasswordCorrect(login : String, password : String) -> Bool {
        let inputLoginHash = login.hash
        let inputPasswordHash = password.hash
        return inputLoginHash == self.loginHash && inputPasswordHash == self.passwordHash
    }
}
