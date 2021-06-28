//
//  HomeDetailsViewModel.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation
import CoreData
import UIKit

// MARK: - Protocol
protocol ShowDetailsDelegate {
    func didGetShowDetails()
    func didFailtToGetShowDetails()
    func didGetShowImages()
    func didGetShowCast()
}

class HomeDetailsViewModel {
    
    // MARK: - Declarations
    
    var showDetailsDelegate : ShowDetailsDelegate?
    
    var show : Show? {
        didSet {
            self.showDetailsDelegate?.didGetShowDetails()
            if let id = show?.id {
                getShowImages(showID: id)
            }
        }
    }
    
    var showImages: [Images]? {
        didSet {
            self.showDetailsDelegate?.didGetShowImages()
            if let id = show?.id {
                getShowCast(showID: id)
            }
        }
    }
    
    var cast: [Cast]? {
        didSet {
            self.showDetailsDelegate?.didGetShowCast()
        }
    }
    
    // MARK: - Initialization
    
    init(showID: Int) {
        getShowDetails(showID: showID)
    }
    
    // MARK: - Methods
    
    /**
        Retrieve the data from a given Show. The result can be a success (which brings the show's data), or a failure (which brings an Error object)
     
        - Parameter showID: The ID of the show to be searched over the API (Int)
    */
    func getShowDetails(showID: Int) {
        Services.shared.getShowDetails(id: showID) { [weak self] result in
            switch result {
                case .success(let showDetails):
                    self?.show = showDetails
                case .failure(let error):
                    print(error)
                    self?.showDetailsDelegate?.didFailtToGetShowDetails()
            }
        }
    }
    
    /**
        Retrieve the images from a given Show. The result can be a success (which brings the show's images), or a failure (which brings an Error object)
     
        - Parameter showID: The ID of the show to be searched over the API (Int)
    */
    func getShowImages(showID: Int) {
        Services.shared.getShowImages(id: showID) { [weak self] result in
            switch result {
                case .success(let showImgs):
                    self?.showImages = showImgs
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    /**
        Retrieve the cast from a given Show. The result can be a success (which brings the show's cast), or a failure (which brings an Error object)
     
        - Parameter showID: The ID of the show to be searched over the API (Int)
    */
    func getShowCast(showID: Int) {
        Services.shared.getShowCast(id: showID) { [weak self] result in
            switch result {
                case .success(let showCast):
                    self?.cast = showCast
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    /**
        Update the Favorite list with the selected show
     
        - Parameter show: The Show to be saved or removed from the list
        - Parameter completion: Returns a response indicating if the result was a sucess or a failure
    */
    func updateFavorite(with show: Show, completion: @escaping(GenericResponse) -> Void) {
        
        guard let id = show.id else { return }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        if let favorite = getFavorite(from: id) {
            do {
                managedObjectContext.delete(favorite)
                completion(.success)
            }
        }
        else {
            do {
                let _ = Favorite(from: show)
                try managedObjectContext.save()
                completion(.success)
                
            } catch {
                completion(.failure)
            }
        }
    }
    
    /**
        Check if a given show is saved on the Favorite list
     
        - Parameter showID: The ID Show to be searched on CoreDate
    */
    func checkFavorite(with showID: Int) -> Bool {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "id = \(showID)")
        
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
            }
            
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            
            let result = try managedObjectContext.fetch(request)
            if result.count > 0 {
                return true
            }
            else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /**
        Get Favorite show from ID
     
        - Parameter showID: The ID Show to be searched on CoreDate
    */
    func getFavorite(from id: Int) -> Favorite? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "id = \(id)")
        
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return nil
            }
            
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            
            let result = try managedObjectContext.fetch(request)
            if result.count > 0 {
                return result[0] as? Favorite
            }
            else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
}
