//
//  SeasonCell.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 26/06/21.
//

import Foundation
import UIKit

class SeasonCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var seasonLabel: UILabel?
    
    // MARK: - Variables
    
    public var seasonNumber: Int? {
        didSet {
            seasonLabel?.text = "Season \(seasonNumber ?? 0)"
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
