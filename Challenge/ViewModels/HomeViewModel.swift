//
//  HomeViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation

// MARK: - Protocol
protocol ShowListDelegate {
    func didGetShowList()
}

class HomeViewModel {
    
    // MARK: - Declarations
    
    var showListDelegate : ShowListDelegate?
    
    var currentPage = 0
    
    var showList : [Show]? {
        didSet {
            self.showListDelegate?.didGetShowList()
        }
    }
    
    // MARK: - Initialization
    
    init() {
        self.showList = []
        self.getShowList()
    }
    
    // MARK: - Methods
    
    /**
        Rrefresh the data over the current ViewModel
    */
    func refreshData() {
        self.currentPage = 0
        self.showList?.removeAll()
        self.getShowList()
    }
    
    /**
        Retrieve a list of shows. The result can be a success (which brings a list of Shows and access a Delegate Protocol that can be used to update a TableView), or a failure (which brings an Error object)
    */
    func getShowList() {
        Services.shared.getShowList(page: currentPage) { [weak self] result in
            switch result {
                case .success(let shows):
                    if let tvShows = shows {
                        self?.showList?.append(contentsOf: tvShows)
                    }
                case .failure(let error):
                    print(error)
                    self?.showListDelegate?.didGetShowList()
            }
        }
    }
    
    /**
        Sets the next page
    */
    func setNextPage() {
        self.currentPage += 1
    }
}
