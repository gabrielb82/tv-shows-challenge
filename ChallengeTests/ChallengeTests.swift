//
//  ChallengeTests.swift
//  ChallengeTests
//
//  Created by Gabriel Barbosa on 22/06/21.
//

import XCTest
@testable import Challenge

class ChallengeTests: XCTestCase {
    
    var shows : [Show]?
    var show: Show?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRetrieveShowList() {
        
        let asyncDone = expectation(description: "got list")
        
        Services.shared.getShowList(page: 0) { [unowned self] result in
            
            switch result {
            case .success(let showList):
                self.shows = showList
                asyncDone.fulfill()
            case .failure(let error):
                print(error)
                asyncDone.fulfill()
            }
        }
        
        wait(for: [asyncDone], timeout: 10)
        XCTAssertTrue(self.shows?.count ?? 0 > 0)
        
    }
    
    func testIfCanAuthenticate() {
        let authenticationViewModel = AuthenticationViewModel()
        
        authenticationViewModel.toggleAllowAuthentication(allow: true)
        
        let permission = authenticationViewModel.checkIfCanAuthenticate()
        
        XCTAssertTrue(permission)
    }
    
    func testCanUpdateFavoriteList() {
        show = Show(id: -1, url: "", type: "", name: "New TV Show", language: "English", genres: ["Drama"], status: "ended", runtime: 60, premiered: "2021-06-25", schedule: nil, rating: nil, network: nil, image: nil, summary: "", updated: 0)
        
        guard let showMock = show else { return }
        
        let homeDetailsViewModel = HomeDetailsViewModel(showID: showMock.id ?? 00)
        
        homeDetailsViewModel.updateFavorite(with: showMock) { response in
            XCTAssertEqual(GenericResponse.success, response)
        }
        
        homeDetailsViewModel.updateFavorite(with: showMock) { response in
            return
        }
    }
    
    func testCanListFavorite() {
        show = Show(id: -1, url: "", type: "", name: "New TV Show", language: "English", genres: ["Drama"], status: "ended", runtime: 60, premiered: "2021-06-25", schedule: nil, rating: nil, network: nil, image: nil, summary: "", updated: 0)
        
        guard let showMock = show else { return }
        
        let homeDetailsViewModel = HomeDetailsViewModel(showID: showMock.id ?? 00)
        
        homeDetailsViewModel.updateFavorite(with: showMock) { response in
            return
        }
        
        let favoriteViewModel = FavoriteViewModel()
        
        favoriteViewModel.getFavoritesList()
        
        XCTAssertGreaterThan(favoriteViewModel.favorites.count, 0)
        
        homeDetailsViewModel.updateFavorite(with: showMock) { response in
            return
        }
    }

}
