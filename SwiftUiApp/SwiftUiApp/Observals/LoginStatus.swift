//
//  LoginStatus.swift
//  SwiftUiApp
//
//  Created by Дмитрий Никишов on 24.02.2022.
//

import SwiftUI

class LoginStatus : ObservableObject, Equatable {
    static func == (lhs: LoginStatus, rhs: LoginStatus) -> Bool {
        return lhs.isLoginOk == rhs.isLoginOk
    }
    
    @Published var isLoginOk : Bool = false
}
