//
//  ShowAlert.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 25/06/21.
//

import Foundation
import UIKit

class ShowAlert {
    
    static func showSimpleAlert(with title: String, message: String, preferredStyle: UIAlertController.Style, viewController: UIViewController, willNavigateBack: Bool = false) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if willNavigateBack {
            ac.addAction(UIAlertAction(title: "", style: .default, handler: { action in
                viewController.navigationController?.popViewController(animated: true)
            }))
        }else {
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(ac, animated: true)
        }
    }

}
