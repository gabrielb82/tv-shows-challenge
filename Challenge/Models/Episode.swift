//
//  Episode.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation

struct Episode:Decodable {
    
    let id:Int?
    let url:String?
    let number:Int?
    let season:Int?
    let name:String?
    let airdate:String?
    let airtime:String?
    let airstamp:String?
    let runtime:Int?
    let image:Media?
    let summary:String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case number
        case season
        case name
        case airdate
        case airtime
        case airstamp
        case runtime
        case image
        case summary
    }
}
