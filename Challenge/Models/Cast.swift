//
//  Cast.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 24/06/21.
//

import Foundation

struct Cast: Decodable {
    
    let person: Person?
    let showCharacter: ShowCharacter?

    enum CodingKeys: String, CodingKey {
        
        case person
        case showCharacter = "character"

    }
}
