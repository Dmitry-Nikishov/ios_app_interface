//
//  CredentialsInspector.swift
//  vk
//
//  Created by Дмитрий Никишов on 13.09.2021.
//

import Foundation

class LoginCheckerCodeToApiErrorConverter {
    public static func toApi(retCode : Bool) -> ApiError
    {
        if retCode {
            return ApiError.success
        } else {
            return ApiError.failure
        }
    }
}

class CredentialsInspector : CredentialsChecker {
    func areCredentialsOk(login: String, password: String) -> ApiError {
        return LoginCheckerCodeToApiErrorConverter.toApi(retCode:
                                                            LoginChecker.shared.isLoginAndPasswordCorrect(login: login, password: password)
                                                        )
    }
}
