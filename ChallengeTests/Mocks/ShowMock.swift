//
//  ShowMock.swift
//  ChallengeTests
//
//  Created by Gabriel Barbosa on 27/06/21.
//

import Foundation

class ShowMock{
    static func createShow() -> Show? {
        let show = Show(id: 1, url: "", type: "", name: "New TV Show", language: "English", genres: ["Drama"], status: "ended", runtime: 60, premiered: "2021-06-25", schedule: nil, rating: nil, network: nil, image: nil, summary: "", updated: 0)
        
        return show
    }
}
