//
//  PersonDetailsViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 27/06/21.
//

import Foundation

// MARK: - Protocol
protocol PersonDetailsDelegate {
    func didGetCredits()
}

class PersonDetailsViewModel {
    
    // MARK: - Variables
    
    var person: Person? {
        didSet {
            //self.peopleDelegate?.didGetListOfPeople()
        }
    }
    
    var showsList: [Show?] {
        didSet {
            self.personDetailsDelegate?.didGetCredits()
        }
    }
    
    var personDetailsDelegate: PersonDetailsDelegate?
    
    // MARK: - Initialization
    init() {
        showsList = []
    }
    
    // MARK: - Custom Methods
    
    /**
        Retrieve a list of shows that a given person is credited at. The result can be a success (which brings the list of shows), or a failure (which brings an Error object)
     
        - Parameter personID: The ID of the person to be searched over the API (Int)
        - Parameter role: The role of the person to be searched over the API (Role)
    */
    func getCreditsList(for personID: Int, with role: Role) {
        
        Services.shared.getPersonCredits(for: personID, with: role) { [weak self] result in
            switch result {
                case .success(let shows):
                    self?.showsList = shows.sorted(by: { $0?.name ?? "" < $1?.name ?? ""})
                case .failure(let error):
                    print(error)
            }
        }
    }
}
