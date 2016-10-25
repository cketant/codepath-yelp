//
//  ViewController.swift
//  yelp
//
//  Created by christopher ketant on 10/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

enum LoadType: Int {
    case hud = 0, pullDown, pullUp
}

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, FilterSettingsDelegate {
    private var searchBar: UISearchBar!
    fileprivate var businesses: [Business]! = []
    fileprivate var filteredBusinesses: [Business]! = []
    fileprivate var isFiltering: Bool = false
    private var isMoreDataLoading = false
    private var loadingMoreView: InfiniteScrollActivityView?
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.searchBusinesses(term: "Thai", loadType: .hud)
    }

    // Mark: UITableView Delegate + DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFiltering {
            return self.filteredBusinesses.count
        }else{
            return self.businesses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BusinessTableViewCell = tableView.dequeueReusableCell(withIdentifier: "yelpCell", for: indexPath) as! BusinessTableViewCell
        var business: Business!
        if self.isFiltering{
            business = self.filteredBusinesses[indexPath.row]
        }else{
            business = self.businesses[indexPath.row]
        }
        cell.placeNameLabel.text    = business.name
        cell.addressLabel.text      = business.address
        cell.tagsLabel.text         = business.categories
        cell.distanceLabel.text      = business.distance
        cell.reviewsLabel.text       = business.reviewCount?.stringValue
        cell.listNumberLabel.text = "\(indexPath.row + 1)."
        if let businessURL = business.imageURL {
            cell.photoImageView.setImageWith(businessURL)
            cell.photoImageView.layer.cornerRadius = 5
            cell.photoImageView.clipsToBounds = true
        }
        if let starsURL = business.ratingImageURL {
            cell.starsImageView.setImageWith(starsURL)
        }
        return cell
    }
    
    // Mark: UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.isMoreDataLoading && !self.isFiltering {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
                self.isMoreDataLoading = true
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                self.loadingMoreView?.frame = frame
                self.loadingMoreView!.startAnimating()
                self.searchBusinesses(term: "Thai", loadType: .pullUp, offset: 20)
            }
        }
    }
    
    // Mark: FilterSettingsDelegate
    
    func searchWithFilters(sort: YelpSortMode?, categories: [String]?, deals: Bool?, distance: String?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.searchWithTerm(term: "Thai", sort: sort, categories: categories, deals: deals, distance: distance) { (businesses: [Business]?, error: Error?) in
            if businesses != nil{
                self.businesses = businesses
            }else{
                self.businesses = []
            }
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // Mark: Utils
    
    fileprivate func searchBusinesses(term: String, loadType: LoadType, offset: Int = 0){
        if loadType == .hud{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        Business.searchWithTerm(term: "Thai", offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if businesses != nil{
                self.businesses.append(contentsOf: businesses!)
                self.tableView.reloadData()
            }
            if loadType == .hud{
                MBProgressHUD.hide(for: self.view, animated: true)
            }else if(loadType == .pullUp){
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                self.loadingMoreView!.isHidden = true
            }
            }
        )

    }
    
    fileprivate func setup(){
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        // Nav bar

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        self.tableView.estimatedRowHeight = 107
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // loading view
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        self.tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        self.tableView.contentInset = insets
    }

     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "filterSegue"{
            let nav = segue.destination as! UINavigationController
            let vc  = nav.viewControllers.first as! FilterViewController
            vc.delegate = self
        }
     }

}

// SearchBar methods
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        self.isFiltering = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        self.isFiltering = false
        self.tableView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.filteredBusinesses = self.businesses
        }else{
            self.filteredBusinesses = self.businesses.filter({
                ($0.name?.contains(searchText))!
            })
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
