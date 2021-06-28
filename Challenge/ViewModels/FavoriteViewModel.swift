//
//  FavoriteViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 26/06/21.
//

import Foundation
import CoreData
import UIKit

// MARK: - Protocol
protocol FavoriteDelegate {
    func didGetFavoriteList()
}

class FavoriteViewModel {
    
    // MARK: - Variables
    
    var favoriteDelegate: FavoriteDelegate?
    
    var favorites : [Favorite] {
        didSet {
            self.favoriteDelegate?.didGetFavoriteList()
        }
    }
    
    // MARK: - Methods
    
    init() {
        favorites = []
        getFavoritesList()
    }
    
    /**
        Get a list of the user's favorite shows
    */
    func getFavoritesList() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            
            guard let result = try managedObjectContext.fetch(request) as? [Favorite] else { return }
            self.favorites = result.sorted { $0.name < $1.name }
        } catch {
            return
        }
    }
}
