//
//  Favorite.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 26/06/21.
//

import Foundation
import CoreData
import UIKit

@objc(Favorite)
class Favorite: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case summary
        case rating
        case genres
        case image
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(summary, forKey: .summary)
        try container.encode(rating, forKey: .rating)
    }
    
    required convenience public init(from show: Show) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedObjectContext) else {
            fatalError("Unable to initialize entity")
            
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        
        id = Int16(show.id ?? 0)
        name = show.name ?? ""
        summary = show.summary ?? ""
        genres = show.genres?.joined(separator: ", ") ?? ""
        image = show.image?.medium ?? ""
        rating = FavoriteRating(from: show.rating ?? Rating(average: 0))
        
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "context"),
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedObjectContext) else {
                fatalError("Could not decode Favorite!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(Int16.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            summary = try values.decode(String.self, forKey: .summary)
            genres = try values.decode(String.self, forKey: .genres)
            image = try values.decode(String.self, forKey: .image)
            rating = try values.decode(FavoriteRating.self, forKey: .summary)
        } catch {
            print(error)
        }
    }
}

extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var summary: String
    @NSManaged public var genres: String
    @NSManaged public var image: String
    @NSManaged public var rating: FavoriteRating

}

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
