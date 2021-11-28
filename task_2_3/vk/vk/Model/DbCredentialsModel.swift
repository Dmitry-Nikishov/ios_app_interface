//
//  DbCredentialsModel.swift
//  vk
//
//  Created by Дмитрий Никишов on 29.11.2021.
//

import Foundation
import RealmSwift

@objcMembers class DbAppCredentialsCached: Object {
    dynamic var email: String?
    dynamic var password: String?
}

final class DbAppCredentials {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

class DbDataProvider {
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("credentials.realm")
        return try? Realm(configuration: config)
    }
    
    func getCredentials() -> DbAppCredentials? {
        let ret : [DbAppCredentials] = realm?.objects(DbAppCredentialsCached.self).compactMap {
            guard let email = $0.email, let password = $0.password else { return nil }
            return DbAppCredentials(email: email, password: password)
        } ?? []
        
        if ret.count != 0 {
            return ret[0]
        } else {
            return nil
        }
    }
    
    func addCredentials(credentials: DbAppCredentials) {
        let cachedCredentials = DbAppCredentialsCached()
        cachedCredentials.email = credentials.email
        cachedCredentials.password = credentials.password
        
        try? realm?.write {
            realm?.add(cachedCredentials)
        }
    }
}

