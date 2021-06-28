//
//  FavoriteRating.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 28/06/21.
//

import Foundation
import CoreData
import UIKit

@objc(FavoriteRating)
class FavoriteRating: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case avarage
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(avarage, forKey: .avarage)
    }
    
    required convenience public init(from rating: Rating) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteRating", in: managedObjectContext) else {
            fatalError("Unable to initialize entity")
            
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        avarage = rating.average ?? 0
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "context"),
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "FavoriteRating", in: managedObjectContext) else {
                fatalError("Could not decode Favorite Rating!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            avarage = try values.decode(Double.self, forKey: .avarage)
        } catch {
            print(error)
        }
    }
}

extension FavoriteRating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRating> {
        return NSFetchRequest<FavoriteRating>(entityName: "FavoriteRating")
    }

    @NSManaged public var avarage: Double

}
