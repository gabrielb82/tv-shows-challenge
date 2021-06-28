//
//  Images.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 24/06/21.
//

import Foundation

struct Images: Decodable {
    let id: Int?
    let type: String?
    let main: Bool?
    let resolutions: Resolutions?
}

struct Resolutions: Decodable {
    let original: PhotoMedia?
    let medium: PhotoMedia?
}

struct PhotoMedia: Decodable {
    let url: String?
    let width: Int?
    let height: Int?
}
