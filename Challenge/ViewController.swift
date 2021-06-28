//
//  ViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 22/06/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getShowList()
    }
    
    func getShowList() {
        Services.shared.getShowList(page: 1) { result in
            switch result {
                case .success(let showList):
                    print(showList)
                case .failure(let error):
                    print(error)
            }
        }
    }


}

