//
//  PasswordCreationHolder.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 25.11.2021.
//

import Foundation

class PasswordCreationHolder {
    private var password : String?
    
    func setStage1Password(password : String) {
        self.password = password
    }
    
    func checkRetypedPassword(password : String) -> Bool {
        if let currentPassword = self.password {
            if password == currentPassword {
                return true
            }
        }
        
        return false
    }
    
    func reset()
    {
        self.password = nil
    }
}
