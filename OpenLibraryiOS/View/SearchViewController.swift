//
//  SearchViewController.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Lazy initilization of Presenter class
    lazy var presenter = Presenter()
    // Dispatch work for keeping track of continuous search
    var searchTask: DispatchWorkItem?
    
    var searchController: UISearchController!
    
    // The array of books used with this VC
    var books: [doc] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Basic table setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        
        // Basic search controller setup
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        // Adding the search bar as a navigation item in the nav bar
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchBar.showsCancelButton = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Display empty message if user is not actively searching
        if searchController.isActive == false {
            tableView.emptyTableViewMessage(message: "Start by searching for some of your favorite books!", tableView: tableView)
        }
        // Set to true to ensure that the searchController is presented within its bounds
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "OpenLibrary"
    }
    
    // Called when user starts typing in the search bar
    func updateSearchResults(for searchController: UISearchController) {
        // Return if user hasn't started typing yet
        if searchController.searchBar.text == "" {
            return
        }
        
        // Cancel current/previous task
        self.searchTask?.cancel()
        
        // Replace previous task with a new one
        let task = DispatchWorkItem { [weak self] in
            // Build up the proper URL scheme
            guard let searchKey = searchController.searchBar.text else { return }
            guard let searchUrl = self?.presenter.buildURL(searchKey: searchKey) else { return }
            print(searchUrl)
            // Make a call to search API
            self?.presenter.searchAPI(searchURL: searchUrl, completion: { (docs) in
                // Results of escaping completion get saved to our books array
                self?.books = docs
                // Check if search results are empty
                if let count = self?.books.count {
                    if count == 0 {
                        DispatchQueue.main.async {
                            self?.tableView.emptyTableViewMessage(message: "No search results!", tableView: self!.tableView)
                        }
                    } else {
                        // Update UI on main thread
                        DispatchQueue.main.async {
                            if self?.searchController.isActive == true {
                                self?.tableView.backgroundView = nil
                            }
                            self?.tableView.reloadData()
                        }
                    }
                }
            })
            // Scroll table view to top
            self?.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        self.searchTask = task
        
        // Execute task in 0.75 seconds (if not already cancelled!)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
    
    // When search is canceled the books array is cleared and the tableView is properly updated
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        books.removeAll()
        tableView.setContentOffset(CGPoint.zero, animated: false)
        tableView.reloadData()
        tableView.emptyTableViewMessage(message: "Start by searching for some of your favorite books!", tableView: tableView)
    }
    
    // Basic tableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as? TableCell {
            let book = books[indexPath.row]
            cell.setUp(book)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Prepare for segue and pass selected book to the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if segue.identifier == "DetailVC" {
            navigationItem.title = nil
            let detailVC = segue.destination as! BookDetailViewController
            let book = books[(indexPath?.row)!]
            detailVC.book = book
        }
    }
}



