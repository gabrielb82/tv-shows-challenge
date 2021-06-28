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
    
    // MARK: - Variables
    
    var episode: Episode? {
        didSet {
            nameLabel?.text = "\(episode?.number ?? 0) - \(episode?.name ?? "")"
            airDateLabel?.text = "\(episode?.airdate?.stringDateToPattern() ?? "") - \(episode?.airtime ?? "")"
            durationLabel?.text = "\(episode?.runtime ?? 0)min."
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
