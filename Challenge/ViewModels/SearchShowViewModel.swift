//
//  SearchShowViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 27/06/21.
//

import Foundation

// MARK: - Protocol
protocol SearchShowDelegate {
    func didGetListOfShows()
}

class SearchShowViewModel {
    
    // MARK: - Variables
    
    var searchShowDelegate: SearchShowDelegate?
    
    var shows: [Show?] {
        didSet {
            self.searchShowDelegate?.didGetListOfShows()
        }
    }
    
    // MARK: - Initialization
    
    init() {
        shows = []
    }
    
    // MARK: - Custom Methods
    
    /**
        Retrieve a list of shows filtered by a given query. The result can be a success (which brings the list of shows), or a failure (which brings an Error object)
     
        - Parameter query: The ID of the show to be searched over the API (Int)
    */
    func searchShow(with query: String) {
        
        Services.shared.searchShow(query: query) { [weak self] result in
            switch result {
                case .success(let showList):
                    self?.shows = showList.sorted(by: { $0?.name ?? "" < $1?.name ?? ""})
                case .failure(let error):
                    print(error)
            }
        }
    }
}
