//
//  AppKeychain.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 27.11.2021.
//

import Foundation
import KeychainAccess

class AppKeychain {
    private static let keychain = Keychain(service: AppCommonSettings.keychainServiceName)
    
    public static func savePassword(password : String) {
        AppKeychain.keychain[AppCommonSettings.keychainAppPasswordKey] = password
    }
    
    public static func getPassword() -> String? {
        if let password = try? AppKeychain.keychain.getString(AppCommonSettings.keychainAppPasswordKey) {
            return password
        } else {
            return nil
        }
    }
}
