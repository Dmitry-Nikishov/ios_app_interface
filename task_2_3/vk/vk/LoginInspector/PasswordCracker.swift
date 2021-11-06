//
//  PasswordCracker.swift
//  vk
//
//  Created by Дмитрий Никишов on 29.09.2021.
//

import Foundation


class PasswordCrackOperation : Operation {
    private let credentialsChecker : CredentialsChecker
    private let finishedHandler : PasswordCrackerNotificationHandler
    
    private func bruteForce(passwordToUnlock: String) throws -> String {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            let checkerResult = credentialsChecker.areCredentialsOk(login: Credentials.predefinedLogin, password: password)

            switch checkerResult {
            case .success(_) :
                return password
            default :
                ()
            }
        }
        
        // must not be here
        throw ApiError.bruteForceNotAbleToCrackError
    }

    init(credentialsChecker : CredentialsChecker,
         finishedHandler : @escaping PasswordCrackerNotificationHandler) {
        self.credentialsChecker = credentialsChecker
        self.finishedHandler = finishedHandler
        super.init()
    }
    
    override func main() {
        do {
            let password = try bruteForce(passwordToUnlock: Credentials.predefinedPassword)
            self.finishedHandler(.success(password))
        }catch {
            self.finishedHandler(.failure(.bruteForceNotAbleToCrackError))
        }
    }
}

class PasswordCracker {
    private let executor : OperationQueue
    
    init(executor : OperationQueue) {
        self.executor = executor
    }
    
    func asyncCrack(credentialsChecker : CredentialsChecker,
                    finishedHandler : @escaping PasswordCrackerNotificationHandler) {
        self.executor.addOperation(PasswordCrackOperation(credentialsChecker: credentialsChecker,
                                                          finishedHandler: finishedHandler)
                                   )
    }
}
