//
//  EpisodeDetailsViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 28/06/21.
//

import Foundation
import UIKit
import SwiftSpinner
import ImageViewer

class EpisodeDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var numberLabel: UILabel?
    @IBOutlet weak var seasonLabel: UILabel?
    @IBOutlet weak var airDateLabel: UILabel?
    @IBOutlet weak var durationLabel: UILabel?
    @IBOutlet weak var summaryLabel: UITextView?
    @IBOutlet weak var photoButton: UIButton?
    
    // MARK: - Variable
    var episodeID: Int?
    
    var episodeDetailsViewmodel: EpisodeDetailsViewModel?
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Custom Methods
    
    func setup() {
        SwiftSpinner.show("Loading...", animated: true)
        
        guard let id = episodeID else {
            return
        }
        
        episodeDetailsViewmodel = EpisodeDetailsViewModel(with: id)
        
        episodeDetailsViewmodel?.episodeDetailsDelegate = self
        
    }
    
    func updateScreen() {
        
        guard let _ = episodeDetailsViewmodel?.episode?.id else {
            failedToGetData()
            return
        }
        
        self.nameLabel?.text = self.episodeDetailsViewmodel?.episode?.name
        self.seasonLabel?.text = "Season: \(self.episodeDetailsViewmodel?.episode?.season ?? 0)"
        self.numberLabel?.text = "Episode: \(self.episodeDetailsViewmodel?.episode?.number ?? 0)"
        self.airDateLabel?.text = "\(self.episodeDetailsViewmodel?.episode?.airdate?.stringDateToPattern() ?? "-") \(self.episodeDetailsViewmodel?.episode?.airtime ?? "-")"
        self.durationLabel?.text = "\(self.episodeDetailsViewmodel?.episode?.runtime ?? 0) minutes"
        self.summaryLabel?.attributedText = self.episodeDetailsViewmodel?.episode?.summary?.htmlToAttributedString
        
        self.loadEpisodeImage()
        
        self.photoButton?.roundedCorner(radius: 5)
        self.photoButton?.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
        
        SwiftSpinner.hide()
    }
    
    func loadEpisodeImage() {
        if let imageURL = URL(string: self.episodeDetailsViewmodel?.episode?.image?.original ?? "" ) {
            do {
                try self.photoButton?.setImage(UIImage(withContentsOfUrl: imageURL), for: .normal)
            } catch {
                self.photoButton?.setImage(UIImage(named: "no-image"), for: .normal)
            }
        }
        else {
            self.photoButton?.setImage(UIImage(named: "no-image"), for: .normal)
        }
        
        self.photoButton?.imageView?.backgroundColor = .clear
        self.photoButton?.imageView?.roundedCorner(radius: 10)
        self.photoButton?.imageView?.contentMode = .scaleAspectFill
    }
    
    func failedToGetData() {
        SwiftSpinner.hide()
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            ShowAlert.showSimpleAlert(with: "Error", message: "Error while loading episode info.", preferredStyle: .alert, viewController: self)
        }
        
    }
    
    // MARK: - Action
    @IBAction func openPhoto(_ sender: UIButton) {
        guard let imageView = sender.imageView else { return }
        ImageViewer.show(imageView, presentingVC: self)
    }
}

extension EpisodeDetailsViewController: EpisodeDetailsDelegate {
    func didGetEpisodeInfo() {
        
        DispatchQueue.main.async {
            self.updateScreen()
        }
    }
    
    func didFailedToGetEpisodeInfo() {
        
        DispatchQueue.main.async {
            self.failedToGetData()
        }
    }
    
    
}
