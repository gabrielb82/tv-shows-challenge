//
//  ShowAlert.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 25/06/21.
//

import Foundation
import UIKit

class ShowAlert {
    
    static func showSimpleAlert(with title: String, message: String, preferredStyle: UIAlertController.Style, viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(ac, animated: true)
    }

}
