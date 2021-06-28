//
//  Person.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation

struct Person:Decodable {
    
    let id:Int?
    let url:String?
    let name:String?
    let country:Country?
    let birthday:String?
    let deathday:String?
    let gender:String?
    let image:Media?
    let showCharacter: ShowCharacter?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case url
        case name
        case country
        case birthday
        case deathday
        case gender
        case image
        case showCharacter = "character"

    }
    
}
