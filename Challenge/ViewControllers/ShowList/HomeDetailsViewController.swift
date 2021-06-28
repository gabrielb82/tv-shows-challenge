//
//  HomeDetailsViewController.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation
import UIKit
import SwiftSpinner
import ImageViewer


class HomeDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var poster : UIButton?
    @IBOutlet weak var posterLoading : UIActivityIndicatorView?
    @IBOutlet weak var name : UILabel?
    @IBOutlet weak var genres : UILabel?
    @IBOutlet weak var duration : UILabel?
    @IBOutlet weak var favorite : UIButton?
    @IBOutlet weak var ratingView : UIView?
    @IBOutlet weak var ratingLabel : UILabel?
    @IBOutlet weak var ratingSeparator : UIView?
    @IBOutlet weak var statusLabel : UILabel?
    @IBOutlet weak var networkLabel : UILabel?
    @IBOutlet weak var daysLabel : UILabel?
    @IBOutlet weak var timeLabel : UILabel?
    @IBOutlet weak var imagesCollectionView : UICollectionView?
    @IBOutlet weak var castTableView : UITableView?
    @IBOutlet weak var scrollView : UIScrollView?
    @IBOutlet weak var summaryLabel : UILabel?
    
    // MARK: - Declarations
    
    var showID : Int?
    let showImageCellIdentifies = "ShowImagesCell"
    let castCellIdentifies = "ShowCastCell"
    
    var homeDetailsViewModel : HomeDetailsViewModel?
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading...")
        
        setup()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EpisodesListSegue" {
            guard let episodesTVC = segue.destination as? EpisodesTableViewController else { return }
            
            episodesTVC.showID = self.showID
        }
    }
    
    // MARK: - Custom Methods
    
    func setup() {
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "arrow.backward")
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        if let id = showID {
            homeDetailsViewModel = HomeDetailsViewModel(showID: id)
            homeDetailsViewModel?.showDetailsDelegate = self
            self.checkFavorite(with: id)
        }
        
        setupImagesCollectionView()
        setupCastTableView()
        
        poster?.roundedCorner(radius: 10)
        poster?.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 15, scale: true)
        posterLoading?.startAnimating()
        
        ratingView?.roundedCorner(radius: 10)
        ratingSeparator?.roundedCorner(radius: 10)
        
    }
    
    func setupImagesCollectionView() {
        self.imagesCollectionView?.delegate = self
        self.imagesCollectionView?.dataSource = self
        let imagesCVCell = UINib(nibName: "ShowImagesCollectionViewCell", bundle: nil)
        self.imagesCollectionView?.register(imagesCVCell, forCellWithReuseIdentifier: showImageCellIdentifies)
    }
    
    func setupCastTableView() {
        self.castTableView?.delegate = self
        self.castTableView?.dataSource = self
        let castTVCell = UINib(nibName: "ShowCastCell", bundle: nil)
        self.castTableView?.register(castTVCell, forCellReuseIdentifier: castCellIdentifies)
    }
    
    func loadPosterImage() {
        if let posterImageURL = URL(string: self.homeDetailsViewModel?.show?.image?.original ?? "" ) {
            do {
                try self.poster?.setImage(UIImage(withContentsOfUrl: posterImageURL), for: .normal)
            } catch {
                self.poster?.setImage(UIImage(named: "no-image"), for: .normal)
            }
        }
        else {
            self.poster?.setImage(UIImage(named: "no-image"), for: .normal)
        }
        
        self.poster?.imageView?.backgroundColor = .clear
        self.poster?.imageView?.roundedCorner(radius: 10)
        self.poster?.imageView?.contentMode = .scaleAspectFill
        self.posterLoading?.stopAnimating()
    }
    
    func setShowPrimaryInfo() {
        var premierYear = "-"
        if let pYear  = self.homeDetailsViewModel?.show?.premierDate?.getYear() {
            premierYear = "\(pYear)"
        }
        self.name?.text = "\(self.homeDetailsViewModel?.show?.name ?? "-") (\(premierYear))"
        self.genres?.text = self.homeDetailsViewModel?.show?.genres?.joined(separator: ", ")
        self.duration?.text = "Duration: \(self.homeDetailsViewModel?.show?.runtime ?? 0)min."
        
        self.ratingLabel?.text = "\(self.homeDetailsViewModel?.show?.rating?.average ?? 0)".replacingOccurrences(of: ".", with: ",")
        setupRatingsView(score: self.homeDetailsViewModel?.show?.rating?.average ?? 0)
        
        self.statusLabel?.text = self.homeDetailsViewModel?.show?.status
        self.networkLabel?.text = self.homeDetailsViewModel?.show?.network?.name
        self.daysLabel?.text = self.homeDetailsViewModel?.show?.schedule?.days?.joined(separator: ", ")
        self.timeLabel?.text = self.homeDetailsViewModel?.show?.schedule?.time
        self.summaryLabel?.attributedText = self.homeDetailsViewModel?.show?.summary?.htmlToAttributedString
        
        if self.homeDetailsViewModel?.show?.status == "Ended" {
            self.statusLabel?.textColor = .systemRed
        }
        else {
            self.statusLabel?.textColor = .systemGreen
        }
    }
    
    func setupRatingsView(score: Double) {
        
        var ratingColor = UIColor.systemGreen
        
        if score > 8 {
            ratingColor = .systemGreen
        } else if score > 6 {
            ratingColor = .systemOrange
        } else {
            ratingColor = .systemRed
        }
        
        self.ratingView?.backgroundColor = ratingColor
        self.ratingView?.dropShadow(color: ratingColor, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
    }
    
    func checkFavorite(with showID: Int) {
        guard let isFavorite = homeDetailsViewModel?.checkFavorite(with: showID) else { return }
        if isFavorite {
            favorite?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    func displayImageFullScreen(from imageView: UIImageView) {
        ImageViewer.show(imageView, presentingVC: self)
    }
    
    // MARK: - Actions
    @IBAction func updateFavorite() {
        guard let show = homeDetailsViewModel?.show else { return }
        
        guard let wasFavorite = self.homeDetailsViewModel?.checkFavorite(with: show.id ?? 0) else { return }
        
        homeDetailsViewModel?.updateFavorite(with: show, completion: { [weak self] response in
            
            switch response {
                case .success:
                    if wasFavorite {
                        self?.favorite?.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                    else {
                        self?.favorite?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                    
                case .failure:
                    ShowAlert.showSimpleAlert(with: "Favorite not saved", message: "An error occurred while saving favorite. Please, try again.", preferredStyle: .alert, viewController: self ?? UIViewController())
            }
        })
        
    }
    
    @IBAction func showEpisodesList(_ sender: UIButton) {
        performSegue(withIdentifier: "EpisodesListSegue", sender: nil)
    }
    
    @IBAction func showPoster(_ sender: UIButton) {
        guard let imageView = sender.imageView else { return }
        displayImageFullScreen(from: imageView)
    }
    
    // MARK: - View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        let screenHeight = UIScreen.main.bounds.height
        guard let scrollViewContentHeight = self.scrollView?.contentSize.height else { return }

        if scrollView == self.scrollView {
            if yOffset >= scrollViewContentHeight - screenHeight {
                scrollView.isScrollEnabled = false
                self.castTableView?.isScrollEnabled = true
            }
        }

        if scrollView == self.castTableView {
            if yOffset <= 0 {
                self.scrollView?.isScrollEnabled = true
                self.castTableView?.isScrollEnabled = false
            }
        }
    }
    
}

// MARK: - Delegate Extensions
extension HomeDetailsViewController : ShowDetailsDelegate {
    func didFailtToGetShowDetails() {
        DispatchQueue.main.async {
            SwiftSpinner.hide()
            
            self.navigationController?.popViewController(animated: true)
            ShowAlert.showSimpleAlert(with: "Error", message: "Error while loading show details.", preferredStyle: .alert, viewController: self)
        }
    }
    
    func didGetShowCast() {
        DispatchQueue.main.sync {
            self.castTableView?.reloadData()
            
            SwiftSpinner.hide()
        }
    }
    
    func didGetShowDetails() {
        DispatchQueue.main.sync {
            self.navigationController?.navigationBar.topItem?.title = self.homeDetailsViewModel?.show?.name
            
            self.loadPosterImage()
            self.setShowPrimaryInfo()
            
        }
    }
    
    func didGetShowImages() {
        DispatchQueue.main.sync {
            guard let count = self.homeDetailsViewModel?.showImages?.count else {
                return
            }
            if count > 0 {
                self.imagesCollectionView?.reloadData()
            }
            
        }
    }
}

extension HomeDetailsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width / 4, height: width / 4)
    }
    
}

extension HomeDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let _ = self.homeDetailsViewModel?.cast?[indexPath.row] else {
            return 0
        }
        return 87
    }
}

// MARK: - Data Source Extensions
extension HomeDetailsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.homeDetailsViewModel?.showImages?.count else {
            return 0
        }
        return count > 0 ? count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: showImageCellIdentifies, for: indexPath) as? ShowImagesCollectionViewCell
        
        if let showImage = self.homeDetailsViewModel?.showImages?[indexPath.row] {
            cell?.showImage = showImage
        }
        
        return cell ?? UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
}

extension HomeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.homeDetailsViewModel?.cast?.count else {
            return 0
        }
        return count > 0 ? count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: castCellIdentifies) as? ShowCastCell
        
        guard let showCast = self.homeDetailsViewModel?.cast?[indexPath.row] else {
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        cell?.cast = showCast
        
        return cell ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
    }
    
}
