//
//  LocalAuthorizationService.swift
//  FaceIdTest
//
//  Created by Дмитрий Никишов on 04.03.2022.
//

import LocalAuthentication
import Foundation

class BiometricTypeHumanRepresentation {
    struct Constants {
        static var noneBio: String { "No bio" }
        static var touchBio: String { "Touch Id" }
        static var faceBio: String { "Face Id" }
        static var unknownBio: String { "Unknown bio" }
    }
}

enum BiometricType {
    case none
    case touch
    case face
    case unknown
    
    typealias RawValue = String
     
     var rawValue: String {
         switch self {
         case .none:
             return BiometricTypeHumanRepresentation.Constants.noneBio
         case .touch:
             return BiometricTypeHumanRepresentation.Constants.touchBio
         case .face:
             return BiometricTypeHumanRepresentation.Constants.faceBio
         case .unknown:
             return BiometricTypeHumanRepresentation.Constants.unknownBio
         }
     }
     
     init?(rawValue: String) {
         switch rawValue {
         case BiometricTypeHumanRepresentation.Constants.faceBio:
             self = .face
         case BiometricTypeHumanRepresentation.Constants.touchBio:
             self = .touch
         case BiometricTypeHumanRepresentation.Constants.noneBio:
             self = .none
         default:
             self = .unknown
         }
     }
}

class LocalAuthorizationService {
    
    static var shared: LocalAuthorizationService = {
       return LocalAuthorizationService()
    }()
    
    private init() {}
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void)
    {
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authorize"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                
                    guard success, error == nil else {
                        authorizationFinished(false)
                        return
                    }
                    
                    authorizationFinished(true)
            }
        }
    }
    
    func getBiometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            @unknown default:
                return .unknown
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
}
