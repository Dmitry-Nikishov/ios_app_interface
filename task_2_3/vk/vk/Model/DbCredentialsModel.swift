//
//  DbCredentialsModel.swift
//  vk
//
//  Created by Дмитрий Никишов on 29.11.2021.
//

import Foundation
import RealmSwift

@objcMembers class DbAppCredentialsCached: Object {
    dynamic var id: String?
    dynamic var email: String?
    dynamic var password: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class DbAppCredentials {
    let id: String
    let email: String
    let password: String
    
    init(id: String, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}

class DbDataProvider {
    private var realm: Realm?
    
    init(encryptionKey : Data) {
        print("encryption key : \(encryptionKey)")
        var config = Realm.Configuration()
        config.encryptionKey = encryptionKey
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("app_user_credentials_encrypted.realm")
        realm = try? Realm(configuration: config)
    }
    
    func getCredentials(userId : String) -> DbAppCredentials? {
        let credentials = realm?.object(ofType: DbAppCredentialsCached.self, forPrimaryKey: userId)
        if let credentials = credentials {
            let ret = DbAppCredentials(id: credentials.id ?? "",
                                       email: credentials.email ?? "",
                                       password: credentials.password ?? "")
            return ret
        } else {
            return nil
        }
    }
    
    func addCredentials(credentials: DbAppCredentials) {
        let cachedCredentials = DbAppCredentialsCached()
        cachedCredentials.id = credentials.id
        cachedCredentials.email = credentials.email
        cachedCredentials.password = credentials.password
        
        try? realm?.write {
            realm?.add(cachedCredentials)
        }
    }
}

