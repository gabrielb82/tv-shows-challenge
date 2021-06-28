//
//  HomeTableViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation
import UIKit
import SwiftSpinner

class HomeTableViewController: UITableViewController {
    
    // MARK: - Variables
    var showList = [Show]()
    
    var homeViewModel : HomeViewModel?
    
    let homeCellIdentifier = "homeCell"
    
    var shouldFetchData = true
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Custom Methods
    func setup() {
        let homeTableViewCell = UINib(nibName: "HomeTableViewCell", bundle: nil)
        self.tableView.register(homeTableViewCell, forCellReuseIdentifier: homeCellIdentifier)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .systemRed
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        self.navigationController?.navigationItem.title = "TV SHOWS"
        
        definesPresentationContext = true
        
        SwiftSpinner.show("Loading...")
        
        homeViewModel = HomeViewModel()
        homeViewModel?.showListDelegate = self
        
    }
    
    @objc func refreshData() {
        self.homeViewModel?.refreshData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel?.showList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: homeCellIdentifier, for: indexPath) as! HomeTableViewCell
        
        cell.setup()
        
        cell.show = self.homeViewModel?.showList?[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: indexPath.row)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if shouldFetchData {
            self.tableView.tableFooterView =  self.tableView.dequeueReusableCell(withIdentifier: "FooterCell")
            self.shouldFetchData = false
            self.homeViewModel?.setNextPage()
            self.homeViewModel?.getShowList()
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = sender as? Int else { return }
        guard let show = self.homeViewModel?.showList?[index] else { return }
        
        let homeDetails = segue.destination as? HomeDetailsViewController
        
        homeDetails?.showID = show.id
    }
    
}

// MARK: - Extensions
extension HomeTableViewController : ShowListDelegate {
    
    func didGetShowList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            SwiftSpinner.hide()
            self.shouldFetchData = true
            self.tableView.tableFooterView?.isHidden = true
        }
    }
}
