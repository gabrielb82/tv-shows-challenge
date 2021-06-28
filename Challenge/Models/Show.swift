//
//  Show.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation

struct Show:Decodable {
    
    let id:Int?
    let url:String?
    let type:String?
    let name:String?
    let language:String?
    let genres:[String]?
    let status:String?
    let runtime:Int?
    let premiered:String?
    let schedule:Schedule?
    let rating:Rating?
    let network:Network?
    let image:Media?
    let summary:String?
    let updated:Int?
    var premierDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: premiered ?? "")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case type
        case name
        case language
        case genres
        case status
        case runtime
        case premiered
        case schedule
        case rating
        case network
        case image
        case summary
        case updated
    }
    
}

struct Schedule:Decodable {
    let time:String?
    let days:[String]?
}

struct Rating:Decodable {
    let average:Double?
}

struct Media:Decodable {
    let medium:String?
    let original:String?
}
