//
//  Services.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation

class Services {
    
    let BASEURL = "http://api.tvmaze.com/"
    
    static let shared = Services()
    
    let session = URLSession.shared
    
    /**
        Function to retrieve list of Shows from the API
     
        - Parameter page: Number of the page to be retrieved
        - Parameter completion: Handles the response from the API
    */
    func getShowList(page:Int?, completion: @escaping(Result<[Show]?, Error>) -> Void ){
        
        let endpoint = "\(BASEURL)\(Endpoints.showList)\(page ?? 0)"
        
        let url = URLRequest(url: URL(string: endpoint)!)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let responseData = data else {
                completion(.failure(AppError.genericError))
                return
            }
            
            guard error == nil else {
                completion(.failure(error ?? AppError.genericError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let showList = try decoder.decode([Show].self, from: responseData)
                completion(.success(showList))
            } catch {
                completion(.failure(AppError.genericError))
            }
            
        })
        
        task.resume()
        
    }
    
    /**
        Function to retrieve the data of a given Show from the API
     
        - Parameter ID: ID of the Show to be retrieved
        - Parameter completion: Handles the response from the API
    */
    func getShowDetails(id:Int?, completion: @escaping(Result<Show?, Error>) -> Void ){
        
        let endpoint = "\(BASEURL)\(Endpoints.showDetail)\(id ?? 0)"
        
        let url = URLRequest(url: URL(string: endpoint)!)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let responseData = data else {
                completion(.failure(AppError.genericError))
                return
            }
            
            guard error == nil else {
                completion(.failure(error ?? AppError.genericError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let showDetail = try decoder.decode(Show.self, from: responseData)
                completion(.success(showDetail))
            } catch {
                completion(.failure(AppError.genericError))
            }
            
        })
        
        task.resume()
        
    }
    
    /**
        Function to retrieve the images of a given Show from the API
     
        - Parameter id: ID of the Show
        - Parameter completion: Handles the response from the API
    */
    func getShowImages(id:Int?, completion: @escaping(Result<[Images]?, Error>) -> Void ){
        
        let endpoint = "\(BASEURL)\(Endpoints.showDetail)\(id ?? 0)\(Endpoints.showImages)"
        
        let url = URLRequest(url: URL(string: endpoint)!)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let responseData = data else {
                completion(.failure(AppError.genericError))
                return
            }
            
            guard error == nil else {
                completion(.failure(error ?? AppError.genericError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let showImages = try decoder.decode([Images].self, from: responseData)
                completion(.success(showImages))
            } catch {
                completion(.failure(AppError.genericError))
            }
            
        })
        
        task.resume()
        
    }
    
    /**
        Function to retrieve the cast of a given Show from the API
     
        - Parameter id: ID of the Show
        - Parameter completion: Handles the response from the API
    */
    func getShowCast(id:Int?, completion: @escaping(Result<[Cast]?, Error>) -> Void ){
        
        let endpoint = "\(BASEURL)\(Endpoints.showDetail)\(id ?? 0)\(Endpoints.showCast)"
        
        let url = URLRequest(url: URL(string: endpoint)!)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let responseData = data else {
                completion(.failure(AppError.genericError))
                return
            }
            
            guard error == nil else {
                completion(.failure(error ?? AppError.genericError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let showCast = try decoder.decode([Cast].self, from: responseData)
                completion(.success(showCast))
            } catch {
                completion(.failure(AppError.genericError))
            }
            
        })
        
        task.resume()
        
    }
    
    /**
        Function to retrieve the list of episodes of a given Show from the API
     
        - Parameter id: ID of the Show
        - Parameter completion: Handles the response from the API
    */
    func getShowEpisodesList(id:Int?, completion: @escaping(Result<[Episode]?, Error>) -> Void ){
        
        let endpoint = "\(BASEURL)\(Endpoints.showDetail)\(id ?? 0)\(Endpoints.episodes)"
        
        let url = URLRequest(url: URL(string: endpoint)!)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let responseData = data else {
                completion(.failure(AppError.genericError))
                return
            }
            
            guard error == nil else {
                completion(.failure(error ?? AppError.genericError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let showEpisodes = try decoder.decode([Episode].self, from: responseData)
                completion(.success(showEpisodes))
            } catch {
                completion(.failure(AppError.genericError))
            }
            
        })
        
        task.resume()
        
    }
    
    /**
        Retrieve a list of people from the API
     
        - Parameter query: The query string for the search (it can be the name of the person)
        - Parameter completion: Handles the response from the API
    */
    func getPeopleList(query:String?, completion: @escaping(Result<[Person?], Error>) -> Void ){
        
        let endpoint = "\(BASEURL)\(Endpoints.search)\(Endpoints.searchPerson)\(query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        let url = URLRequest(url: URL(string: endpoint)!)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let responseData = data else {
                completion(.failure(AppError.genericError))
                return
            }
            
            guard error == nil else {
                completion(.failure(error ?? AppError.genericError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let personResultList = try decoder.decode([PersonResult].self, from: responseData)
                let personList = personResultList.map({ $0.person })
                completion(.success(personList))
            } catch {
                completion(.failure(AppError.genericError))
            }
            
        })
        
        task.resume()
        
    }
    
    /**
        Retrieve a shows that a given person is credited at of people from the API
     
        - Parameter personID: The ID of the person
        - Parameter role: The role of the person to be retieved (either cast or crew)
        - Parameter completion: Handles the response from the API
    */
    func getPersonCredits(for personID:Int?, with role: Role, completion: @escaping(Result<[Show?], Error>) -> Void ){
        
        var roleEndpoint = Endpoints.castCredits
        
        switch role {
        case .cast:
            roleEndpoint = Endpoints.castCredits
        case .crew:
            roleEndpoint = Endpoints.crewCredits
        }
        
        let endpoint = "\(BASEURL)\(Endpoints.people)\(personID ?? 0)\(roleEndpoint)"
        
        let url = URLRequest(url: URL(string: endpoint)!)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let responseData = data else {
                completion(.failure(AppError.genericError))
                return
            }
            
            guard error == nil else {
                completion(.failure(error ?? AppError.genericError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let creditsResultList = try decoder.decode([CreditsResult].self, from: responseData)
                let showList = creditsResultList.map({ $0.embeded?.show })
                completion(.success(showList))
            } catch {
                completion(.failure(AppError.genericError))
            }
            
        })
        
        task.resume()
        
    }
    
    /**
        Retrieve a list of shows filtered by a query string from the API
     
        - Parameter query: The query string for the search (it can be any term)
        - Parameter completion: Handles the response from the API
    */
    func searchShow(query:String?, completion: @escaping(Result<[Show?], Error>) -> Void ){
        
        let endpoint = "\(BASEURL)\(Endpoints.search)\(Endpoints.searchShows)\(query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        guard let urlString = URL(string: endpoint) else {
            completion(.failure(AppError.genericError))
            return
        }
        
        let url = URLRequest(url: urlString)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let responseData = data else {
                completion(.failure(AppError.genericError))
                return
            }
            
            guard error == nil else {
                completion(.failure(error ?? AppError.genericError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let showResultList = try decoder.decode([ShowResult].self, from: responseData)
                let showList = showResultList.map({ $0.show })
                completion(.success(showList))
            } catch {
                completion(.failure(AppError.genericError))
            }
            
        })
        
        task.resume()
        
    }
}
