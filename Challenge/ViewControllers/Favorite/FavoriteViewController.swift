//
//  FavoriteViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 26/06/21.
//

import Foundation
import UIKit
import SwiftSpinner

class FavoriteViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var noFavoritePanel: UIView?
    @IBOutlet weak var favoriteTableView: UITableView?
    
    // MARK: - Declarations
    let homeCellIdentifier = "homeCell"
    var favoriteViewModel: FavoriteViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let favoriteVM = favoriteViewModel {
            favoriteVM.getFavoritesList()
        }
    }
    
    // MARK: - Custom Methods
    func setup() {
        let homeTableViewCell = UINib(nibName: "HomeTableViewCell", bundle: nil)
        self.favoriteTableView?.register(homeTableViewCell, forCellReuseIdentifier: homeCellIdentifier)
        
        self.favoriteTableView?.refreshControl = UIRefreshControl()
        self.favoriteTableView?.refreshControl?.tintColor = .systemRed
        self.favoriteTableView?.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        definesPresentationContext = true
        
        SwiftSpinner.show("Loading...")
        
        favoriteViewModel = FavoriteViewModel()
        favoriteViewModel?.favoriteDelegate = self
        
        favoriteViewModel?.getFavoritesList()
        favoriteTableView?.delegate = self
        favoriteTableView?.dataSource = self
        favoriteTableView?.tableFooterView = UIView()
        
    }
    
    @objc func refreshData() {
        favoriteViewModel?.getFavoritesList()
    }
    
}

// MARK: - Delegates
extension FavoriteViewController: FavoriteDelegate {
    func didGetFavoriteList() {
        if let count = favoriteViewModel?.favorites.count {
            if count > 0 {
                noFavoritePanel?.isHidden = true
                favoriteTableView?.isHidden = false
                favoriteTableView?.reloadData()
            }
            else {
                noFavoritePanel?.isHidden = false
                favoriteTableView?.isHidden = true
            }
        }
        else {
            noFavoritePanel?.isHidden = false
            favoriteTableView?.isHidden = true
        }
        SwiftSpinner.hide()
        favoriteTableView?.refreshControl?.endRefreshing()
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "HomeStoryboard", bundle:nil)
        guard let homeDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ShowDetailViewController") as? HomeDetailsViewController else { return }
        guard let showID = favoriteViewModel?.favorites[indexPath.row].id else { return }
        homeDetailsViewController.showID = Int(showID)
        self.navigationController?.pushViewController(homeDetailsViewController, animated: true)
    }
}

// MARK: - Data Source
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel?.favorites.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.favoriteTableView?.dequeueReusableCell(withIdentifier: homeCellIdentifier, for: indexPath) as! HomeTableViewCell

        cell.setup()

        cell.favorite = self.favoriteViewModel?.favorites[indexPath.row]

        return cell
    }
}
