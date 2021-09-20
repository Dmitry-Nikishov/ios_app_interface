//
//  LoginViewControllerDelegate.swift
//  vk
//
//  Created by Дмитрий Никишов on 13.09.2021.
//

import Foundation

protocol CredentialsChecker {
    func areCredentialsOk(login : String, password : String) -> Bool
}
