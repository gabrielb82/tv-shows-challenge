//
//  PersonDetailsViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 27/06/21.
//

import Foundation
import UIKit
import SwiftSpinner

class PersonDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profilePictureImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var countryLabel: UILabel?
    @IBOutlet weak var genderLabel: UILabel?
    @IBOutlet weak var birthDayLabel: UILabel?
    @IBOutlet weak var deathDayLabel: UILabel?
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl?
    @IBOutlet weak var roleTableView: UITableView?
    @IBOutlet weak var rolePanel: UIView?
    @IBOutlet weak var roleActvityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var scrollView : UIScrollView?
    
    // MARK: - Variables
    
    var person: Person?
    
    var personDetailsViewModel : PersonDetailsViewModel?
    
    let homeCellIdentifier = "homeCell"
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Custom Methods
    func setup() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        roleSegmentedControl?.setTitleTextAttributes(titleTextAttributes, for: .normal)
        fillScreen()
        
        personDetailsViewModel = PersonDetailsViewModel()
        personDetailsViewModel?.personDetailsDelegate = self
        
        self.roleTableView?.delegate = self
        self.roleTableView?.dataSource = self
        
        let homeTableViewCell = UINib(nibName: "HomeTableViewCell", bundle: nil)
        self.roleTableView?.register(homeTableViewCell, forCellReuseIdentifier: homeCellIdentifier)
        
        self.getPersonCredits(for: .cast)
    }
    
    func fillScreen() {
        if let imageURL = person?.image?.medium {
            profilePictureImageView?.downloadImage(from: imageURL, contentMode: .scaleAspectFill)
        }
        else {
            profilePictureImageView?.image = UIImage(named: "no-image")
        }
        
        profilePictureImageView?.roundedCorner(radius: (profilePictureImageView?.frame.width ?? 0) / 2)
        profilePictureImageView?.layer.borderWidth = 3
        profilePictureImageView?.layer.borderColor = #colorLiteral(red: 0.6362686157, green: 0.1538973153, blue: 0.1270860732, alpha: 1)
        
        nameLabel?.text = person?.name ?? "-"
        countryLabel?.text = person?.country?.name ?? "-"
        genderLabel?.text = person?.gender ?? "-"
        birthDayLabel?.text = person?.birthday?.stringDateToPattern() ?? "-"
        deathDayLabel?.text = person?.deathday?.stringDateToPattern() ?? "-"
    }
    
    func getPersonCredits(for role: Role) {
        self.rolePanel?.isHidden = false
        self.roleActvityIndicator?.startAnimating()
        
        self.personDetailsViewModel?.getCreditsList(for: person?.id ?? 0, with: role)
    }
    
    // MARK: - Actions
    
    @IBAction func roleChanged(_ sender: UISegmentedControl) {
        
        var role = Role.cast
        
        switch sender.selectedSegmentIndex {
        case 0:
            role = .cast
        case 1:
            role = .crew
        default:
            role = .cast
        }
        
        self.getPersonCredits(for: role)
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        let screenHeight = UIScreen.main.bounds.height
        guard let scrollViewContentHeight = self.scrollView?.contentSize.height else { return }

        if scrollView == self.scrollView {
            if yOffset >= scrollViewContentHeight - screenHeight {
                scrollView.isScrollEnabled = false
                self.roleTableView?.isScrollEnabled = true
            }
        }

        if scrollView == self.roleTableView {
            if yOffset <= 0 {
                self.scrollView?.isScrollEnabled = true
                self.roleTableView?.isScrollEnabled = false
            }
        }
    }
    
}

// MARK: - Delegate Extensions
extension PersonDetailsViewController: PersonDetailsDelegate {
    func didGetCredits() {
        DispatchQueue.main.async {
            self.roleTableView?.reloadData()
            self.rolePanel?.isHidden = true
            self.roleActvityIndicator?.stopAnimating()
        }
    }
}

extension PersonDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "HomeStoryboard", bundle:nil)
        guard let homeDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ShowDetailViewController") as? HomeDetailsViewController else { return }
        guard let show = self.personDetailsViewModel?.showsList[indexPath.row] else { return }
        
        homeDetailsViewController.showID = show.id
        self.navigationController?.pushViewController(homeDetailsViewController, animated: true)
    }
}

// MARK: - Data Source Extensions
extension PersonDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personDetailsViewModel?.showsList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdentifier) as? HomeTableViewCell else {
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        guard let show = self.personDetailsViewModel?.showsList[indexPath.row] else {
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        cell.setup()
        
        cell.show = show
        
        return cell
        
    }
    
    
}
