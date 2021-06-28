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
    
    /**
        Remove the Favorite from list
     
        - Parameter id: The ID of the Show to be removed from the list of Favorites
        - Parameter completion: Returns a response indicating if the result was a sucess or a failure
    */
    func removeFavorite(with id: Int, completion: @escaping(GenericResponse) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "id = \(id)")
        
        do {
            let result = try managedObjectContext.fetch(request)
            if result.count > 0 {
                if let favorite = result[0] as? Favorite {
                    managedObjectContext.delete(favorite)
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print("error while save.")
                    }
                    completion(.success)
                } else {
                    completion(.failure)
                }
            }
            else {
                completion(.failure)
            }
        } catch {
            completion(.failure)
        }
    }
}
