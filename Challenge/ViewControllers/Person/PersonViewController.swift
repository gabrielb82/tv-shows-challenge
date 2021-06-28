//
//  PersonViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 27/06/21.
//

import Foundation
import UIKit

class PersonViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var personTableView: UITableView?
    
    // MARK: - Variables
    
    var personViewModel: PersonViewModel?
    
    var showID: Int?
    
    let personCellIdentifier = "PersonCell"
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Custom Methods
    
    func setup() {
        registerCells()
        personViewModel = PersonViewModel()
        personViewModel?.peopleDelegate = self
        
        searchBar?.delegate = self
        personTableView?.delegate = self
        personTableView?.dataSource = self
        personTableView?.tableFooterView = UIView()
        
    }
    
    func registerCells() {
        let episodeCell = UINib(nibName: "PersonCell", bundle: nil)
        self.personTableView?.register(episodeCell, forCellReuseIdentifier: personCellIdentifier)
    }
    
    func searchPerson(with name: String) {
        personViewModel?.getPersonList(with: name)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonDetailSegue" {
            guard let personDetailVC = segue.destination as? PersonDetailsViewController else { return }
            
            guard let index = sender as? Int else { return }
            
            personDetailVC.person = self.personViewModel?.people[index]
        }
    }
    
}

// MARK: - Delegate Extensions
extension PersonViewController: PeopleDelegate {
    func didGetListOfPeople() {
        DispatchQueue.main.async {
            self.personTableView?.reloadData()
        }
    }
}

extension PersonViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            searchPerson(with: searchText)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension PersonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PersonDetailSegue", sender: indexPath.row)
    }
}

// MARK: - Data Source Extensions
extension PersonViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personViewModel?.people.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: personCellIdentifier) as? PersonCell else {
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        guard let person = personViewModel?.people[indexPath.row] else {
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        cell.person = person
        
        return cell
    }
    
}
