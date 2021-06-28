//
//  PINViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 25/06/21.
//

import Foundation

// MARK: - Protocol
protocol PINDelegate {
    func didChangedPIN(pin: String)
    func didCheckPIN(response: KeyChainResponse)
}

protocol RegisterPINDelegate {
    func didRegisterPIN(response: KeyChainResponse)
}

class PINViewModel {
    
    // MARK: - Declarations
    var pinDelegate : PINDelegate?
    var registerPINDelegate : RegisterPINDelegate?
    
    var pin: String?
    
    func updatePIN(updatedPIN: String) {
        if updatedPIN.count <= 4 {
            pin = updatedPIN
            self.pinDelegate?.didChangedPIN(pin: updatedPIN)
        }
        else {
            pin = ""
            self.pinDelegate?.didCheckPIN(response: .failure)
        }
    }
    
    func prepareToCheckPIN(typedPIN: String) {
        guard let pinInt = Int64(typedPIN) else { return }
        
        self.pin = ""
            
        if checkPIN(typedPIN: pinInt) {
            self.pinDelegate?.didCheckPIN(response: .success)
        }
        else {
            self.pinDelegate?.didCheckPIN(response: .failure)
        }
    }
    
    func prepareToRegisterPIN(typedPIN: String) {
        self.pin = ""
            
        if storePIN(with: typedPIN) {
            self.registerPINDelegate?.didRegisterPIN(response: .success)
        }
        else {
            self.registerPINDelegate?.didRegisterPIN(response: .failure)
        }
    }
    
    private func checkPIN(typedPIN: Int64) -> Bool {
        if let receivedPIN = KeyChain.load(key: "MyPIN") {
            let storedPIN = receivedPIN.to(type: Int64.self)
            if typedPIN == storedPIN {
                return true
            }
        }
        
        return false
    }
    
    private func storePIN(with typedPIN: String) -> Bool {
        guard let pinInt = Int64(typedPIN) else { return false }
        let _ = KeyChain.save(key: "MyPIN", data: Data(from: pinInt))
        
        return true
    }
}
