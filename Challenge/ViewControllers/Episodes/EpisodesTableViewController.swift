//
//  EpisodesTableViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 26/06/21.
//

import Foundation
import UIKit
import SwiftSpinner

class EpisodesTableViewController: UITableViewController {
    
    // MARK: - Variables
    var episodesViewModel: EpisodesViewModel?
    
    var showID: Int?
    
    let episodeCellIdentifier = "EpisodeCell"
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Custom Methods
    
    func setup() {
        registerCells()
        episodesViewModel = EpisodesViewModel()
        episodesViewModel?.episodesDelegate = self
        
        SwiftSpinner.show("Loading...", animated: true)
        
        self.tableView.tableFooterView = UIView()
        
        episodesViewModel?.getEpisodesList(from: showID ?? 0)
    }
    
    func registerCells() {
        let episodeCell = UINib(nibName: "EpisodeCell", bundle: nil)
        self.tableView.register(episodeCell, forCellReuseIdentifier: episodeCellIdentifier)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let episodeID = sender as? Int else { return }
        
        if segue.identifier == "EpisodeDetailsSegue" {
            if let episodeDetailsVC = segue.destination as? EpisodeDetailsViewController {
                episodeDetailsVC.episodeID = episodeID
            }
        }
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let index = episodesViewModel?.seasonsWithEpisodes.sorted(by: {$0.key < $1.key}).map({Int($0.key) })[indexPath.section] {
            if let episodeID = self.episodesViewModel?.seasonsWithEpisodes[index]?[indexPath.row].id {
                
                performSegue(withIdentifier: "EpisodeDetailsSegue", sender: episodeID)
            }
        }
    }
    
    // MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return episodesViewModel?.seasonsWithEpisodes.keys.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let index = episodesViewModel?.seasonsWithEpisodes.sorted(by: {$0.key < $1.key}).map({Int($0.key) })[section] {
            return episodesViewModel?.seasonsWithEpisodes[index]?.count ?? 0
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let seasonCell = (Bundle.main.loadNibNamed("SeasonCell", owner: self, options: nil)![0] as? SeasonCell)
        
        if let index = episodesViewModel?.seasonsWithEpisodes.sorted(by: {$0.key < $1.key}).map({Int($0.key) })[section] {
            seasonCell?.seasonNumber = index
        }
        
        return seasonCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: episodeCellIdentifier) as? EpisodeCell else {
            return UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        
        if let index = episodesViewModel?.seasonsWithEpisodes.sorted(by: {$0.key < $1.key}).map({Int($0.key) })[indexPath.section] {
            cell.episode = self.episodesViewModel?.seasonsWithEpisodes[index]?[indexPath.row]
        }
        
        return cell
    }
}

// MARK: - Extensions
extension EpisodesTableViewController: EpisodesDelegate {
    func didGetEpisodesList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
}

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}
