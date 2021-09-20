//
//  LoginFactoryImpl.swift
//  vk
//
//  Created by Дмитрий Никишов on 13.09.2021.
//

import Foundation

class CredentialsCheckerFactoryImpl : CredentialsCheckerFactory {
    func createCredentialsInspector() -> CredentialsChecker {
        return CredentialsInspector()
    }
}
