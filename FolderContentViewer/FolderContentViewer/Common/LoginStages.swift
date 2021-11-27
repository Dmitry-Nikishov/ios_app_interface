//
//  LoginStages.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//

import Foundation

enum LoginState {
    case initialState
    case createPasswordStage1
    case createPasswordStage2
    case checkWithExistingPassword
}
