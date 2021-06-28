//
//  SearchShowViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 27/06/21.
//

import Foundation
import UIKit

class SearchShowViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var showsTableView: UITableView?
    
    // MARK: - Variables
    
    var searchShowViewModel: SearchShowViewModel?
    
    let homeCellIdentifier = "homeCell"
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Custom Methods
    
    func setup() {
        searchBar?.delegate = self
        
        showsTableView?.delegate = self
        showsTableView?.dataSource = self
        
        registerCells()
        
        searchShowViewModel = SearchShowViewModel()
        searchShowViewModel?.searchShowDelegate = self
    }
    
    func registerCells() {
        let homeTableViewCell = UINib(nibName: "HomeTableViewCell", bundle: nil)
        self.showsTableView?.register(homeTableViewCell, forCellReuseIdentifier: homeCellIdentifier)
    }
    
    func searchShows(withTerm query: String) {
        searchShowViewModel?.searchShow(with: query)
    }
}

// MARK: - Delegate extensions
extension SearchShowViewController: SearchShowDelegate {
    func didGetListOfShows() {
        DispatchQueue.main.async {
            self.showsTableView?.reloadData()
        }
    }
}

extension SearchShowViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            searchShows(withTerm: searchText)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension SearchShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "HomeStoryboard", bundle:nil)
        guard let homeDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ShowDetailViewController") as? HomeDetailsViewController else { return }
        guard let show = self.searchShowViewModel?.shows[indexPath.row] else { return }
        
        homeDetailsViewController.showID = show.id
        self.navigationController?.pushViewController(homeDetailsViewController, animated: true)
    }
}

// MARK: - Data Source extensions
extension SearchShowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchShowViewModel?.shows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdentifier) as? HomeTableViewCell else {
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        guard let show = self.searchShowViewModel?.shows[indexPath.row] else {
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        cell.setup()
        
        cell.show = show
        
        return cell
    }
    
}
