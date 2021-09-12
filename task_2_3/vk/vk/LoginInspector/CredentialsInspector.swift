//
//  CredentialsInspector.swift
//  vk
//
//  Created by Дмитрий Никишов on 13.09.2021.
//

import Foundation

class CredentialsInspector : CredentialsChecker {
    func areCredentialsOk(login: String, password: String) -> Bool {
        return LoginChecker.shared.isLoginAndPasswordCorrect(login: login, password: password)
    }
}
