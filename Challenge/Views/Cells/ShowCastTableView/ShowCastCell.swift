//
//  ShowCastCell.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 24/06/21.
//

import Foundation
import UIKit

class ShowCastCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var characterLabel: UILabel?
    @IBOutlet weak var profileImageView: UIImageView?
    
    var cast: Cast? {
        didSet {
            nameLabel?.text = cast?.person?.name
            characterLabel?.text = cast?.showCharacter?.name
            
            if let imageURL = cast?.person?.image?.medium {
                profileImageView?.downloadImage(from: imageURL, contentMode: .scaleAspectFill)
            }
            else {
                profileImageView?.image = UIImage(named: "no-image")
            }
            
            profileImageView?.roundedCorner(radius: 5)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
