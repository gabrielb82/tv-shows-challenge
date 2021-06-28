//
//  UIImage+Extension.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 24/06/21.
//

import Foundation
import UIKit

extension UIImage {

    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
    
        self.init(data: imageData)
    }

}
