//
//  PersonCell.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 27/06/21.
//

import Foundation
import UIKit

class PersonCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var photoImageView: UIImageView?
    
    // MARK: - Variables
    
    var person: Person? {
        didSet {
            nameLabel?.text = person?.name
            if let imageURL = person?.image?.medium {
                photoImageView?.downloadImage(from: imageURL, contentMode: .scaleAspectFill)
            }
            else {
                photoImageView?.image = UIImage(named: "no-image")
            }
            
            photoImageView?.roundedCorner(radius: 3)
        }
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
