//
//  LoginFactory.swift
//  vk
//
//  Created by Дмитрий Никишов on 13.09.2021.
//

import Foundation

protocol CredentialsCheckerFactory {
    func createCredentialsInspector() -> CredentialsChecker
}
