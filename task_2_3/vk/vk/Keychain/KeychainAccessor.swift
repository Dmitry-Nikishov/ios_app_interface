//
//  KeychainAccessor.swift
//  vk
//
//  Created by Дмитрий Никишов on 11.12.2021.
//

import Foundation
import SwiftKeychainWrapper


class KeychainAccessor {
    private static let app_credentials_key : String = "vk_credentials_key"
    
    public static func getCredentialsEncryptionKey() -> Data? {
        return KeychainWrapper.standard.data(forKey: KeychainAccessor.app_credentials_key)
    }

    public static func initializeCredentialsEncryptionKey() {
        let keyFromKeychain = KeychainAccessor.getCredentialsEncryptionKey()
        if keyFromKeychain == nil {
            var key = Data(count: 64)
            _ = key.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            }

            if !KeychainWrapper.standard.set(key, forKey: KeychainAccessor.app_credentials_key) {
                fatalError("not able to save to keychain")
            }
        }
    }
}
