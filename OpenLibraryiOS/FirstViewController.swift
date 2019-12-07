//
//  FirstViewController.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var searchTask: DispatchWorkItem?
    var searchController: UISearchController!
    
    var books: [doc] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        if searchController.isActive == false {
            EmptyMessage(message: "Start by searching for some of your favorite books!", tableView: tableView)
            
            searchController.searchBar.barStyle = .blackOpaque
            searchController.searchBar.searchBarStyle = .minimal
            
        }
        
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "OpenLibrary"
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.isActive == true {
            searchController.searchBar.searchBarStyle = .default
        }
        
        self.searchTask?.cancel()
        
        // Replace previous task with a new one
        let task = DispatchWorkItem { [weak self] in
            print(searchController.searchBar.text)
            // Make URL request here
            
            var setting = ""
            if UserDefaults.standard.integer(forKey: "searchSettings") == 0 {
                setting = "q="
            } else if UserDefaults.standard.integer(forKey: "searchSettings") == 1 {
                setting = "title="
            } else if UserDefaults.standard.integer(forKey: "searchSettings") == 2 {
                setting = "author="
            }
 
            guard let searchKey = searchController.searchBar.text else { return }
            let url = "https://openlibrary.org/search.json?\(setting)\(searchKey)"
            guard let searchUrl = URL(string: url) else { return }
            
            print(searchUrl)
            
            URLSession.shared.dataTask(with: searchUrl, completionHandler: { (data, response, error) in
                guard let data = data else { return }
                do {
                    let object = try JSONDecoder().decode(BookObject.self, from: data)
                    self?.books = object.docs
                    //print(self?.books)
                    print("docs count: ", object.docs.count)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                    
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
                
            }).resume()
            
        }
        self.searchTask = task
        
        // Execute task in 0.75 seconds (if not cancelled !)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("You just cancelled")
        searchController.searchBar.barStyle = .blackOpaque
        searchController.searchBar.searchBarStyle = .minimal
        
        books.removeAll()
        tableView.reloadData()
        
    }
    
    
    // Basic tableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("books count: ", books.count)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if segue.identifier == "DetailVC" {
            navigationItem.title = nil
            let detailVC = segue.destination as! BookDetailViewController
            
            let book = books[(indexPath?.row)!]
            
            detailVC.book = book
        }
    }
    
    func EmptyMessage(message: String, tableView: UITableView) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.blue
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    

}

