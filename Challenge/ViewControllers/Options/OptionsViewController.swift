//
//  OptionsViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 25/06/21.
//

import Foundation
import UIKit
import LocalAuthentication

class OptionsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var authenticateSwitch: UISwitch?
    @IBOutlet weak var signOutButton: UIButton?
    
    // MARK: - Declarations
    var authenticationViewModel: AuthenticationViewModel?
    
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        signOutButton?.roundedCorner(radius: 5)
        authenticationViewModel = AuthenticationViewModel()
        
        authenticationViewModel?.authenticationDelegate = self
        
        authenticateSwitch?.isOn = authenticationViewModel?.checkIfCanAuthenticate() ?? false
    }
    
    // MARK: - Actions
    
    @IBAction func toggleCanAuthenticate(_ sender: UISwitch) {
        if sender.isOn {
            startAuthentication()
        }
        else {
            sendToggleAuthentication(sender.isOn)
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Custom Methods
    
    func sendToggleAuthentication(_ allow: Bool) {
        authenticationViewModel?.toggleAllowAuthentication(allow: allow)
    }
    
    func alertAuthenticationFailed() {
        ShowAlert.showSimpleAlert(with: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert, viewController: self)
    }
    
    func alertBiometryUnaviable() {
        ShowAlert.showSimpleAlert(with: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert, viewController: self)
    }
    
    func startAuthentication() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself to unlock some awesome features!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self?.sendToggleAuthentication(true)
                    } else {
                        self?.alertAuthenticationFailed()
                        self?.authenticateSwitch?.isOn = false
                    }
                }
            }
        } else {
            self.alertBiometryUnaviable()
            self.authenticateSwitch?.isOn = false
        }
    }
}

// MARK: - Delegates

extension OptionsViewController : AuthenticationDelegate {
    func didChangedAuthenticationPermission(_ response: KeyChainResponse) {
        if response == .failure {
            self.alertAuthenticationFailed()
        }
    }
    
}
