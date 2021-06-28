//
//  PersonViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 27/06/21.
//

import Foundation

// MARK: - Protocol
protocol PeopleDelegate {
    func didGetListOfPeople()
}

class PersonViewModel {
    
    // MARK: - Variables
    
    var people: [Person?] {
        didSet {
            self.peopleDelegate?.didGetListOfPeople()
        }
    }
    
    var peopleDelegate: PeopleDelegate?
    
    // MARK: - Initialization
    init() {
        people = []
    }
    
    // MARK: - Custom Methods
    
    /**
        Retrieve a list of person filtered by a given query. The result can be a success (which brings the list of person), or a failure (which brings an Error object)
     
        - Parameter query: The ID of the show to be searched over the API (Int)
    */
    func getPersonList(with query: String) {
        Services.shared.getPeopleList(query: query) { [weak self] result in
            switch result {
                case .success(let peopleList):
                    self?.people = peopleList.sorted(by: { $0?.name ?? "" < $1?.name ?? ""})
                case .failure(let error):
                    print(error)
            }
        }
    }
}
