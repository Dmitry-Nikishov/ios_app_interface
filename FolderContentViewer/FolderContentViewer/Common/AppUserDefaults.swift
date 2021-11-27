//
//  AppUserDefaults.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 26.11.2021.
//

import Foundation

enum UserDefaultsKeys : String {
    case settingsViewData
}

struct SettingsViewSetup : Codable {
    var isSortingEnabled : Bool
    var isAscendingMode : Bool
}

class AppUserDefaults {
    static func getSettingsViewSetup() -> SettingsViewSetup? {
        guard let setup = UserDefaults.standard.object(forKey: UserDefaultsKeys.settingsViewData.rawValue) as? String else {
            return nil
        }
        let decoder = JSONDecoder()
        let data = setup.data(using: .utf8)
        if let result = try? decoder.decode(SettingsViewSetup.self, from: data!) {
            return result
        } else {
            return nil
        }
    }
    
    static func saveSettingsViewSetup(setup : SettingsViewSetup) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(setup) {
            let stringStructure = String(data: encoded, encoding: .utf8)
            UserDefaults.standard.set(stringStructure, forKey: UserDefaultsKeys.settingsViewData.rawValue)
        }
    }
}
