//
//  RegisterPINViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 25/06/21.
//

import Foundation
import UIKit

protocol RegisterCompletedDelegate {
    func didRegisteredPIN()
}

class RegisterPINViewController: UIViewController {
    
    var pinViewModel: PINViewModel?
    var registerCompletedDelegate: RegisterCompletedDelegate?
    
    @IBOutlet weak var pinTextField: UITextField?
    @IBOutlet weak var pin1ImageView: UIImageView?
    @IBOutlet weak var pin2ImageView: UIImageView?
    @IBOutlet weak var pin3ImageView: UIImageView?
    @IBOutlet weak var pin4ImageView: UIImageView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var dotsView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        pinViewModel = PINViewModel()
        pinViewModel?.pinDelegate = self
        pinViewModel?.registerPINDelegate = self
        
        pinTextField?.delegate = self
        pinTextField?.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        self.view.addGestureRecognizer(tap)
    }
    
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
    
    func updatePINDot(pinDot: UIImageView, toSelected selected: Bool) {
        var dotImage = "circle"
        
        if selected {
            dotImage = "circle.fill"
        }
        
        pinDot.image = UIImage(systemName: dotImage)
    }
    
    func clearScreen() {
        self.pinTextField?.text = ""
        updatePINDot(pinDot: self.pin1ImageView ?? UIImageView(), toSelected: false)
        updatePINDot(pinDot: self.pin2ImageView ?? UIImageView(), toSelected: false)
        updatePINDot(pinDot: self.pin3ImageView ?? UIImageView(), toSelected: false)
        updatePINDot(pinDot: self.pin4ImageView ?? UIImageView(), toSelected: false)
    }
}

extension RegisterPINViewController: UITextFieldDelegate {

}

extension RegisterPINViewController: PINDelegate {
    func didCheckPIN(response: KeyChainResponse) {
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
                self.pinViewModel?.prepareToRegisterPIN(typedPIN: pin)
            }
                
        }
    }
    
}

extension RegisterPINViewController: RegisterPINDelegate {
    func didRegisterPIN(response: KeyChainResponse) {
        
        self.activityIndicator?.stopAnimating()
        switch response {
            case .success:
                self.clearScreen()
                self.dismiss(animated: true) {
                    self.registerCompletedDelegate?.didRegisteredPIN()
                }
            case .failure:
                self.dotsView?.shake()
                self.clearScreen()
        }
        
    }
    
    
}
