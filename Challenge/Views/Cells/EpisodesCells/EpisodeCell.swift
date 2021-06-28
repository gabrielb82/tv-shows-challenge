//
//  EpisodeCell.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 26/06/21.
//

import Foundation
import UIKit

class EpisodeCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var airDateLabel: UILabel?
    @IBOutlet weak var durationLabel: UILabel?
    @IBOutlet weak var summaryLabel: UILabel?
    @IBOutlet weak var photoImageView: UIImageView?
    
    // MARK: - Variables
    
    var episode: Episode? {
        didSet {
            nameLabel?.text = "\(episode?.number ?? 0) - \(episode?.name ?? "")"
            airDateLabel?.text = "\(episode?.airdate?.stringDateToPattern() ?? "") - \(episode?.airtime ?? "")"
            durationLabel?.text = "\(episode?.runtime ?? 0)min."
            summaryLabel?.attributedText = episode?.summary?.htmlToAttributedString
            if let imageURL = episode?.image?.medium {
                photoImageView?.downloadImage(from: imageURL, contentMode: .scaleAspectFill)
            }
            else {
                photoImageView?.image = UIImage(named: "no-image")
            }
            
            photoImageView?.roundedCorner(radius: 5)
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
