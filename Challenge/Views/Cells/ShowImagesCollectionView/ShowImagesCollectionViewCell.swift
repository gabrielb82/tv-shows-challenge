//
//  ShowImagesCollectionViewCell.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 24/06/21.
//

import Foundation

import UIKit

class ShowImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView?
    
    var showImage : Images? {
        didSet {
            if let showImgURL = showImage?.resolutions?.medium?.url {
                photo?.downloadImage(from: showImgURL, contentMode: .scaleAspectFill)
            }
            else {
                photo?.image = UIImage(named: "no-image")
            }
            
            photo?.roundedCorner(radius: 5)
//            photo?.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
            
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
