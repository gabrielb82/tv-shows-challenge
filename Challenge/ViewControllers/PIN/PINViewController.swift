//
//  PINViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 25/06/21.
//

import Foundation
import UIKit
import LocalAuthentication

class PINViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pinTextField: UITextField?
    @IBOutlet weak var pin1ImageView: UIImageView?
    @IBOutlet weak var pin2ImageView: UIImageView?
    @IBOutlet weak var pin3ImageView: UIImageView?
    @IBOutlet weak var pin4ImageView: UIImageView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var dotsView: UIView?
    @IBOutlet weak var biometryButton: UIButton?
    
    // MARK: - Declarations
    
    var pinViewModel: PINViewModel?
    var authenticationViewModel: AuthenticationViewModel?
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateAllDots(to: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterPINSegue" {
            if let registerPINVC = segue.destination as? RegisterPINViewController {
                registerPINVC.registerCompletedDelegate = self
            }
        }
    }
    
    // MARK: - Custom Methods
    
    func setup() {
        pinViewModel = PINViewModel()
        pinViewModel?.pinDelegate = self
        
        authenticationViewModel = AuthenticationViewModel()
        authenticationViewModel?.authenticationDelegate = self
        verifyDeviceBiometry()
        
        pinTextField?.delegate = self
        if let canAuthenticate = authenticationViewModel?.checkIfCanAuthenticate() {
            
            if canAuthenticate {
                startAuthentication()
            } else {
                pinTextField?.becomeFirstResponder()
            }
            
        }else {
            pinTextField?.becomeFirstResponder()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        self.view.addGestureRecognizer(tap)
    }
    
    func verifyDeviceBiometry() {
        let context = LAContext()
        switch context.biometricType {
        case .none:
            biometryButton?.isHidden = true
        case .faceID:
            biometryButton?.isHidden = false
            biometryButton?.setImage(UIImage(systemName: "faceid"), for: .normal)
        case .touchID:
            biometryButton?.isHidden = false
            biometryButton?.setImage(UIImage(systemName: "touchid"), for: .normal)
        }
    }
    
    func updatePINDot(pinDot: UIImageView, toSelected selected: Bool) {
        var dotImage = "circle"
        
        if selected {
            dotImage = "circle.fill"
        }
        
        pinDot.image = UIImage(systemName: dotImage)
    }
    
    func updateAllDots(to option: Bool) {
        self.pinTextField?.text = ""
        updatePINDot(pinDot: self.pin1ImageView ?? UIImageView(), toSelected: option)
        updatePINDot(pinDot: self.pin2ImageView ?? UIImageView(), toSelected: option)
        updatePINDot(pinDot: self.pin3ImageView ?? UIImageView(), toSelected: option)
        updatePINDot(pinDot: self.pin4ImageView ?? UIImageView(), toSelected: option)
    }
    
    func alertBiometryUnaviable() {
        ShowAlert.showSimpleAlert(with: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert, viewController: self)
    }
    
    func startAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        self.updateAllDots(to: true)
        self.activityIndicator?.startAnimating()

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself to unlock some awesome features!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self?.activityIndicator?.stopAnimating()
                        self?.performSegue(withIdentifier: "LogInSegue", sender: nil)
                    } else {
                        self?.activityIndicator?.stopAnimating()
                        self?.updateAllDots(to: false)
                        self?.dotsView?.shake()
                    }
                }
            }
        } else {
            self.activityIndicator?.stopAnimating()
            self.updateAllDots(to: false)
            self.alertBiometryUnaviable()
        }
    }
    
    // MARK: - Actions
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func pinTextFieldChanged(_ sender: UITextField) {
        guard var updatedPIN = sender.text else { return }
        if sender.text?.count == 1 {
            updatedPIN = "\(self.pinViewModel?.pin ?? "")\(updatedPIN)"
        }
        self.pinViewModel?.updatePIN(updatedPIN: updatedPIN)
    }
    
    @IBAction func openKeyboard(_ sender: UIButton) {
        self.pinTextField?.becomeFirstResponder()
    }
    
    @IBAction func registerPIN(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterPINSegue", sender: nil)
    }
    
    @IBAction func showBiometricAuthentication(_ sender: UIButton) {
        startAuthentication()
    }
    
}

// MARK: - Delegates

extension PINViewController: UITextFieldDelegate {

}

extension PINViewController: PINDelegate {
    func didCheckPIN(response: KeyChainResponse) {
        self.activityIndicator?.stopAnimating()
        switch response {
            case .success:
                self.updateAllDots(to: false)
                performSegue(withIdentifier: "LogInSegue", sender: nil)
            case .failure:
                self.dotsView?.shake()
                self.updateAllDots(to: false)
        }
    }
    
    func didChangedPIN(pin: String) {
        var pinImageView: UIImageView?
        
        switch pin.count {
            case 1:
                pinImageView = self.pin1ImageView
            case 2:
                pinImageView = self.pin2ImageView
            case 3:
                pinImageView = self.pin3ImageView
            case 4:
                pinImageView = self.pin4ImageView
            default:
                return
        }
        
        DispatchQueue.main.async {
            self.updatePINDot(pinDot: pinImageView ?? UIImageView(), toSelected: true)
        }
        
        if pin.count == 4 {
            self.activityIndicator?.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.pinViewModel?.prepareToCheckPIN(typedPIN: pin)
            }
                
        }
    }
    
}

extension PINViewController: RegisterCompletedDelegate {
    func didRegisteredPIN() {
        self.activityIndicator?.startAnimating()
        self.performSegue(withIdentifier: "LogInSegue", sender: nil)
        self.activityIndicator?.stopAnimating()
        
    }
    
    
}

extension PINViewController: AuthenticationDelegate {
    func didChangedAuthenticationPermission(_ response: KeyChainResponse) {
        if response == .failure {
            self.dotsView?.shake()
        }
    }
}
