//
//  Season.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation

struct Season:Decodable {
    
    let id:Int?
    let url:String?
    let number:Int?
    let name:String?
    let episodeOrder:Int?
    let premierDate:String?
    let endDate:String?
    let netWork:Network?
    let image:Media?
    let summary:String?
    var episodes:[Episode]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case number
        case name
        case episodeOrder
        case premierDate
        case endDate
        case netWork
        case image
        case summary
        case episodes
    }
}
