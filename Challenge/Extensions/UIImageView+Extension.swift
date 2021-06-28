//
//  UIImageView+Extension.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from urlString: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: urlString) else { return }
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
