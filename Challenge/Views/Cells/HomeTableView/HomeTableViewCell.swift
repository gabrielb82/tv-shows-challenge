//
//  HomeTableViewCell.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var genres: UILabel?
    @IBOutlet weak var score: UILabel?
    @IBOutlet weak var showDescription: UILabel?
    @IBOutlet weak var showImage: UIImageView?
    @IBOutlet weak var cardView: UIView?
    
    var show: Show? {
        didSet {
            name?.text = show?.name
            genres?.text = show?.genres?.joined(separator: ", ")
            score?.text = "\(show?.rating?.average ?? 0.0)".replacingOccurrences(of: ".", with: ",")
            showDescription?.attributedText = show?.summary?.htmlToAttributedString
            showImage?.downloadImage(from: show?.image?.medium ?? "https://cdn.neemo.com.br/uploads/settings_webdelivery/logo/3136/image-not-found.jpg0.0")
        }
    }
    
    var favorite: Favorite? {
        didSet {
            name?.text = favorite?.name
            genres?.text = favorite?.genres
            score?.text = "\(favorite?.rating.avarage ?? 0.0)".replacingOccurrences(of: ".", with: ",")
            showDescription?.attributedText = favorite?.summary.htmlToAttributedString
            showImage?.downloadImage(from: favorite?.image ?? "https://cdn.neemo.com.br/uploads/settings_webdelivery/logo/3136/image-not-found.jpg0.0")
        }
    }
    
    func setup() {
        cardView?.roundedCorner(radius: 10)
        showImage?.roundedCorner(radius: 3)
        cardView?.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
