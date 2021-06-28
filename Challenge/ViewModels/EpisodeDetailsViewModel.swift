//
//  EpisodeDetailsViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 28/06/21.
//

import Foundation

// MARK: - Protocol
protocol EpisodeDetailsDelegate {
    func didGetEpisodeInfo()
    func didFailedToGetEpisodeInfo()
}

class EpisodeDetailsViewModel{
    
    // MARK: - Variables
    
    var episode: Episode? {
        didSet {
            self.episodeDetailsDelegate?.didGetEpisodeInfo()
        }
    }
    
    var episodeDetailsDelegate : EpisodeDetailsDelegate?
    
    // MARK: - Initialization
    
    init(with id: Int) {
        getEpisdeDetails(with: id)
    }
    
    // MARK: - Methods
    
    /**
        Retrieve the data from a given Episode. The result can be a success (which brings the show's data), or a failure (which brings an Error object)
     
        - Parameter id: The ID of the show to be searched over the API (Int)
    */
    func getEpisdeDetails(with id: Int) {
        
        Services.shared.getEpisodeDetails(id: id) { [weak self] result in
            switch result {
                case .success(let episodeDetails):
                    self?.episode = episodeDetails
                case .failure(let error):
                    print(error)
                    self?.episodeDetailsDelegate?.didFailedToGetEpisodeInfo()
            }
        }
    }
}
