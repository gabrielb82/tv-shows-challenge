//
//  EpisodesViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 26/06/21.
//

import Foundation

// MARK: - Protocol
protocol EpisodesDelegate {
    func didGetEpisodesList()
}

class EpisodesViewModel {
    
    // MARK: - Variables
    var episodes: [Episode]?
    var seasonsWithEpisodes : [Int: [Episode]] {
        didSet {
            self.episodesDelegate?.didGetEpisodesList()
        }
    }
    var episodesDelegate: EpisodesDelegate?
    
    // MARK: - Initialization
    init() {
        episodes = []
        seasonsWithEpisodes = [Int: [Episode]]()
    }
    
    // MARK: - Custom Methods
    
    /**
        Organize the episodes list dividing the episodes in seasons
    */
    func organizeEpisodesInSeasons() {
        guard let episodesList = episodes else { return }
        seasonsWithEpisodes = Dictionary(grouping: episodesList) { $0.season ?? 0 }
    }
    
    /**
        Retrieve the list of episodes from a given Show. The result can be a success (which brings the show's episodes), or a failure (which brings an Error object)
     
        - Parameter showID: The ID of the show to be searched over the API (Int)
    */
    func getEpisodesList(from showID: Int) {
        Services.shared.getShowEpisodesList(id: showID) { [weak self] result in
            switch result {
                case .success(let showEpisodes):
                    self?.episodes = showEpisodes
                    self?.organizeEpisodesInSeasons()
                case .failure(let error):
                    print(error)
            }
        }
    }
}
