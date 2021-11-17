//
//  CredentialsInspector.swift
//  vk
//
//  Created by Дмитрий Никишов on 13.09.2021.
//

import Foundation

class LoginCheckerCodeToApiErrorConverter {
    public static func toApi(retCode : Bool) -> InternalApiResult
    {
        if retCode {
            return Result.success(Void())
        } else {
            return Result.failure(ApiError.incorrectPasswordError)
        }
    }
}

class CredentialsInspector : CredentialsChecker {
    func areCredentialsOk(login: String, password: String) -> InternalApiResult {
        return LoginCheckerCodeToApiErrorConverter.toApi(retCode:
                                                            LoginChecker.shared.isLoginAndPasswordCorrect(login: login, password: password)
                                                        )
    }
}
