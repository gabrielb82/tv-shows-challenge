//
//  CreditsResult.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 27/06/21.
//

import Foundation

struct CreditsResult: Decodable {
    
    let embeded: Embeded?

    enum CodingKeys: String, CodingKey {
        
        case embeded = "_embedded"

    }
}

struct Embeded:Decodable {
    let show:Show?

    enum CodingKeys: String, CodingKey {

        case show
    }
}
