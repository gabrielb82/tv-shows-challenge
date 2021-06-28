//
//  AuthenticationViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 25/06/21.
//

import Foundation

// MARK: - Protocol
protocol AuthenticationDelegate {
    func didChangedAuthenticationPermission(_ response: KeyChainResponse)
}

class AuthenticationViewModel {
    
    // MARK: - Declarations
    
    var authenticationDelegate: AuthenticationDelegate?
    
    /**
        Toggle the permission over the authentication method
     
        - Parameter allow: Defines if the user is allowing the app to authenticate using biometry (Bool)
        */
    func toggleAllowAuthentication(allow: Bool) {
        let allowed = storeAllowAuthentication(allow)
        if allow {
            self.authenticationDelegate?.didChangedAuthenticationPermission(allowed ? .success : .failure)
        }
    }
    
    /**
        Check if the user had selected to authenticate using biometric
     
        Returns a boolean indicating if the user stored on KeyChain, or not, the option to Authenticate using biometry
        */
    func checkIfCanAuthenticate() -> Bool {

        if let canAuthenticate = KeyChain.load(key: "Authenticate")?.to(type: Bool.self) {
            return canAuthenticate
        }
        else {
            return false
        }
    }
    
    /**
        Store on KeyChain if the user select, or not, to authenticate using biometry
     
        - Parameter allow: Allow to authenticate or not (Bool)
        */
    private func storeAllowAuthentication(_ allow: Bool) -> Bool {
        let _ = KeyChain.save(key: "Authenticate", data: Data(from: allow))
        
        return allow
    }
}
